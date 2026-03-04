BEGIN;

-- Companies
INSERT INTO companies (id, name, country) VALUES
('11111111-1111-1111-1111-111111111111','ACME Industrial','ES'),
('22222222-2222-2222-2222-222222222222','Northwind Manufacturing','DE')
ON CONFLICT (id) DO NOTHING;

-- Plants
INSERT INTO plants (id, company_id, name, city, country) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','11111111-1111-1111-1111-111111111111','ACME Plant Madrid','Madrid','ES'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','11111111-1111-1111-1111-111111111111','ACME Plant Valencia','Valencia','ES'),
('cccccccc-cccc-cccc-cccc-cccccccccccc','22222222-2222-2222-2222-222222222222','Northwind Plant Berlin','Berlin','DE')
ON CONFLICT (id) DO NOTHING;

-- Signals (15)
INSERT INTO signals (plant_id, type, date, summary, source, confidence) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','capex','2026-01-10','CAPEX approved for utilities upgrade','internal:board_note_01',85),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','hiring','2026-01-15','Hiring batch announced for maintenance team','https://example.com/acme-hiring',70),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','incident','2026-02-03','Minor incident reported in packaging area','local_report:INC-203',60),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','new_line','2026-02-20','New production line commissioning started','internal:project_lineA',80),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','supplier_change','2026-03-01','Supplier change for pallets','email:procurement_03',65),

('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','expansion','2025-12-12','Warehouse expansion phase 1 planned','https://example.com/val-exp',75),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','tender','2026-01-05','Tender opened for HVAC replacement','tender:HVAC-VAL-0105',78),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','quality_issue','2026-01-22','Quality deviation observed in batch sampling','qms:DEV-889',55),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','regulation','2026-02-11','Regulatory inspection scheduled','regulator:notice_0211',72),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','cyber_incident','2026-02-28','Phishing attempt detected in plant network','soc:case_4491',68),

('cccccccc-cccc-cccc-cccc-cccccccccccc','capex','2026-01-09','Capex request submitted for automation cells','internal:capex_DE_01',62),
('cccccccc-cccc-cccc-cccc-cccccccccccc','partnership','2026-01-30','Partnership signed with robotics integrator','https://example.com/nw-robotics',77),
('cccccccc-cccc-cccc-cccc-cccccccccccc','patent','2026-02-02','Patent filed related to process optimization','patent:EP-12345',73),
('cccccccc-cccc-cccc-cccc-cccccccccccc','hiring','2026-02-18','Hiring operators for 3-shift ramp-up','https://example.com/nw-hiring',69),
('cccccccc-cccc-cccc-cccc-cccccccccccc','new_line','2026-03-02','New line readiness review completed','internal:rr_0302',81);

COMMIT;
