CREATE OR REPLACE TABLE
`ndn-project-485520.telecom_italy_data.sms_call_internet_mi_all_days` AS

SELECT * FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_2013_11_01`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_2013_11_02`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_2013_11_03`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_2013_11_04`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_2013_11_05`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_2013_11_06`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.sms_call_internet_mi_2013_11_07`
