/*
What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis
*/

WITH skill_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(sj.skill_id) AS demand_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
    INNER JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), avg_salary AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
    INNER JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    demand_count,
    avg_salary
FROM skill_demand
INNER JOIN avg_salary ON skill_demand.skill_id = avg_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;


-- Other way to write the same query

SELECT
    sd.skill_id,
    sd.skills,
    COUNT(sjd.skill_id) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    sd.skill_id
HAVING
    COUNT(sjd.skill_id) > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;