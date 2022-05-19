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


-- Likelihood of Contracting Covid --
SELECT SUM(new_cases), population, (SUM(new_cases)/population)*100 AS death_percentage
	FROM covid_deaths_Nigeria;


-- Likelihood of Dying if You Contract Covid in Nigeria --
 SELECT SUM(new_cases), SUM(new_deaths), (SUM(new_deaths)/SUM(new_cases))*100 AS death_percentage
	FROM covid_deaths_Nigeria;
    
    -- COUNTS --
    
-- Total infection Count Per Year --
SELECT date, SUM(new_cases) AS total_infections_per_year
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

-- Total Infection Count Per Month --
SELECT date, SUM(new_cases) AS total_infections_per_months
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

-- Total Infection Count Per State --
SELECT region, SUM(infected) AS sum_of_deaths
	FROM extra_death_info
GROUP BY region;

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

-- Total vaccinated Count Per Year --
SELECT date, SUM(new_vaccinations) AS total_vaccinations_per_year
	FROM covid_vaccinations_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

-- Total Vaccinated Count Per Month --
SELECT date, SUM(new_vaccinations) AS total_vaccinations_per_month
	FROM covid_vaccinations_nigeria
    GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

-- Total vaccinated Count Per State --
SELECT region, total_vaccinated_population 
	FROM extra_vaccination_info;

-- PERCENTAGE PROGRESSIONS --

-- Percentage Progression of the Nigerian Population that got Covid --
SELECT date, population, total_cases, (total_cases/population)*100 AS infected_population_percentage
	FROM covid_deaths_Nigeria
ORDER BY 1, 2;

-- Percentage Progression of the Nigerian Population that died from Covid --
SELECT date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS infected_population_percentage
	FROM covid_deaths_Nigeria
ORDER BY 1, 2;

-- Infection Percentage Per State --
SELECT EDI.region, sum(EDI.infected) AS total_infected, EVI.population, (sum(EDI.infected)/EVI.population)*100 AS infection_percentage_per_state
	from extra_death_info EDI
		JOIN extra_vaccination_info EVI
	ON EDI.region = EVI.region
GROUP BY EDI.region;

-- Infected Percentage Per State of Global Population --
SELECT T1.region, T1.infected_count, T1.population, (T1.infected_count/T1.population)*100 AS infected_percentage
	FROM (SELECT EDI.region, CDE.population, SUM(EDI.infected) AS infected_count
		FROM  covid_deaths_nigeria AS CDE
			JOIN extra_death_info AS EDI
		ON CDE.date = EDI.date
		GROUP BY EDI.region) T1
	GROUP BY T1.region
ORDER BY 1;

-- Death Percentage Per State --
SELECT EDI.region, SUM(EDI.infected) AS total_infected, SUM(EDI.deaths) AS total_dead, (SUM(EDI.deaths)/SUM(EDI.infected))*100 AS death_percentage_per_state
	from extra_death_info EDI
GROUP BY EDI.region;

-- Death Percentage Per State of Global Infected --
SELECT EDI.region, SUM(EDI.deaths) AS total_dead, (SELECT SUM(infected)
	FROM extra_death_info) AS Global_infected, (SUM(EDI.deaths)/(SELECT SUM(infected)
		FROM extra_death_info))*100 AS death_percentage_per_state
	FROM extra_death_info EDI
GROUP BY EDI.region;

-- Percentage Progression of the Nigerian Population that got Vaccinated --
SELECT date, population, total_vaccinations, (total_vaccinations/population)*100 AS infected_population_percentage
	FROM covid_vaccinations_nigeria
ORDER BY 1, 2;

-- Vaccinated Percentage Per State of Global Population --
WITH T1 AS (
	SELECT region, total_vaccinated_population 
		FROM extra_vaccination_info
			ORDER BY 1)
		SELECT DISTINCT T1.region, T1.total_vaccinated_population, CDN.population AS global_population, (total_vaccinated_population/population)*100 AS vaccinated_percentage
	FROM T1, covid_deaths_nigeria AS  CDN
ORDER BY 1;

-- CREATING VISUALIZATIONS --

CREATE VIEW GM1 AS
	 SELECT SUM(total_cases), SUM(total_deaths), (SUM(total_deaths)/SUM(total_cases))*100 AS death_percentage
	FROM covid_deaths_Nigeria;

CREATE VIEW GM2 AS
	SELECT date, SUM(new_deaths) AS total_deaths_per_year
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

CREATE VIEW COUNT AS
SELECT date, SUM(new_cases) AS total_infections_per_year
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

CREATE VIEW COUNT1 AS
SELECT date, SUM(new_cases) AS total_infections_per_months
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

CREATE VIEW COUNT2 AS 
	SELECT region, SUM(infected) AS sum_of_infected
	FROM extra_death_info
GROUP BY region;

CREATE VIEW COUNT3  AS
SELECT date, SUM(new_deaths) AS total_deaths_per_year
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

CREATE VIEW COUNT4 AS
	SELECT date, SUM(new_deaths) AS total_deaths_per_months
		FROM covid_deaths_nigeria
    GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

CREATE VIEW COUNT5 AS
SELECT region, SUM(deaths) AS sum_of_deaths
	FROM extra_death_info
GROUP BY region;

CREATE VIEW COUNT6 AS
SELECT date, SUM(new_vaccinations) AS total_vaccinations_per_year
	FROM covid_vaccinations_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

CREATE VIEW COUNT7 AS
SELECT date, SUM(new_vaccinations) AS total_vaccinations_per_month
	FROM covid_vaccinations_nigeria
    GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date), MONTH(date);

CREATE VIEW PP1 AS
-- Percentage Progression of the Nigerian Population that got Covid --
SELECT date, population, total_cases, (total_cases/population)*100 AS infected_population_percentage
	FROM covid_deaths_Nigeria
ORDER BY 1, 2;

CREATE VIEW PP2 AS
SELECT date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS infected_population_percentage
	FROM covid_deaths_Nigeria
ORDER BY 1, 2;

CREATE VIEW PP3 AS
SELECT EDI.region, sum(EDI.infected) AS total_infected, EVI.population, (sum(EDI.infected)/EVI.population)*100 AS infection_percentage_per_state
	from extra_death_info EDI
		JOIN extra_vaccination_info EVI
	ON EDI.region = EVI.region
GROUP BY EDI.region;

CREATE VIEW PP4 AS
SELECT T1.region, T1.infected_count, T1.population, (T1.infected_count/T1.population)*100 AS infected_percentage
	FROM (SELECT EDI.region, CDE.population, SUM(EDI.infected) AS infected_count
			FROM  covid_deaths_nigeria AS CDE
				JOIN extra_death_info AS EDI
			ON CDE.date = EDI.date
		GROUP BY EDI.region) T1
	GROUP BY T1.region
ORDER BY 1;

CREATE VIEW PP5 AS
SELECT EDI.region, SUM(EDI.infected) AS total_infected, SUM(EDI.deaths) AS total_dead, (SUM(EDI.deaths)/SUM(EDI.infected))*100 AS death_percentage_per_state
	from extra_death_info EDI
GROUP BY EDI.region;

CREATE VIEW PP6 AS
SELECT EDI.region, SUM(EDI.deaths) AS total_dead, (SELECT SUM(infected)
	FROM extra_death_info) AS Global_infected, (SUM(EDI.deaths)/(SELECT SUM(infected)
		FROM extra_death_info))*100 AS death_percentage_per_state
	FROM extra_death_info EDI
GROUP BY EDI.region;

CREATE VIEW PP7 AS
SELECT date, population, total_vaccinations, (total_vaccinations/population)*100 AS infected_population_percentage
	FROM covid_vaccinations_nigeria
ORDER BY 1, 2;

CREATE VIEW PP8 AS
WITH T1 AS (
	SELECT region, total_vaccinated_population 
		FROM extra_vaccination_info
			ORDER BY 1)
		SELECT DISTINCT T1.region, T1.total_vaccinated_population, CDN.population AS global_population, (total_vaccinated_population/population)*100 AS vaccinated_percentage
	FROM T1, covid_deaths_nigeria AS  CDN
ORDER BY 1;
-- pheww --