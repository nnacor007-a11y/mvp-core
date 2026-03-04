# MVP CORE – Plant Signals Timeline (MVP)

## Requisitos
- Docker Desktop
- Python 3.11+
- Windows PowerShell

## 1) Levantar base de datos
```powershell
docker compose up -d
docker ps
```

## 2) Aplicar migración (PowerShell-friendly)
```powershell
Get-Content .\sql\001_init.sql | docker exec -i mvp_core_db psql -U core_user -d core
```

## 3) Cargar datos de ejemplo (seed)
```powershell
Get-Content .\sql\002_seed.sql | docker exec -i mvp_core_db psql -U core_user -d core
```

## 4) Levantar API
```powershell
Set-Location .\api
if (!(Test-Path .venv)) { python -m venv .venv }
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt

$env:DATABASE_URL = "postgresql://core_user:core_pass@localhost:5433/core"
uvicorn main:app --host 127.0.0.1 --port 8000
```

## API Docs
http://127.0.0.1:8000/docs

## Ejemplos (PowerShell)

### Crear plant
```powershell
Invoke-RestMethod -Method POST http://127.0.0.1:8000/plants `
  -ContentType "application/json" `
  -Body '{ "name":"Example Plant", "company_id":null, "city":"Madrid", "country":"ES" }'
```

### Crear signal
```powershell
Invoke-RestMethod -Method POST http://127.0.0.1:8000/signals `
  -ContentType "application/json" `
  -Body '{ "plant_id":"PLANT_ID", "type":"capex", "date":"2026-03-04", "summary":"Example signal", "source":"test", "confidence":80 }'
```

### Consultar timeline
```powershell
Invoke-RestMethod "http://127.0.0.1:8000/plants/PLANT_ID/timeline?type=capex,hiring&min_confidence=70"
```
