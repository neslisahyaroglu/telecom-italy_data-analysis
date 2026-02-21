
-- KPI NAME:
-- kpi4_province_daily_activity
--
-- PURPOSE:
-- Computes the total daily activity for each province by aggregating
-- telecom interaction values (cell2Province + Province2cell).
-- Produces an hourly-level time-series dataset per day and province.
--
-- LOGIC SUMMARY:
-- 1. Extract hour and classify day_type (Weekday vs Weekend)
-- 2. Aggregate activity values at (date, time, hour, province) level
-- 3. Output is used for trend charts, time-series models, and KPI dashboards
--
-- SOURCE TABLE:
-- mi_to_provinces_all_days

-- USAGE:
-- Ideal for hourly behavior analysis, seasonality detection,
-- province-level demand comparison, and peak hour identification.
-- ===============================================================

CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.kpi4_province_daily_activity` AS
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
  date,
  time,
  hour,
  day_type,
  province_name,
  SUM(activity) AS daily_activity
FROM base
GROUP BY date, time, hour, day_type, province_name
ORDER BY date, province_name;
