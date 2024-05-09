-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;
-- Maximum number of individuals laid of from a company is 12000(Google)

SELECT *
FROM layoffs_staging2 
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;
-- Britishvolt raised 2400 million dollars after which the company completely shut down

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
-- Amazon laid off a total of 18150 individuals


SELECT MIN(`date`),MAX(`date`)
FROM layoffs_staging2;
-- This dataset has dataset between 11th March 2020 and 06th March 2023


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
-- The consumer industry was affected the most as it had a sum of 45182 individuals laid off.


SELECT * 
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
-- United States had the most number of layoffs with 256420 individuals


SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;
-- Sum of around 16171 individuals were laid off on 04th January 2023


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;
-- As per this dataset, a total of 160322 individuals were laid off in 2022


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 2 DESC;
-- 84714 individuals were laid off in the month of January 2023(The highest)


WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 2 DESC
)
SELECT `MONTH`, total_off, 
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;
-- During the month of March in 2020, there were a total of 9628 layoffs, which went upto a rolling total of 383820 in March 2023


SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

-- Year by year ranking of which company laid off the most(Top 5)
WITH Company_Year(company,years,total_laid_off) AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
), Company_Year_Rank AS
(
SELECT * , DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5;

-- UBER had most number of layoffs in the year 2020 with 7525 individuals
-- Bytedance had most number of layoffs in the year in 2021 with 3600 individuals
-- Meta had most number of layoffs in the year 2022 with 11000 individuals
-- Google had most number of layoffs in the year 2023 with 12000 individuals



-- Year by year ranking of which industry had most layoffs(Top 5)
WITH Industry_Year(industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
), Industry_Year_Rank AS
( 
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
From Industry_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Industry_Year_Rank
WHERE Ranking<=5;


-- Year by year ranking of which country had most layoffs(Top 5)
WITH Country_Year (country, years, total_laid_off)AS
(
SELECT country, YEAR(`date`), SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY country,YEAR(`date`)
),Country_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as Ranking
FROM Country_Year
WHERE years  IS NOT NULL
)
SELECT * 
FROM Country_Year_Rank
WHERE Ranking <=5;

-- United States had most number of layoffs in the year 2020,2021,2022 and 2023 with 50385, 9470, 106381 and 89684 individuals respectively.


SELECT * 
FROM layoffs_staging2; 


-- Funds raised each year by the companies.
WITH Company_Fund (company, years, funds) AS
(
SELECT company, YEAR(`date`), SUM(funds_raised_millions)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),Company_Fund_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY funds DESC)  AS Ranking
FROM Company_Fund
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Fund_Rank
WHERE Ranking<=5;


-- Funds raised each year by the industries
WITH Industry_Fund (industry, years, funds) AS
(
SELECT industry, YEAR(`date`), SUM(funds_raised_millions)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
),Industry_Fund_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY funds DESC)  AS Ranking
FROM Industry_Fund
WHERE years IS NOT NULL
)
SELECT *
FROM Industry_Fund_Rank
WHERE Ranking<=5;


-- Funds raised each year(Country)
WITH Country_Fund (country, years, funds) AS
(
SELECT country, YEAR(`date`), SUM(funds_raised_millions)
FROM layoffs_staging2
GROUP BY country, YEAR(`date`)
),Country_Fund_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY funds DESC)  AS Ranking
FROM Country_Fund
WHERE years IS NOT NULL
)
SELECT *
FROM Country_Fund_Rank
WHERE Ranking<=5;
