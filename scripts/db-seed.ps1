$ErrorActionPreference = "Stop"
docker exec -i mvp_core_db psql -U core_user -d core < sql/002_seed.sql
