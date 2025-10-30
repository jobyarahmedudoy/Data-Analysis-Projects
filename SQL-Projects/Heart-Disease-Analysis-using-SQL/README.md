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

4. **List distinct chest pain types found in the dataset.**

```sql
SELECT DISTINCT CHEST_PAIN_TYPE,
CASE WHEN CHEST_PAIN_TYPE=1 THEN 'typical angina'
	WHEN CHEST_PAIN_TYPE=2 THEN 'atypical angina '
    WHEN CHEST_PAIN_TYPE=3 THEN 'non-anginal pain '
    ELSE 'asymptomatic' END AS CHEST_PAIN
 FROM heart_disease
 ORDER BY CHEST_PAIN_TYPE;
```
-- Output -- 

<img width="287" height="114" alt="Capture3" src="https://github.com/user-attachments/assets/8c62575b-bee9-443c-b920-502a54e67633" />

5. **Find the average age of all patients.**

```sql
SELECT FLOOR(AVG(AGE)) as Avg_Age FROM heart_disease;
```
-- Output -- 

<img width="103" height="53" alt="Capture4" src="https://github.com/user-attachments/assets/1a363633-09ac-4dc9-b596-6004bceed238" />

6. **Find the maximum, minimum, and average cholesterol level.**

```sql

SELECT 
MAX(cholesterol) as Maximum_cholesterol,
MIN(cholesterol) as Minimum_cholesterol,
AVG(cholesterol) as Average_cholesterol
FROM heart_disease;
```
-- Output -- 

<img width="465" height="59" alt="Capture6" src="https://github.com/user-attachments/assets/883721be-fe68-4068-8672-9593b5b7b365" />

7. **Count the total number of patients with fasting blood sugar greater than 120 mg/dl.**

```sql

SELECT COUNT(*) as fasting_blood_sugar_patients FROM heart_disease
WHERE fasting_blood_sugar=1; 
###(fasting blood sugar > 120 mg/dl) (1 = true; 0 = false)
```
-- Output -- 

<img width="228" height="54" alt="Capture7" src="https://github.com/user-attachments/assets/09568dfc-0e7d-4857-aebc-78ea8fec280f" />


8. **Count the total number of patients who have exercise-induced angina.**

```sql
SELECT COUNT(*) as exercise_angina_patients FROM heart_disease
WHERE exercise_angina=1;
###1 = yes; 0 = no
```
-- Output -- 

<img width="195" height="50" alt="Capture77" src="https://github.com/user-attachments/assets/f0db5215-b04c-4cc5-94a0-e6178e69306c" />

9. **Count how many patients have heart disease (target=1) vs normal (target=0).**

```sql
SELECT target,
CASE WHEN target=1 then ' heart disease' 
ELSE 'normal' end as class,
COUNT(*) as total_heart_disease_patient FROM heart_disease
group by target;
```
-- Output -- 

<img width="343" height="73" alt="Capture888" src="https://github.com/user-attachments/assets/59415170-a9bf-40f3-9cef-e3f6849e7711" />

10. **Find the average resting blood pressure for patients with and without heart disease.**

```sql
SELECT target,
CASE WHEN target=1 then ' heart disease' 
ELSE 'normal' end as class,
AVG(resting_bp_s) as Avg_Resting_blood_pressure
FROM heart_disease
group by target;
```
-- Output -- 

<img width="352" height="73" alt="Capt567ure" src="https://github.com/user-attachments/assets/0b2a942a-a44f-4711-880b-f0ea3e7a00e4" />

11. **Group patients by chest pain type and find the average cholesterol for each group.**

```sql
SELECT chest_pain_type,
avg(cholesterol) as avg_cholesterol
FROM heart_disease
group by chest_pain_type
order by chest_pain_type;
```
-- Output -- 

<img width="358" height="112" alt="Captughjre" src="https://github.com/user-attachments/assets/8628e465-4828-4e44-a6f4-2997ea294b9d" />

12. **Find the average maximum heart rate by gender.**

```sql
SELECT sex,
CASE WHEN SEX=1 THEN 'MALE' ELSE 'FEMALE' END AS GENDER,
avg(max_heart_rate) as avg_max_heart_rate
FROM heart_disease
group by sex
order by sex;
```
-- Output -- 

<img width="262" height="70" alt="Captureggggggggggg" src="https://github.com/user-attachments/assets/b05929f1-b637-492a-91cd-af7fa9f3025a" />

13. **Find how age affects heart disease: group patients by age ranges (e.g., 30–40, 41–50, etc.) and show average target value.**

```sql
SELECT 
CASE WHEN age BETWEEN 20 AND 30 THEN '20-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
    WHEN age BETWEEN 41 AND 50 THEN '41-50'
    WHEN age BETWEEN 51 AND 60 THEN '51-60'
    ELSE '61+' END AS age_group,
AVG(TARGET)*100 as heart_disease_percent
FROM heart_disease
group by age_group
order by age_group;
```
-- Output -- 

<img width="237" height="132" alt="Capturettttttttttttttt" src="https://github.com/user-attachments/assets/f4d6e898-e59d-4124-a080-cde6de2dcbf9" />

14. **List top 10 patients with the highest cholesterol levels.**

```sql
SELECT * FROM heart_disease 
ORDER BY cholesterol
DESC LIMIT 10;
```
-- Output -- 

<img width="1030" height="231" alt="Captrrrrrrrrrrrrrrrure" src="https://github.com/user-attachments/assets/991feb6d-43e1-40e7-829b-67da6372cd05" />

15. **Find correlation trends: For example, check how many patients with high cholesterol (>240) also have heart disease.**

```sql
SELECT COUNT(*) as High_cholesterol_hear_disease_patient FROM heart_disease 
WHERE cholesterol>240 AND TARGET=1;
```
-- Output -- 

<img width="251" height="46" alt="Ccccccccccccccapture" src="https://github.com/user-attachments/assets/7a29a0c0-ad1f-416c-88f5-16566590b712" />

16. **Find the percentage of patients with exercise-induced angina who also have heart disease.**

```sql

SELECT 
(SUM(CASE WHEN exercise_angina=1 AND target=1 THEN 1 ELSE 0 END)*100.0 / COUNT(*)) AS percentage
FROM heart_disease;
```
-- Output -- 

<img width="160" height="43" alt="Capxyzzzzzzzzzzzzzzzzzzzture" src="https://github.com/user-attachments/assets/01bb105d-efca-48d1-8c7b-89542d226b4f" />


17. **Find the first 5 patients whose cholesterol levels are higher than the average cholesterol of all patients in the dataset.**

```sql

SELECT * FROM heart_disease
WHERE cholesterol > (SELECT AVG(cholesterol) AS Avg_cholesterol FROM heart_disease) ;
```
-- Output -- 

<img width="1025" height="127" alt="Captureaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" src="https://github.com/user-attachments/assets/b6e48002-ea6f-42b7-be0a-893166f54820" />

18. **Find the most common combination of symptoms (e.g., chest pain type + fasting blood sugar + target).**

```sql
SELECT 
    chest_pain_type, 
    fasting_blood_sugar, 
    target, 
    COUNT(*) AS freq
FROM heart_disease
GROUP BY chest_pain_type, fasting_blood_sugar, target
ORDER BY freq DESC
LIMIT 5;
```
-- Output -- 

<img width="352" height="128" alt="xxxxxxxxxxxxxxxxxxx" src="https://github.com/user-attachments/assets/19c7fbf4-d100-4526-987c-33fee5a58545" />

19. **Calculate the risk rate of heart disease for males vs females (percentage).**

```sql
SELECT sex,
CASE WHEN SEX=1 THEN 'MALE' ELSE 'FEMALE' END AS GENDER,
ROUND((SUM(CASE WHEN TARGET=1 THEN 1 ELSE 0 END)/COUNT(*))*100,2) as risk_rate
FROM heart_disease
GROUP BY sex;
```
-- Output -- 

<img width="179" height="70" alt="yyyyyyyyyyyy" src="https://github.com/user-attachments/assets/577bd8cc-1b63-4fdc-abca-0f9a34791fc4" />

20. **Find the Top 5 most at-risk patients who show multiple high-risk conditions — including:High cholesterol (>240 mg/dl),High resting blood pressure (>140 mm Hg)
Exercise-induced angina (exercise_angina = 1),Confirmed heart disease (target = 1).**

```sql
SELECT age,sex,cholesterol,resting_bp_s,exercise_angina,max_heart_rate,oldpeak,target
FROM heart_disease
WHERE cholesterol > 240 AND resting_bp_s > 140
AND exercise_angina = 1 AND target = 1
ORDER BY cholesterol DESC, resting_bp_s DESC
LIMIT 5;
```
-- Output -- 

<img width="602" height="132" alt="NNNNNNNNNNNNNNNNN" src="https://github.com/user-attachments/assets/d86a5c8a-64d0-4c2f-abfd-29e6c8751a18" />




