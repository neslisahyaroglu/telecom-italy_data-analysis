-- Purpose:
-- Generates a province-level time series summary
-- to analyze long-term traffic trends.
--
-- Source table:
-- sms_call_internet_mi_all_days_flagged
--
-- KPI:
-- Province Trend Summary

CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.kpi4_province_trend_summary` AS
SELECT
  province_name,
  MIN(daily_activity) AS min_activity,
  MAX(daily_activity) AS max_activity,
  ROUND(MAX(daily_activity) - MIN(daily_activity), 2) AS activity_change
FROM `ndn-project-485520.telecom_italy_data.kpi4_province_daily_activity`
GROUP BY province_name;

