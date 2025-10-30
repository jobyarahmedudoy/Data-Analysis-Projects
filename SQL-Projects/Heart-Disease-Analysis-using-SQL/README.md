# Heart Disease Data Analysis using SQL
This project focuses on analyzing a Heart Disease dataset using SQL to uncover medical insights and identify factors that contribute to heart disease.
By applying SQL queries on patient data, the project extracts meaningful patterns, relationships, and trends among key health indicators.
## Dataset Overview

The dataset includes the following attributes (columns):

- `age`: Represents the age of the patient.
- `chest_pain_type`: Describes the type of chest pain experienced (1 = typical angina, 2 = atypical angina, 3 = non-anginal pain, 4 = asymptomatic).
- `sex`: Indicates gender (1 = male, 0 = female).
- `resting_bp_s`: Resting blood pressure of the patient in mm Hg.
- `cholesterol`: Serum cholesterol level in mg/dl.
- `fasting_blood_sugar`: Indicates if fasting blood sugar > 120 mg/dl (1 = true, 0 = false).
- `resting_ecg`: Resting electrocardiographic results.
- `max_heart_rate`: Maximum heart rate achieved during exercise.
- `exercise_angina`: Exercise-induced angina indicator (1 = yes, 0 = no).
- `oldpeak`: ST depression induced by exercise relative to rest.
- `st_slope`: Slope of the peak exercise ST segment.
- `target`: Output class (1 = patient has heart disease, 0 = normal).
- 


## SQL Queries and Outputs

Here are the SQL queries along with their outputs:

1. **Show all patient records in the dataset**

```sql
SELECT * FROM heart_disease;
```
-- Output --  
There are a total of 1,190 patients in the Cleveland,Hungary datasets.

2. **Count the total number of patients**

```sql
SELECT COUNT(*) AS total_patients FROM heart_disease;
```
-- Output -- 

<img width="125" height="50" alt="Capture" src="https://github.com/user-attachments/assets/417e9c21-24f6-4f3b-884f-c2273a3dd7d1" />

3. **Find the number of male and female patients.**

```sql
SELECT 
CASE WHEN SEX=1 THEN 'MALE' ELSE 'FEMALE' END AS GENDER,COUNT(*) AS TOTAL_PATIENT
FROM heart_disease
GROUP BY SEX;
```
-- Output -- 
<img width="218" height="76" alt="cap2" src="https://github.com/user-attachments/assets/6205bd80-3c95-456d-98b7-eddfda4f17e7" />


