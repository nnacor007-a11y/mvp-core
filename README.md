# MVP CORE – Plant Signals Timeline

## Requisitos
- Docker Desktop
- Python 3.11+
- PowerShell

## 1. Levantar base de datos
docker compose up -d

## 2. Aplicar migración
Get-Content .\sql\001_init.sql | docker exec -i mvp_core_db psql -U core_user -d core

## 3. Cargar datos de ejemplo
Get-Content .\sql\002_seed.sql | docker exec -i mvp_core_db psql -U core_user -d core

## 4. Levantar API
cd api
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt

$env:DATABASE_URL = "postgresql://core_user:core_pass@localhost:5433/core"

uvicorn main:app --host 127.0.0.1 --port 8000

## API Docs
http://127.0.0.1:8000/docs

## Ejemplos

### Crear plant
curl -Method POST http://127.0.0.1:8000/plants 
  -Headers @{ "Content-Type" = "application/json" } 
  -Body '{"name":"Example Plant","city":"Madrid","country":"ES"}'

### Crear signal
curl -Method POST http://127.0.0.1:8000/signals 
  -Headers @{ "Content-Type" = "application/json" } 
  -Body '{"plant_id":"PLANT_ID","type":"capex","date":"2026-03-04","summary":"Example signal","confidence":80}'

### Consultar timeline
curl "http://127.0.0.1:8000/plants/PLANT_ID/timeline"
