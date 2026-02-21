-- Purpose:
-- Aggregates outlier counts on an hourly basis to identify peak stress
-- periods in the network.
--
-- Source table:
-- sms_call_internet_mi_all_days_flagged
--
-- KPI:
--Hourly Outlier Intensity

CREATE OR REPLACE TABLE
  `ndn-project-485520.telecom_italy_data.kpi3_outlier_by_hour` AS
SELECT
  hour,
  COUNTIF(is_outlier = 1) AS outlier_count
FROM
  `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged`
GROUP BY
  hour
ORDER BY
  hour;
