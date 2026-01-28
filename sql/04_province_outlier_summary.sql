CREATE OR REPLACE TABLE
  ndn-project-485520.telecom_italy_data.province_outlier_summary_all_days AS

SELECT
  province_name,

  COUNT(*) AS total_rows,
  SUM(is_outlier) AS outlier_rows,

  ROUND(SUM(is_outlier) / COUNT(*) * 100, 2) AS outlier_ratio_pct,

  AVG(cell2Province) AS avg_cell2Province

FROM ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days_outliers
GROUP BY province_name
ORDER BY outlier_ratio_pct DESC;
