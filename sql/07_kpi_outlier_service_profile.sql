-- Purpose:
-- Analyzes average traffic levels of SMS, Call, and Internet services
-- during outlier events to determine which service drives anomalies.
--
-- Source table:
-- sms_call_internet_mi_all_days_flagged

-- KPI:
-- – Service-Based Outlier Profile

CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.kpi3_outlier_service_profile` AS
SELECT
  cell_id,
  AVG(sms_in + sms_out) AS avg_sms,
  AVG(call_in + call_out) AS avg_call,
  AVG(internet) AS avg_internet
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged`
WHERE is_outlier = 1
GROUP BY cell_id;
