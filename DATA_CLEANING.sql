										-- ''           Task to do                       ''
										-- Create a new table and add copy the data to it.
										-- Remove Duplicate Values
										-- Remove Null values and Blank Values
										-- Standardize the Data
										-- Remove any columns that are unnessary

CREATE TABLE layoff_temp 
LIKE layoffs;

SELECT * FROM layoff_temp;


INSERT INTO layoff_temp 
SELECT * FROM layoffs;

                                                 -- REMOVING DUPLICATES--

WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions)
 AS temp_row 
FROM layoff_temp
)
SELECT * FROM duplicate_cte
WHERE temp_row>1;


CREATE TABLE `layoff_temp2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `temp_row` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




INSERT INTO layoff_temp2 
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) 
AS temp_row 
FROM layoff_temp;

SELECT * FROM layoff_temp2;

SELECT * FROM layoff_temp2 WHERE temp_row >1;

DELETE FROM layoff_temp2 WHERE temp_row >1;

                                              -- STANDARDIZING DATA -- 

SELECT company, TRIM(company)
FROM layoff_temp2;

UPDATE layoff_temp2 
SET company=TRIM(company);

SELECT DISTINCT industry
FROM layoff_temP2
ORDER BY 1;


SELECT * 
FROM layoff_temp2 
WHERE industry LIKE 'CRYPTO%';

UPDATE layoff_temp2
SET industry='crypto'
WHERE industry LIKE 'CRYPTO%';

SELECT DISTINCT COUNTRY
FROM layoff_temP2
ORDER BY 1;

UPDATE layoff_temp2
SET country='United States'
WHERE country LIKE 'United States.';

SELECT `DATE` 
FROM layoff_temp2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoff_temp2;


UPDATE layoff_temp2
SET `date`=STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoff_temp2 
MODIFY COLUMN `date` DATE;



                                        -- Removing Null values and Blank Values--
                                        

SELECT DISTINCT industry
FROM layoff_temP2
ORDER BY 1;

SELECT * FROM layoff_temp2
WHERE industry IS NULL
OR industry='';

UPDATE layoff_temp2
SET industry= NULL
WHERE industry='';

SELECT * FROM layoff_temp2
WHERE company='Airbnb';


SELECT * 
FROM layoff_temp2 AS lt1
JOIN layoff_temp2 AS lt2
	ON lt1.company=lt2.company
    AND lt1.location=lt2.location
WHERE (lt1.industry IS NULL OR lt1.industry='')
AND lt2.industry IS NOT NULL;

UPDATE layoff_temp2 AS lt1
JOIN layoff_temp2 AS lt2
	ON lt1.company=lt2.company
SET lt1.industry=lt2.industry
WHERE (lt1.industry IS NULL OR lt1.industry='')
AND lt2.industry IS NOT NULL;


SELECT * FROM layoff_temp2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoff_temp2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


ALTER TABLE layoff_temp2
DROP COLUMN temp_row;

SELECT * FROM layoff_temp2;