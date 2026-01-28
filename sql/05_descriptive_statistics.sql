-- Section: Descriptive Statistics (EDA)
-- Purpose:
--   This script computes descriptive statistics for key telecom
--   activity metrics (SMS, calls, internet) to understand
--   distributional properties before modeling.
-- Description:
--   The outputs support exploratory data analysis and data quality
--   assessment, and are independent from the outlier detection pipeline.



-- SECTION: DESCRIPTIVE STATISTICS
-- ============================================================================
-- This section contains exploratory data analysis (EDA) queries
-- designed to summarize the main statistical properties of
-- telecom activity metrics before modeling.

-- 1.1: Basic descriptive statistics for each activity metric
-- This table reports count, central tendency, dispersion,
-- and quartile-based statistics for individual metrics.

CREATE OR REPLACE TABLE
`ndn-project-485520.telecom_italy_data.descriptive_metric_stats` AS

SELECT
  'sms_in' AS metric,
  COUNT(*) AS record_count,
  COUNTIF(sms_in IS NOT NULL) AS non_null_count,
  ROUND(AVG(sms_in), 2) AS mean,
  APPROX_QUANTILES(sms_in, 100)[OFFSET(50)] AS median,
  ROUND(STDDEV(sms_in), 2) AS std_dev,
  MIN(sms_in) AS min_value,
  MAX(sms_in) AS max_value,
  APPROX_QUANTILES(sms_in, 100)[OFFSET(25)] AS q1,
  APPROX_QUANTILES(sms_in, 100)[OFFSET(75)] AS q3
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`

UNION ALL

SELECT
  'sms_out',
  COUNT(*),
  COUNTIF(sms_out IS NOT NULL),
  ROUND(AVG(sms_out), 2),
  APPROX_QUANTILES(sms_out, 100)[OFFSET(50)],
  ROUND(STDDEV(sms_out), 2),
  MIN(sms_out),
  MAX(sms_out),
  APPROX_QUANTILES(sms_out, 100)[OFFSET(25)],
  APPROX_QUANTILES(sms_out, 100)[OFFSET(75)]
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`

UNION ALL

SELECT
  'call_in',
  COUNT(*),
  COUNTIF(call_in IS NOT NULL),
  ROUND(AVG(call_in), 2),
  APPROX_QUANTILES(call_in, 100)[OFFSET(50)],
  ROUND(STDDEV(call_in), 2),
  MIN(call_in),
  MAX(call_in),
  APPROX_QUANTILES(call_in, 100)[OFFSET(25)],
  APPROX_QUANTILES(call_in, 100)[OFFSET(75)]
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`

UNION ALL

SELECT
  'call_out',
  COUNT(*),
  COUNTIF(call_out IS NOT NULL),
  ROUND(AVG(call_out), 2),
  APPROX_QUANTILES(call_out, 100)[OFFSET(50)],
  ROUND(STDDEV(call_out), 2),
  MIN(call_out),
  MAX(call_out),
  APPROX_QUANTILES(call_out, 100)[OFFSET(25)],
  APPROX_QUANTILES(call_out, 100)[OFFSET(75)]
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days`

UNION ALL

SELECT
  'internet',
  COUNT(*),
  COUNTIF(internet IS NOT NULL),
  ROUND(AVG(internet), 2),
  APPROX_QUANTILES(internet, 100)[OFFSET(50)],
  ROUND(STDDEV(internet), 2),
  MIN(internet),
  MAX(internet),
  APPROX_QUANTILES(internet, 100)[OFFSET(25)],
  APPROX_QUANTILES(internet, 100)[OFFSET(75)]
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged`;



-- 1.2: Total activity distribution
-- This table summarizes the overall activity volume by
-- aggregating all communication types into a single metric.

CREATE OR REPLACE TABLE
`ndn-project-485520.telecom_italy_data.descriptive_total_activity_stats` AS
SELECT 
  'total_activity' AS metric,
  COUNT(*) AS record_count,
  ROUND(AVG(sms_in + sms_out + call_in + call_out + internet), 2) AS mean,
  APPROX_QUANTILES(
    sms_in + sms_out + call_in + call_out + internet, 
    100
  )[OFFSET(50)] AS median,
  ROUND(
    STDDEV(sms_in + sms_out + call_in + call_out + internet), 
    2
  ) AS std_dev,
  MIN(sms_in + sms_out + call_in + call_out + internet) AS min_value,
  MAX(sms_in + sms_out + call_in + call_out + internet) AS max_value
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged`;

-- 1.3: Activity type distribution (percentage share)
-- This table shows the proportional contribution of
-- SMS, calls, and internet traffic to the total activity.

CREATE OR REPLACE TABLE
`ndn-project-485520.telecom_italy_data.descriptive_activity_type_share` AS
SELECT 
  ROUND(
    SUM(sms_in + sms_out) * 100.0 
    / SUM(sms_in + sms_out + call_in + call_out + internet), 
    2
  ) AS sms_percentage,

  ROUND(
    SUM(call_in + call_out) * 100.0 
    / SUM(sms_in + sms_out + call_in + call_out + internet), 
    2
  ) AS call_percentage,

  ROUND(
    SUM(internet) * 100.0 
    / SUM(sms_in + sms_out + call_in + call_out + internet), 
    2
  ) AS internet_percentage
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_flagged`;

