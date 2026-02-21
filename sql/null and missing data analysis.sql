
-- BÖLÜM 2: NULL VE EKSİK VERİ ANALİZİ
-- ============================================================================

-- 2.1: Her kolondaki NULL değer sayısı
SELECT 
  COUNTIF(cell_id IS NULL) AS null_cell_id,
  COUNTIF(datetime IS NULL) AS null_datetime,
  COUNTIF(date IS NULL) AS null_date,
  COUNTIF(time IS NULL) AS null_time,
  COUNTIF(country_code IS NULL) AS null_country_code,
  COUNTIF(sms_in IS NULL) AS null_sms_in,
  COUNTIF(sms_out IS NULL) AS null_sms_out,
  COUNTIF(call_in IS NULL) AS null_call_in,
  COUNTIF(call_out IS NULL) AS null_call_out,
  COUNTIF(internet IS NULL) AS null_internet,
  COUNT(*) AS toplam_kayit,
  ROUND(COUNTIF(sms_in IS NULL) * 100.0 / COUNT(*), 2) AS null_sms_in_yuzde
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`;

-- 2.2: Tüm metriklerin NULL olduğu kayıtlar (silinmesi gerekebilir)
SELECT 
  COUNT(*) AS tamamen_bos_kayit
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`
WHERE sms_in IS NULL 
  AND sms_out IS NULL 
  AND call_in IS NULL 
  AND call_out IS NULL 
  AND internet IS NULL;

-- 2.3: Eksik zaman dilimlerini tespit et
WITH zaman_dizisi AS (
  SELECT 
    tarih,
    GENERATE_ARRAY(0, 143) AS saat_dizisi
  FROM (
    SELECT DISTINCT date AS tarih
    FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`
  )
),
mevcut_kayitlar AS (
  SELECT 
    date AS tarih,
    time,
    COUNT(*) AS kayit_sayisi
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`
  GROUP BY date, time
)
SELECT 
  z.tarih,
  TIME(0, 0, dilim * 600) AS beklenen_zaman,  -- Her 10 dakika = 600 saniye
  COALESCE(m.kayit_sayisi, 0) AS mevcut_kayit
FROM zaman_dizisi z
CROSS JOIN UNNEST(z.saat_dizisi) AS dilim
LEFT JOIN mevcut_kayitlar m 
  ON z.tarih = m.tarih 
  AND TIME(0, 0, dilim * 600) = m.time
WHERE COALESCE(m.kayit_sayisi, 0) = 0
ORDER BY z.tarih, dilim
LIMIT 100;

-- 2.4: Eksik grid'leri tespit et (tüm grid'lerde kayıt olmalı)
-- NOT: Önce maksimum cell_id'yi bulun, sonra bu sorguyu çalıştırın
WITH tum_gridler AS (
  SELECT cell_id
  FROM UNNEST(GENERATE_ARRAY(1, 10000)) AS cell_id  -- cell_id maksimumunuza göre ayarlayın
),
mevcut_gridler AS (
  SELECT DISTINCT cell_id
  FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`
)
SELECT 
  t.cell_id AS eksik_grid_id
FROM tum_gridler t
LEFT JOIN mevcut_gridler m ON t.cell_id = m.cell_id
WHERE m.cell_id IS NULL
ORDER BY t.cell_id;
