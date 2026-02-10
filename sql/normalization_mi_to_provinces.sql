--Aktif kayıtları belirleme
CREATE OR REPLACE TABLE ndn-project-485520.telecom_italy_data.mi_to_provinces_active_records_only AS
SELECT *
FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days`
WHERE cell2Province > 0;

--Province bazlı IQR (outlier sınırları)
CREATE OR REPLACE TABLE ndn-project-485520.telecom_italy_data.mi_to_provinces_outlier_bounds AS
WITH stats AS (
  SELECT
    province_name,
    APPROX_QUANTILES(cell2Province, 100)[OFFSET(25)] AS q1,
    APPROX_QUANTILES(cell2Province, 100)[OFFSET(75)] AS q3
  FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_active_records_only`
  GROUP BY province_name
)
SELECT
  province_name,
  q1,
  q3,
  q3 - q1 AS iqr,
  q1 - 1.5 * (q3 - q1) AS lower_bound,
  q3 + 1.5 * (q3 - q1) AS upper_bound
FROM stats;

--Outlier flag / capping
CREATE OR REPLACE TABLE ndn-project-485520.telecom_italy_data.mi_to_provinces_outliers AS
SELECT
  a.*,
  b.lower_bound,
  b.upper_bound,
CASE
    WHEN a.cell2Province < b.lower_bound
      OR a.cell2Province > b.upper_bound
    THEN 1 ELSE 0
  END AS is_outlier
FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_active_records_only` AS a
JOIN telecom_italy_data.mi_to_provinces_outlier_bounds b
USING (province_name);

--Province bazlı capping (SMS pipeline’ının aynısı)
CREATE OR REPLACE TABLE telecom_italy_data.mi_to_provinces_capped AS
SELECT
  date,
  time,
  cell_id,
  province_name,

  CASE
    WHEN cell2Province < lower_bound THEN lower_bound
    WHEN cell2Province > upper_bound THEN upper_bound
    ELSE cell2Province
  END AS cell2Province_capped

FROM telecom_italy_data.mi_to_provinces_outliers;

--Province bazlı Min–Max normalization
CREATE OR REPLACE TABLE telecom_italy_data.mi_to_provinces_normalized_minmax AS
WITH minmax AS (
  SELECT
    province_name,
    MIN(cell2Province_capped) AS min_val,
    MAX(cell2Province_capped) AS max_val
  FROM telecom_italy_data.mi_to_provinces_capped
  GROUP BY province_name
)
SELECT
  c.*,
  SAFE_DIVIDE(
    c.cell2Province_capped - m.min_val,
    m.max_val - m.min_val
  ) AS cell2Province_norm
FROM telecom_italy_data.mi_to_provinces_capped c
JOIN minmax m
USING (province_name);

-- =============================================================================
-- Z-SCORE STANDARDIZATION
-- =============================================================================
-- Ortalama=0, Standart Sapma=1 olacak şekilde değerleri standardize eder
-- Capped (outlier'ları temizlenmiş) tablo kullanılır
-- =============================================================================

CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.mi_to_provinces_standardized_zscore` AS
WITH stats AS (
  SELECT 
    AVG(cell2Province_capped) AS cell2Province_mean,
    STDDEV(cell2Province_capped) AS cell2Province_std
  FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_capped`
)
SELECT 
  date,
  time,
  cell_id,
  province_name,
  
  -- Capped değer (outlier'lar temizlenmiş)
  cell2Province_capped,
  
  -- Standardize edilmiş değer (Z-score)
  (cell2Province_capped - stats.cell2Province_mean) / 
    NULLIF(stats.cell2Province_std, 0) AS cell2Province_standardized
  
FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_capped`, stats;


-- =============================================================================
-- LOG TRANSFORMATION
-- =============================================================================
-- Sağa çarpık (right-skewed) dağılımları normalleştirmek için logaritmik dönüşüm
-- Capped (outlier'ları temizlenmiş) tablo kullanılır
-- =============================================================================

CREATE OR REPLACE TABLE `ndn-project-485520.telecom_italy_data.mi_to_provinces_log_transformed` AS
SELECT 
  date,
  time,
  cell_id,
  province_name,
  
  -- Capped değer (outlier'lar temizlenmiş)
  cell2Province_capped,
  
  -- Log dönüşümü
  LN(cell2Province_capped + 1) AS cell2Province_log
  
FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_capped`;