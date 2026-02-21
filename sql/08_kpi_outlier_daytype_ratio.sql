-- Purpose:
-- Calculates the ratio of outlier events for weekdays vs weekends
-- to distinguish behavioral versus operational issues.
--
-- Source table:
-- sms_call_internet_mi_all_days_flagged
--
-- KPI:
-- Outlier Day Type Ratio

CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.kpi3_outlier_daytype_ratio` AS
SELECT
  day_type,
  COUNT(*) AS total_records,
  SUM(is_outlier) AS outlier_count,
  ROUND(SUM(is_outlier) / COUNT(*), 3) AS outlier_ratio
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged`
GROUP BY day_type;
