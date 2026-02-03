-- ===============================================================
-- KPI NAME:
-- kpi4_province_daytype_activity
--
-- PURPOSE:
-- Summarizes activity totals for each province based on day type:
-- Weekday vs Weekend. Helps analyze differences in user behavior
-- between these temporal categories.
--
-- LOGIC SUMMARY:
-- 1. Categorize each record into Weekday or Weekend.
-- 2. Aggregate total activity per (province, day_type, date, hour)
-- 3. Useful for bar charts and behavioral segmentation dashboards.
--
-- SOURCE TABLE:
-- mi_to_provinces_all_days
--
-- USAGE:
-- Ideal for comparing operational demand between weekdays
-- and weekends and identifying behavior-driven patterns.
-- ===============================================================

CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.kpi4_province_daytype_activity` AS
WITH base AS (
  SELECT
    datetime,
    date,
    time,
    EXTRACT(HOUR FROM datetime) AS hour,
    CASE
      WHEN EXTRACT(DAYOFWEEK FROM date) IN (1, 7) THEN 'Weekend'
      ELSE 'Weekday'
    END AS day_type,
    province_name,
    (cell2Province + Province2cell) AS activity
  FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days`
)

SELECT
  day_type,
  date,
  time,
  hour,
  province_name,
  SUM(activity) AS total_activity
FROM base
GROUP BY day_type, date, time, hour, province_name
ORDER BY province_name, day_type;
