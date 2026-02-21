-- ===============================================================
-- KPI NAME:
-- kpi4_province_trend_summary
--
-- PURPOSE:
-- Provides a trend summary for each province by computing:
-- 1. Minimum daily activity
-- 2. Maximum daily activity
-- 3. Activity change (max - min)
-- Used to detect volatility, growth patterns, and stability.
--
-- LOGIC SUMMARY:
-- 1. Aggregate activity at (province, date, hour) level
-- 2. Apply window functions to compute min/max per province
-- 3. Calculate activity_change = max - min
--
-- SOURCE TABLE:
-- mi_to_provinces_all_days
--
-- USAGE:
-- Perfect for trend dashboards, anomaly detection,
-- and province-level performance comparisons.
-- ===============================================================

CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.kpi4_province_trend_summary` AS
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
),

daily AS (
  SELECT
    province_name,
    date,
    time,
    hour,
    day_type,
    SUM(activity) AS daily_activity
  FROM base
  GROUP BY province_name, date, time, hour, day_type
)

SELECT
  province_name,
  date,
  time,
  hour,
  day_type,
  daily_activity,
  MIN(daily_activity) OVER (PARTITION BY province_name) AS min_activity,
  MAX(daily_activity) OVER (PARTITION BY province_name) AS max_activity,
  (MAX(daily_activity) OVER (PARTITION BY province_name) -
   MIN(daily_activity) OVER (PARTITION BY province_name)) AS activity_change
FROM daily
ORDER BY province_name, date;
