-- Purpose:
-- Calculates the distribution of outlier events by day type (weekday/weekend)
-- and hour to identify temporal patterns of abnormal network behavior.
--
-- Source table:
-- sms_call_internet_mi_all_days_flagged
--
-- KPI:
-- Outlier Temporal Distribution


CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.kpi3_outlier_daytype_hour` AS
SELECT
  day_type,
  hour,
  COUNTIF(is_outlier = 1) AS outlier_count
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged`
GROUP BY
  day_type,
  hour
ORDER BY
  hour;
