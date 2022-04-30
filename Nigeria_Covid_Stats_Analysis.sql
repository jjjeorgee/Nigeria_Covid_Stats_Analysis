-- Data that we will be Working With --
SELECT CDN.date, CDN.new_cases, CDN.total_cases, CDN.new_deaths, CDN.total_deaths, CDN.population,
	   EDI.region, EDI.infected, EDI.deaths, EDI.cured,
       CVN.new_vaccinations,
       EVI.total_vaccinated_population 
	FROM covid_deaths_Nigeria AS CDN
    JOIN extra_death_info AS EDI
    ON CDN.date = EDI.date 
	JOIN covid_vaccinations_nigeria AS CVN
	ON CDN.date = CVN.date
    JOIN extra_vaccination_info AS EVI
    ON EDI.region = EVI.region
ORDER BY 1;


-- Likelihood of Dying if You Contract Covid in Nigeria --
 SELECT SUM(total_cases), SUM(total_deaths), (SUM(total_deaths)/SUM(total_cases))*100 AS death_percentage
	FROM covid_deaths_Nigeria;

-- Total Death Count Per Year --
SELECT date, SUM(new_deaths) AS total_deaths_per_year
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

-- Total Death Count Per Month --
SELECT date, SUM(new_deaths) AS total_deaths_per_months
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

-- Total Death Count Per State --
SELECT region, SUM(deaths) AS sum_of_deaths
	FROM extra_death_info
GROUP BY region;

-- Percentage of the Nigerian Population that got Covid --
SELECT date, population, total_cases, (total_cases/population)*100 AS infected_population_percentage
	FROM covid_deaths_Nigeria
ORDER BY 1, 2;

-- Infected Percentage Per State --
SELECT EDI.region, sum(EDI.infected) AS total_infected, EVI.population, (sum(EDI.infected)/EVI.population)*100 AS infection_percentage_per_state
from extra_death_info EDI
JOIN extra_vaccination_info EVI
ON EDI.region = EVI.region
GROUP BY EDI.region
ORDER BY infection_percentage_per_state DESC;

-- Infected Percentage Per State of Global Population --
SELECT T1.region, T1.infected_count, T1.population, (T1.infected_count/T1.population)*100 AS infected_percentage
	FROM (SELECT EDI.region, CDE.population, SUM(EDI.infected) AS infected_count
		FROM  covid_deaths_nigeria AS CDE
		JOIN extra_death_info AS EDI
		ON CDE.date = EDI.date
		GROUP BY EDI.region) T1
	GROUP BY T1.region
ORDER BY 1;

-- Vaccinated Percentage Per State of Global Population --
WITH T1 AS (
	SELECT region, total_vaccinated_population 
	FROM extra_vaccination_info
ORDER BY 1)
SELECT DISTINCT T1.region, T1.total_vaccinated_population, CDN.population AS global_population, (total_vaccinated_population/population)*100 AS vaccinated_percentage
FROM T1, covid_deaths_nigeria AS  CDN
ORDER BY 1;


-- Creating Views for Visualization --
CREATE VIEW V1 AS
	 SELECT SUM(total_cases), SUM(total_deaths), (SUM(total_deaths)/SUM(total_cases))*100 AS death_percentage
	FROM covid_deaths_Nigeria;

CREATE VIEW V2 AS
	SELECT date, SUM(new_deaths) AS total_deaths_per_year
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

CREATE VIEW V3 AS
	SELECT date, SUM(new_deaths) AS total_deaths_per_months
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

CREATE VIEW V4 AS
	SELECT region, SUM(deaths) AS sum_of_deaths
	FROM extra_death_info
GROUP BY region;

CREATE VIEW V5 AS 
	SELECT date, population, total_cases, (total_cases/population)*100 AS infected_population_percentage
	FROM covid_deaths_Nigeria
ORDER BY 1, 2;

CREATE VIEW V6 AS
	SELECT T1.region, T1.infected_count, T1.population, (T1.infected_count/T1.population)*100 AS infected_percentage
	FROM (SELECT EDI.region, CDE.population, SUM(EDI.infected) AS infected_count
		FROM  covid_deaths_nigeria AS CDE
		JOIN extra_death_info AS EDI
		ON CDE.date = EDI.date
		GROUP BY EDI.region) T1
	GROUP BY T1.region
ORDER BY 1;

CREATE VIEW V7 AS
	WITH T1 AS (
	SELECT region, total_vaccinated_population 
	FROM extra_vaccination_info
ORDER BY 1)
SELECT DISTINCT T1.region, T1.total_vaccinated_population, CDN.population AS global_population, (total_vaccinated_population/population)*100 AS vaccinated_percentage
FROM T1, covid_deaths_nigeria AS  CDN
ORDER BY 1;

CREATE VIEW V8 AS
SELECT EDI.region, sum(EDI.infected) AS total_infected, EVI.population, (sum(EDI.infected)/EVI.population)*100 AS infection_percentage_per_state
from extra_death_info EDI
JOIN extra_vaccination_info EVI
ON EDI.region = EVI.region
GROUP BY EDI.region
ORDER BY infection_percentage_per_state DESC;

CREATE VIEW V9 AS
SELECT CDN.date, CDN.population, CVN.total_vaccinations, (CVN.total_vaccinations/CDN.population)*100 AS vaccinated_population_percentage
	FROM covid_deaths_Nigeria CDN
    JOIN covid_vaccinations_nigeria CVN
    ON CDN.date = CVN.date
ORDER BY 1;

CREATE VIEW V10 AS
SELECT *
    FROM covid_deaths_Nigeria;