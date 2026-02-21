CREATE OR REPLACE TABLE
`ndn-project-485520.telecom_italy_data.mi_to_provinces_all_days` AS

SELECT * FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_2013_11_01`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_2013_11_02`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_2013_11_03`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_2013_11_04`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_2013_11_05`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_2013_11_06`
UNION ALL
SELECT * FROM `ndn-project-485520.telecom_italy_data.mi_to_provinces_2013_11_07`;
