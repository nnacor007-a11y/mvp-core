BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE companies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  country text NULL,
  created_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE plants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NULL REFERENCES companies(id),
  name text NOT NULL,
  city text NULL,
  country text NULL,
  created_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE signals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  plant_id uuid NOT NULL REFERENCES plants(id),
  type text NOT NULL,
  date date NOT NULL,
  summary text NOT NULL,
  source text NULL,
  confidence int NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  CONSTRAINT signals_confidence_range CHECK (confidence >= 0 AND confidence <= 100),
  CONSTRAINT signals_type_allowed CHECK (type IN (
    'capex','expansion','new_line','hiring','incident','quality_issue','tender','patent',
    'partnership','regulation','supplier_change','cyber_incident'
  ))
);

CREATE INDEX idx_signals_plant_date ON signals (plant_id, date DESC, created_at DESC);

COMMIT;
