/* 
Student Habits vs Academic Performance

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views

*/

Select *
From ProjectPortfolio..student_habits_performance


-- Average Exam Score Across All Students

Select AVG(Exam_Score) AS average_exam_score
From ProjectPortfolio..student_habits_performance


-- Average Study Hours Per Day

Select AVG(Study_Hours_per_day) AS average_study_hours
From ProjectPortfolio..student_habits_performance


-- Average Sleep Hours Per day

Select AVG(Sleep_Hours) AS sleep_hours
From ProjectPortfolio..student_habits_performance


-- Average Exam Score by Gender

Select Gender, AVG(Exam_Score) AS average_exam_score
From ProjectPortfolio..student_habits_performance
Group by Gender
order by average_exam_score DESC


-- Average Exam Score by Parental Education Level

SELECT Parental_Education_Level, AVG(Exam_Score) AS average_exam_score
FROM ProjectPortfolio..student_habits_performance
GROUP BY Parental_Education_Level
order by average_exam_score DESC


-- Correlation Between Study Hours and Exam Score

Select study_hours_per_day, AVG(Exam_Score) AS average_exam_score
From  ProjectPortfolio..student_habits_performance
Group by study_hours_per_day 
Order by study_hours_per_day  DESC


-- Average Exam Score Based on quality

Select internet_quality, AVG(Exam_Score) AS average_exam_score
From  ProjectPortfolio..student_habits_performance
Group by internet_quality 
order by average_exam_score DESC


-- Comparing student study hours and sleep habits vary acorss performacne levels, categorzied by letter-grade groupings

WITH performance_category AS (
  SELECT 
    student_id,
    exam_score,
    CASE 
      WHEN exam_score >= 90 THEN 'A Students'
      WHEN exam_score >= 80 THEN 'B Students'
      WHEN exam_score >= 70 THEN 'C Students'
      ELSE 'D Students'
    END AS performance_group,
    study_hours_per_day,
    sleep_hours
  FROM ProjectPortfolio..student_habits_performance
)
SELECT 
  performance_group,
  COUNT(*) AS student_count,
  ROUND(AVG(study_hours_per_day), 2) AS avg_study_hours,
  ROUND(AVG(sleep_hours), 2) AS avg_sleep_hours
FROM performance_category
GROUP BY performance_group
ORDER BY 
  CASE performance_group
    WHEN 'A Students' THEN 1
    WHEN 'B Students' THEN 2
    WHEN 'C Students' THEN 3
    WHEN 'D Students' THEN 4
  END;




-- Table view of the total number of students, average exam score, and average age 

Select COUNT(student_id) as total_students, AVG(Exam_Score) AS average_exam_score,  AVG(age) AS average_age
FROM ProjectPortfolio..student_habits_performance

-- Average exam scores based on gender

SELECT 
  gender,
  AVG(exam_score) AS average_score
FROM ProjectPortfolio..student_habits_performance
WHERE gender IN ('Male', 'Female')
GROUP BY gender;


