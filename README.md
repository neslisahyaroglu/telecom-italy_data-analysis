# 🇬🇧 English Version

## 📌 Telecom Network Usage Analysis & Predictive Modeling Project

This project was carried out using the publicly available All Lending Club Loan Data dataset on Kaggle.

Dataset link:
https://www.kaggle.com/datasets/marcodena/mobile-phone-activity

This project focuses on telecom network usage analysis and predictive modeling, using large-scale mobile communication data aggregated by time, location, and network cell.

Conducted by a team of three, the project covers data engineering, exploratory data analysis (EDA), KPI & insight generation, machine learning modeling, and dashboard development, delivering an end-to-end telecom analytics pipeline.

### 📊 1. Project Data

The project is based on telecom network activity data, representing mobile usage across different services and dimensions.

Key Dimensions:

- cell_id
- date, hour
- day_of_week, day_type
- country_code
- province_name
- Usage Metrics
- sms_in, sms_out
- call_in, call_out
- internet
- total_activity

The raw data was enriched using dimension mappings (e.g., cell–province relationships) to support geographical and segment-based analysis.

### 🔍 2. Project Workflow

**2.1 Data Cleaning & Feature Engineering**

- Handling missing and inconsistent values
- Creating time-based features (hour, weekday/weekend, peak hour indicators)
- Aggregating usage metrics
- Generating derived KPIs (e.g., total activity, service ratios)
- Data validation and quality checks

**2.2 Exploratory Data Analysis (EDA)**

- Traffic distribution analysis (SMS, calls, internet)
- Hourly, daily, and weekly usage patterns
- Peak hour analysis
- Province- and cell-level comparisons
- Network load behavior analysis
- Outlier and anomaly detection

**2.3 KPI & Insights**

Key telecom KPIs generated in the project include:

- Peak hour network usage
- Most active provinces and cells
- Service-based traffic distribution
- Call vs. internet usage trends
- Network congestion indicators
- Early warning signals for abnormal traffic spikes

**2.4 Modeling**

The project includes multiple predictive modeling tasks:

- Network traffic prediction (internet usage & total activity)
- Network load and risk analysis using peak period simulations
- Activity level classification (low–medium–high usage segments)
- Models were evaluated using appropriate regression and classification metrics.

**2.5 Dashboard**

Interactive Power BI dashboard

- Network usage KPI cards
- Time-series traffic trends
- Province and cell-based comparisons
- Peak hour visualizations
- Model output integration

### 🧠 3. Project Structure

```text
Telecom_Network_Analytics_Project/
│
├── data/
│   ├── raw/                # Raw telecom network data
│   └── processed/          # Cleaned and feature-engineered datasets
│
├── notebooks/
│   └── README.md           # Notebook descriptions and execution order
│
├── outputs/
│   ├── figures/            # Visual outputs and charts
│   ├── tables/             # KPI tables and model outputs
│   └── README.md
│
├── sql/                    # SQL queries for data extraction & aggregation
│
├── src/                    # Reusable Python scripts and helper functions
│
└── README.md
```

### 🧾 4. Conclusion

In this project:

- Large-scale telecom data was processed and analyzed
- Extensive data cleaning and feature engineering were applied
- Network usage patterns were explored through EDA
- Actionable KPIs and insights were generated
- Predictive models were developed
- An interactive Power BI dashboard was delivered
- This project provides a practical end-to-end telecom analytics solution, supporting network planning, capacity management, and performance monitoring.

---

# 🇹🇷 Türkçe Versiyon

## 📌 Telekom Ağ Kullanımı Analizi ve Tahmin Modelleri Projesi

This project was carried out using the publicly available All Lending Club Loan Data dataset on Kaggle.

Dataset link:
https://www.kaggle.com/datasets/marcodena/mobile-phone-activity

Bu proje, telekomünikasyon ağ kullanım verileri kullanılarak mobil iletişim aktivitelerinin zaman, lokasyon ve hücre (cell) bazlı analizini kapsamaktadır.

Üç kişilik bir ekip tarafından yürütülen çalışma; veri hazırlama, keşifçi veri analizi (EDA), KPI & içgörü üretimi, tahmin modelleri ve dashboard geliştirme aşamalarını içeren uçtan uca bir telekom veri analitiği projesidir.

### 📊 1. Proje Verisi

Projede mobil ağ trafiğini temsil eden kapsamlı bir veri seti kullanılmıştır.

Temel Boyutlar:

- cell_id
- date, hour
- day_of_week, 
- day_type
- country_code
- province_name

Kullanım Metrikleri:

- sms_in, sms_out
- call_in, call_out
- internet
- total_activity

Veri seti, coğrafi analizlere olanak sağlamak için boyutsal tablolarla zenginleştirilmiştir.

### 🔍 2. Proje Aşamaları

**2.1 Veri Temizleme & Özellik Mühendisliği**

- Eksik ve tutarsız verilerin giderilmesi
- Zaman bazlı değişkenlerin oluşturulması
- Trafik metriklerinin birleştirilmesi
- Türetilmiş KPI’ların hesaplanması
- Veri kalite kontrolleri

**2.2 Keşifçi Veri Analizi (EDA)**

- SMS, çağrı ve internet kullanım dağılımları
- Saatlik, günlük ve haftalık trendler
- Peak hour analizleri
- İl ve hücre bazlı yoğunluk karşılaştırmaları
- Ağ yükü davranışları
- Aykırı değer ve anomali analizi

**2.3 KPI & İçgörü Üretimi**

- Peak hour ağ yoğunluğu
- En yoğun il ve hücreler
- Servis bazlı trafik dağılımı
- Çağrı ve internet kullanım trendleri
- Ağ tıkanıklığı göstergeleri
- Anormal trafik artışları için erken uyarılar

**2.4 Modelleme**

- Ağ trafiği tahmin modelleri
- Ağ yükü ve risk analizleri
- Aktivite seviyesi sınıflandırma modelleri

**2.5 Dashboard**

- Power BI tabanlı telekom dashboard’u
- KPI kartları
- Zaman serisi görselleştirmeleri
- İl ve hücre bazlı karşılaştırmalar
- Etkileşimli filtreleme

### 🧾 3. Sonuç

Bu proje kapsamında:

- Telekom ağ verileri analiz edilmiştir
- Veri temizleme ve özellik mühendisliği yapılmıştır
- Ağ kullanım davranışları incelenmiştir
- KPI ve içgörüler üretilmiştir
- Tahmin modelleri geliştirilmiştir
- Etkileşimli bir Power BI dashboard’u oluşturulmuştur
- Proje, telekom ağ planlama ve performans izleme süreçlerine yönelik uçtan uca bir veri bilimi çözümü sunmaktadır.
