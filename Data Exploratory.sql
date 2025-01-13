-- Exploratory Data Analysis

SELECT 
    *
FROM
    world_layoffs.layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were

SELECT 
    MAX(total_laid_off), MAX(percentage_laid_off)
FROM
    world_layoffs.layoffs_staging2
WHERE
    percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
-- if we order by funcs_raised_millions we can see how big some of these companies were

SELECT 
    *
FROM
    world_layoffs.layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY funds_raised DESC;

-- Companies with the biggest single Layoff

SELECT 
    company, SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Companies with the most Total Layoffs
SELECT 
    company, SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- by location
SELECT 
    location, SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC;

-- this it total in the past 3 years or in the dataset

SELECT 
    country, SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT 
    YEAR(date), SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

SELECT 
    industry, SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT 
    stage, SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;





SELECT 
    YEAR(`date`), SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT 
    stage, SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT 
    company, AVG(percentage_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Rolling total of layoffs per month
SELECT 
    SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;
 
-- used it in a CTE to query off of it 
With Rolling_Total AS (
SELECT 
    SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) as tlo
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
)
select `month`, 
tlo as total, sum(tlo) over (order by `month`) as rolling_total
from Rolling_Total;

--  Earlier we looked at Companies with the most Layoffs.
--  Now let's look at that per year. 

SELECT 
    company, SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;

with Company_Year (company, years, total_laid_off) as
(
SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    world_layoffs.layoffs_staging2
GROUP BY company , YEAR(`date`)
), Company_Year_Rank AS
(
select *, 
dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
select *
from Company_Year_Rank
where Ranking <= 5;













