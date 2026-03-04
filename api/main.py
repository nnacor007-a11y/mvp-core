from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel, Field
from typing import Optional, List
import psycopg
from psycopg.rows import dict_row
import uuid
import os
from datetime import date

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://core_user:core_pass@localhost:5433/core")

ALLOWED_TYPES = {
"capex","expansion","new_line","hiring","incident","quality_issue",
"tender","patent","partnership","regulation","supplier_change","cyber_incident"
}

app = FastAPI()

def get_conn():
    return psycopg.connect(DATABASE_URL, row_factory=dict_row)

class CompanyIn(BaseModel):
    name: str
    country: Optional[str] = None

class PlantIn(BaseModel):
    name: str
    company_id: Optional[uuid.UUID] = None
    city: Optional[str] = None
    country: Optional[str] = None

class SignalIn(BaseModel):
    plant_id: uuid.UUID
    type: str
    date: date
    summary: str
    source: Optional[str] = None
    confidence: int = Field(ge=0, le=100)

@app.post("/companies")
def create_company(body: CompanyIn):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO companies (name, country) VALUES (%s,%s) RETURNING *",
                (body.name, body.country)
            )
            return cur.fetchone()

@app.post("/plants")
def create_plant(body: PlantIn):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO plants (name, company_id, city, country) VALUES (%s,%s,%s,%s) RETURNING *",
                (body.name, body.company_id, body.city, body.country)
            )
            return cur.fetchone()

@app.post("/signals")
def create_signal(body: SignalIn):

    if body.type not in ALLOWED_TYPES:
        raise HTTPException(status_code=400, detail="invalid signal type")

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO signals (plant_id,type,date,summary,source,confidence)
                VALUES (%s,%s,%s,%s,%s,%s)
                RETURNING id,plant_id,type,date,summary,source,confidence
                """,
                (body.plant_id, body.type, body.date, body.summary, body.source, body.confidence)
            )
            return cur.fetchone()

@app.get("/plants/{plant_id}/timeline")
def timeline(
    plant_id: uuid.UUID,
    from_date: Optional[date] = Query(None, alias="from"),
    to_date: Optional[date] = Query(None, alias="to"),
    type: Optional[str] = None,
    min_confidence: Optional[int] = None
):

    filters = ["plant_id = %s"]
    params = [plant_id]

    if from_date:
        filters.append("date >= %s")
        params.append(from_date)

    if to_date:
        filters.append("date <= %s")
        params.append(to_date)

    if min_confidence is not None:
        filters.append("confidence >= %s")
        params.append(min_confidence)

    if type:
        types = [t.strip() for t in type.split(",")]
        filters.append("type = ANY(%s)")
        params.append(types)

    where_clause = " AND ".join(filters)

    sql = f"""
    SELECT id,date,type,summary,source,confidence
    FROM signals
    WHERE {where_clause}
    ORDER BY date DESC
    """

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            return cur.fetchall()
