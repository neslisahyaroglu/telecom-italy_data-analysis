CREATE OR REPLACE VIEW
  ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days_stats AS

SELECT
  province_name,

  -- First quartile (Q1)
  APPROX_QUANTILES(cell2Province, 4)[OFFSET(1)] AS q1,

  -- Third quartile (Q3)
  APPROX_QUANTILES(cell2Province, 4)[OFFSET(3)] AS q3,

  -- Interquartile range
  APPROX_QUANTILES(cell2Province, 4)[OFFSET(3)]
  - APPROX_QUANTILES(cell2Province, 4)[OFFSET(1)] AS iqr

FROM ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days
WHERE cell2Province IS NOT NULL
GROUP BY province_name;
