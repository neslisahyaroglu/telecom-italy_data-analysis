-- Purpose:
-- Evaluates service-level outlier counts segmented by day type
-- to identify which services are more problematic on weekdays or weekends.
--
-- Source table:
-- sms_call_internet_mi_all_days_flagged
--
-- KPI:
--Day Type × Service Outlier Breakdown

 CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.kpi3_outlier_daytype_service` AS
SELECT
  day_type,
  AVG(sms_in + sms_out) AS avg_sms,
  AVG(call_in + call_out) AS avg_call,
  AVG(internet) AS avg_internet
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged`
WHERE is_outlier = 1
GROUP BY day_type;
