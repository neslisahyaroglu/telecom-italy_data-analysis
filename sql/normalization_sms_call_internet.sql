-- 1. Sadece AKTİF kayıtları analiz edin (sıfırları çıkarın)
CREATE OR REPLACE TABLE 
  `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_only` AS
SELECT *
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged` 
WHERE sms_in > 0 OR sms_out > 0 OR call_in > 0 OR call_out > 0 OR internet > 0;

-- 2. Aktif kayıtlar üzerinde outlier tespiti yapın
WITH stats AS (
  SELECT
    APPROX_QUANTILES(sms_in, 100)[OFFSET(25)] AS Q1,
    APPROX_QUANTILES(sms_in, 100)[OFFSET(75)] AS Q3
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_only`
  WHERE sms_in > 0  -- Sadece sıfır olmayanlar
)
SELECT
  Q1,
  Q3,
  Q3 - Q1 AS IQR,
  Q1 - 1.5 * (Q3 - Q1) AS lower_bound,
  Q3 + 1.5 * (Q3 - Q1) AS upper_bound
FROM stats;
-- Tüm kolonlar için outlier sınırları
CREATE OR REPLACE TABLE 
  `ndn-project-485520.telecom_italy_data.sms_call_internet_outlier_bounds_active` AS
WITH stats AS (
  SELECT
    'sms_in' AS metric,
    APPROX_QUANTILES(sms_in, 100)[OFFSET(25)] AS Q1,
    APPROX_QUANTILES(sms_in, 100)[OFFSET(75)] AS Q3
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_only`
  WHERE sms_in > 0
  
  UNION ALL
  
  SELECT 'sms_out',
    APPROX_QUANTILES(sms_out, 100)[OFFSET(25)],
    APPROX_QUANTILES(sms_out, 100)[OFFSET(75)]
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_only`
  WHERE sms_out > 0
  
  UNION ALL
  
  SELECT 'call_in',
    APPROX_QUANTILES(call_in, 100)[OFFSET(25)],
    APPROX_QUANTILES(call_in, 100)[OFFSET(75)]
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_only`
  WHERE call_in > 0
  
  UNION ALL
  
  SELECT 'call_out',
    APPROX_QUANTILES(call_out, 100)[OFFSET(25)],
    APPROX_QUANTILES(call_out, 100)[OFFSET(75)]
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_only`
  WHERE call_out > 0
  
  UNION ALL
  
  SELECT 'internet',
    APPROX_QUANTILES(internet, 100)[OFFSET(25)],
    APPROX_QUANTILES(internet, 100)[OFFSET(75)]
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_only`
  WHERE internet > 0
)
SELECT
  metric,
  Q1,
  Q3,
  Q3 - Q1 AS IQR,
  Q1 - 1.5 * (Q3 - Q1) AS lower_bound,
  Q3 + 1.5 * (Q3 - Q1) AS upper_bound
FROM stats
ORDER BY metric;
-- Outlier'ları üst/alt sınırlarla değiştir (Capping)
CREATE OR REPLACE TABLE 
  `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_capped` AS
WITH bounds AS (
  SELECT * FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_outlier_bounds_active`
)
SELECT
  datetime,
  date,
  time,
  cell_id,
  country_code,
  
  -- Capping uygula (outlier'ları sınırla)
  CASE 
    WHEN sms_in < (SELECT lower_bound FROM bounds WHERE metric = 'sms_in') 
      THEN (SELECT lower_bound FROM bounds WHERE metric = 'sms_in')
    WHEN sms_in > (SELECT upper_bound FROM bounds WHERE metric = 'sms_in') 
      THEN (SELECT upper_bound FROM bounds WHERE metric = 'sms_in')
    ELSE sms_in 
  END AS sms_in,
  
  CASE 
    WHEN sms_out < (SELECT lower_bound FROM bounds WHERE metric = 'sms_out') 
      THEN (SELECT lower_bound FROM bounds WHERE metric = 'sms_out')
    WHEN sms_out > (SELECT upper_bound FROM bounds WHERE metric = 'sms_out') 
      THEN (SELECT upper_bound FROM bounds WHERE metric = 'sms_out')
    ELSE sms_out 
  END AS sms_out,
  
  CASE 
    WHEN call_in < (SELECT lower_bound FROM bounds WHERE metric = 'call_in') 
      THEN (SELECT lower_bound FROM bounds WHERE metric = 'call_in')
    WHEN call_in > (SELECT upper_bound FROM bounds WHERE metric = 'call_in') 
      THEN (SELECT upper_bound FROM bounds WHERE metric = 'call_in')
    ELSE call_in 
  END AS call_in,
  
  CASE 
    WHEN call_out < (SELECT lower_bound FROM bounds WHERE metric = 'call_out') 
      THEN (SELECT lower_bound FROM bounds WHERE metric = 'call_out')
    WHEN call_out > (SELECT upper_bound FROM bounds WHERE metric = 'call_out') 
      THEN (SELECT upper_bound FROM bounds WHERE metric = 'call_out')
    ELSE call_out 
  END AS call_out,
  
  CASE 
    WHEN internet < (SELECT lower_bound FROM bounds WHERE metric = 'internet') 
      THEN (SELECT lower_bound FROM bounds WHERE metric = 'internet')
    WHEN internet > (SELECT upper_bound FROM bounds WHERE metric = 'internet') 
      THEN (SELECT upper_bound FROM bounds WHERE metric = 'internet')
    ELSE internet 
  END AS internet
  
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_only`;

-- Min-Max Scaler: Tüm değerleri 0-1 arasına ölçeklendir
CREATE OR REPLACE TABLE 
  `ndn-project-485520.telecom_italy_data.sms_call_internet_normalized_minmax` AS
WITH stats AS (
  SELECT
    MIN(sms_in) AS sms_in_min, 
    MAX(sms_in) AS sms_in_max,
    MIN(sms_out) AS sms_out_min, 
    MAX(sms_out) AS sms_out_max,
    MIN(call_in) AS call_in_min, 
    MAX(call_in) AS call_in_max,
    MIN(call_out) AS call_out_min, 
    MAX(call_out) AS call_out_max,
    MIN(internet) AS internet_min, 
    MAX(internet) AS internet_max
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_capped`
)
SELECT
  datetime,
  date,
  time,
  cell_id,
  country_code,
  
  -- Orijinal değerler
  sms_in,
  sms_out,
  call_in,
  call_out,
  internet,
  
  -- Normalize edilmiş değerler (0-1 arası)
  (sms_in - stats.sms_in_min) / 
    NULLIF(stats.sms_in_max - stats.sms_in_min, 0) AS sms_in_normalized,
    
  (sms_out - stats.sms_out_min) / 
    NULLIF(stats.sms_out_max - stats.sms_out_min, 0) AS sms_out_normalized,
    
  (call_in - stats.call_in_min) / 
    NULLIF(stats.call_in_max - stats.call_in_min, 0) AS call_in_normalized,
    
  (call_out - stats.call_out_min) / 
    NULLIF(stats.call_out_max - stats.call_out_min, 0) AS call_out_normalized,
    
  (internet - stats.internet_min) / 
    NULLIF(stats.internet_max - stats.internet_min, 0) AS internet_normalized
  
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_capped`, stats;

-- Z-Score Standardization: Ortalama=0, Standart Sapma=1
CREATE OR REPLACE TABLE 
  `ndn-project-485520.telecom_italy_data.sms_call_internet_standardized_zscore` AS
WITH stats AS (
  SELECT
    AVG(sms_in) AS sms_in_mean, 
    STDDEV(sms_in) AS sms_in_std,
    AVG(sms_out) AS sms_out_mean, 
    STDDEV(sms_out) AS sms_out_std,
    AVG(call_in) AS call_in_mean, 
    STDDEV(call_in) AS call_in_std,
    AVG(call_out) AS call_out_mean, 
    STDDEV(call_out) AS call_out_std,
    AVG(internet) AS internet_mean, 
    STDDEV(internet) AS internet_std
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_capped`
)
SELECT
  datetime,
  date,
  time,
  cell_id,
  country_code,
  
  -- Orijinal değerler
  sms_in,
  sms_out,
  call_in,
  call_out,
  internet,
  
  -- Standardize edilmiş değerler (Z-score)
  (sms_in - stats.sms_in_mean) / 
    NULLIF(stats.sms_in_std, 0) AS sms_in_standardized,
    
  (sms_out - stats.sms_out_mean) / 
    NULLIF(stats.sms_out_std, 0) AS sms_out_standardized,
    
  (call_in - stats.call_in_mean) / 
    NULLIF(stats.call_in_std, 0) AS call_in_standardized,
    
  (call_out - stats.call_out_mean) / 
    NULLIF(stats.call_out_std, 0) AS call_out_standardized,
    
  (internet - stats.internet_mean) / 
    NULLIF(stats.internet_std, 0) AS internet_standardized
  
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_capped`, stats;

-- Log Transformation: Sağa çarpık dağılımları normalleştir
CREATE OR REPLACE TABLE 
  `ndn-project-485520.telecom_italy_data.sms_call_internet_log_transformed` AS
SELECT
  datetime,
  date,
  time,
  cell_id,
  country_code,
  
  -- Orijinal değerler
  sms_in,
  sms_out,
  call_in,
  call_out,
  internet,
  
  -- Log dönüşümü (log1p = ln(1 + x), sıfırları korur)
  LN(sms_in + 1) AS sms_in_log,
  LN(sms_out + 1) AS sms_out_log,
  LN(call_in + 1) AS call_in_log,
  LN(call_out + 1) AS call_out_log,
  LN(internet + 1) AS internet_log
  
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_active_records_capped`;