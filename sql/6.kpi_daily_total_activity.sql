
1. TRAFFIC VOLUME KPIs
####1.1. Daily Total Activity

-- Daily total activity trend

CREATE OR REPLACE TABLE
`ndn-project-485520.telecom_italy_data.kpi_daily_total_activity` AS
SELECT 
  date,
  SUM(sms_in + sms_out + call_in + call_out + internet) AS total_activity,
  SUM(sms_in + sms_out) AS total_sms,
  SUM(call_in + call_out) AS total_calls,
  SUM(internet) AS total_internet
FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days_cleaned`
GROUP BY date
ORDER BY date;
