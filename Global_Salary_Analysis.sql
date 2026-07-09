CREATE DATABASE ds;

SELECT * FROM ds_salaries;

-- apakah ada data yang null
select * 
from ds_salaries 
where work_year is null
OR experience_level IS NULL
OR employment_type IS NULL
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;

-- 2. melihat ada job title apa saja
select distinct job_title 
from ds_salaries
order by job_title;

-- 3. job title apa saja yang berkaitan dengan data analyst
select distinct job_title 
from ds_salaries 
where job_title like '%data analyst%'
order by job_title;

-- 4. Berapa rata-rata gaji data analyst
select (avg(salary_in_usd) * 15000) / 12 as avg_sal_rp_monthly from ds_salaries;
-- atau dengan cara 
SELECT AVG(salary_in_usd) 
AS avg_salary_in_usd 
FROM ds_salaries 
WHERE job_title LIKE '%data analyst%';

-- 4.1 Berapa rata-rata gaji data analyst dengan experience levelnya
select 	experience_level,
		avg(salary_in_usd) as avg_salary_in_usd
from ds_salaries
where job_title like '%data analyst%'
group by experience_level;
-- atau dengan
select experience_level, (avg(salary_in_usd) * 15000) / 12 as avg_sal_rp_monthly 
from ds_salaries
group by experience_level;

-- 4.2 Berapa rata-rata gaji data analyst dengan experience level dan jenis employementnya
select 	experience_level,
		employment_type,
        avg(salary_in_usd) as avg_salary_in_usd
from ds_salaries
where job_title like '%data analyst%'
group by experience_level, employment_type
order by experience_level, employment_type;
-- atau dengan
select 	experience_level, 
		employment_type,
        (avg(salary_in_usd) * 15000) / 12 as avg_sal_rp_monthly 
from ds_salaries
group by experience_level, employment_type
order by experience_level, employment_type;

-- 5. negara yang gaji yang menarik untuk data analyst, full time, exp kerjanya entry level dan menengah/mid
select 	company_location, 
		AVG(salary_in_usd) avg_sal_in_usd
FROM ds_salaries
WHERE 	job_title LIKE '%data analyst%'
		AND employment_type ='FT'
        AND experience_level IN ('EN' , 'MI')
GROUP BY company_location
HAVING avg_sal_in_usd >= 20000;

-- 6. di tahun berapa, kenaikan gaji dari mid ke senior itu memiliki kenaikan yang tertinggi? 
-- (untuk pekerjaan yang berkaitan dengan data analyst yang penuh waktu
WITH ds_1 AS (
	SELECT
		work_year,
		AVG(salary_in_usd) sal_in_usd_ex
	FROM
		ds_salaries
	WHERE
		employment_type = 'FT'
		AND experience_level = 'EX'
		AND job_title LIKE '%data analyst%'
	GROUP BY
		work_year
),
ds_2 AS (
	SELECT
		work_year,
		AVG(salary_in_usd) sal_in_usd_mi
	FROM
		ds_salaries
	WHERE
		employment_type = 'FT'
		AND experience_level = 'MI'
		AND job_title LIKE '%data analyst%'
	GROUP BY
		work_year
),
t_year AS (
	SELECT
		DISTINCT work_year
	FROM
		ds_salaries
)
SELECT
	t_year.work_year,
	ds_1.sal_in_usd_ex,
	ds_2.sal_in_usd_mi,
	ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi differences
FROM
	t_year
	LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
	LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;