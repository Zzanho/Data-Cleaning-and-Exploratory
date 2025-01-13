-- Data Cleaning

SELECT 
    *
FROM
    layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns

CREATE TABLE layoffs_staging LIKE world_layoffs.layoffs;

Insert layoffs_staging 
select *
from layoffs;

-- find duplicates

with duplicate_cte as
(
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1 ;

-- create new table to delete duplicates

CREATE TABLE `layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` TEXT,
    `percentage_laid_off` DOUBLE DEFAULT NULL,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised` DOUBLE DEFAULT NULL,
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;

Insert into layoffs_staging2
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) as row_num
from layoffs_staging;

-- delete duplicates 

DELETE FROM layoffs_staging2 
WHERE
    row_num > 1;

-- Standardize Data
	
UPDATE layoffs_staging2 
SET 
    company = TRIM(company);

-- change date format

UPDATE layoffs_staging2 
SET 
    `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

-- change data type of date from text to date

alter table layoffs_staging2
modify column `date` date;

-- found one blank cell and populated it 

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry IS NULL OR industry = '';

UPDATE layoffs_staging2 
SET 
    industry = 'Other'
WHERE
    industry = '';

-- updating all blank values that cannot be populated to null
UPDATE layoffs_staging2 
SET 
    total_laid_off = NULL
WHERE
    total_laid_off = '';

UPDATE layoffs_staging2 
SET 
    percentage_laid_off = NULL
WHERE
    percentage_laid_off = '';

-- Delete row_num column

alter table layoffs_staging2
drop column row_num;

SELECT 
    *
FROM
    layoffs_staging2;










