CREATE OR REPLACE VIEW
  ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days_outliers AS

SELECT
  t.date,
  t.time,
  t.cell_id,
  t.province_name,

  t.cell2Province,
  t.Province2cell,

  -- IQR bounds
  (s.q1 - 1.5 * s.iqr) AS lower_bound,
  (s.q3 + 1.5 * s.iqr) AS upper_bound,

  -- Outlier flag
  CASE
    WHEN t.cell2Province < (s.q1 - 1.5 * s.iqr)
      OR t.cell2Province > (s.q3 + 1.5 * s.iqr)
    THEN 1
    ELSE 0
  END AS is_outlier

FROM ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days t
JOIN ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days_stats s
  USING (province_name);
