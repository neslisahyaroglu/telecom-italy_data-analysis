# KPI Outlier Analysis – SQL Repository

This repository contains SQL scripts designed to analyze KPI behavior and identify outliers across different dimensions such as province, time, day type, and service profile.  
The work focuses on producing structured KPI summaries that can be used for further reporting and analytical purposes.

## Overview

The SQL scripts follow a step-by-step flow, starting from data preparation and continuing through outlier detection and KPI aggregation.  
Each script builds on the previous outputs to ensure a consistent and traceable analysis process.

## Repository Structure

- **01_build_mi_to_provinces_all_days.sql**  
  Prepares the base dataset by aligning KPI data with provinces and ensuring full daily coverage.

- **02_province_iqr_stats.sql**  
  Calculates province-level statistical metrics that are used as a foundation for outlier detection.

- **03_outlier_flagging.sql**  
  Identifies and flags outlier values based on the calculated thresholds.

- **04_province_outlier_summary.sql**  
  Generates province-level summaries of detected outliers.

- **05_kpi_outlier_daytype_hour.sql**  
  Analyzes KPI outliers by day type and hourly distribution.

- **06_kpi_outlier_by_hour.sql**  
  Provides a detailed view of KPI outlier behavior on an hourly basis.

- **07_kpi_outlier_service_profile.sql**  
  Evaluates KPI outliers across different service profiles.

- **08_kpi_outlier_daytype_ratio.sql**  
  Computes outlier ratios based on day type.

- **09_kpi_outlier_daytype_service.sql**  
  Breaks down KPI outliers by day type and service combination.

- **10_kpi_province_daily_activity.sql**  
  Creates daily KPI activity summaries at the province level.

- **11_kpi_province_daytype_activity.sql**  
  Analyzes province-level KPI activity by day type.

- **12_kpi_province_trend_summary.sql**  
  Produces trend summaries to observe KPI behavior over time.

## Notes

- This repository represents ongoing analytical work and is maintained as a feature branch.
- Outputs from these scripts are intended to support reporting and further visualization efforts.



Determination:
--null and missing data 

Normalization:
--determine the active records
--IQR (Inter Quartiles Ranges) and outlier limits
--Outlier flag / capping
--Min–Max normalization
--Z-score standardization
--Log transformation

