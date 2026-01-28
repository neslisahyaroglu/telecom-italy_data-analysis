1. TRAFFIC VOLUME KPIs
#### Inbound/Outbound Ratios

-- Cell-level I/O ratios

CREATE OR REPLACE TABLE
`ndn-project-485520.telecom_italy_data.kpi_cell_id_ratio` AS
SELECT 
  cell_id,
  ROUND(SUM(sms_in) / NULLIF(SUM(sms_out), 0), 2) AS sms_io_ratio,
  ROUND(SUM(call_in) / NULLIF(SUM(call_out), 0), 2) AS call_io_ratio,
  CASE 
    WHEN SUM(sms_in) / NULLIF(SUM(sms_out), 0) > 1.2 THEN 'Inbound Heavy'
    WHEN SUM(sms_in) / NULLIF(SUM(sms_out), 0) < 0.8 THEN 'Outbound Heavy'
    ELSE 'Balanced'
  END AS traffic_direction
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_cleaned`
GROUP BY cell_id
ORDER BY cell_id;
