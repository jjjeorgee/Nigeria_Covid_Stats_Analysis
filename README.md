# SQL Exploratory Data Analysis of Nigeria Covid-19 Data.

![alt](https://github.com/jjjeorgee/Portfolio-Projects/blob/61b007560bfa539d208dbbb13c6f207e77911f54/wew.PNG)

### Abstract
   This is a project utilizing SQL to perform an exploratory analysis of COVID-19 data from the month of February 2020 to the month of March 2022. The data used for this analysis focuses on COVID-19 cases in Nigeria, and is taken from multiple sources chief of which is [ourworldinData.org](https://ourworldindata.org/). 

### Objectives
This analysis is aimed at exploring a few key metrics.

- The infection rate in each state collated with each state's total population.

- The death rate in each state collated with each state's infected population.

- The national infection rate collated with the national death rate.

### Data wrangling 
Before getting to any of these objectives, the data provided must first be cleaned and organized. I worked with 3 major datasets
- Global COVID-19 dataset from [ourworldindata.org](https://ourworldindata.org/covid-deaths)

- COVID-19 dataset from [The NCDC](http://covid19.ncdc.gov.ng).

- COVID-19 vaccinations dataset from [africaopendata.org](https://africaopendata.org/dataset/covid-19-data)

The wrangling was done with the Microsoft Excel spreadsheet tool which was used to covert some xlsx files to the CSV format.

Microsoft Excel was also used to trim some excessively large files to make inporting them into MYSQL Server for analysis much easier. 

Some columns which had the wrong datatype were also fixed using Microsoft Excel.

The rest of the data wrangling was  done using SQL. 
The dataset initially included a lot of redundant or unwanted columns, which were not trimmed in Microsoft Excel. 
And so with the aid of SQL, I was able to retrieve only the data needed for the analysis. The SQL code used may be observed below;

```
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

```

> The code shows how I was able to do this with *SQL Joins* and *Embedded queries*

In order to prepare the data for visualization in Tableau, multiple views had to be created using SQL code. Examples of such code may be observed below;

```
CREATE VIEW GM1 AS
	 SELECT SUM(total_cases), SUM(total_deaths), (SUM(total_deaths)/SUM(total_cases))*100 AS death_percentage
	FROM covid_deaths_Nigeria;

CREATE VIEW GM2 AS
	SELECT date, SUM(new_deaths) AS total_deaths_per_year
	FROM covid_deaths_nigeria
    GROUP BY YEAR(date)
ORDER BY YEAR(date);

```

Also, some date columns in the datasets were not in the standard SQL format of DD-MM-YYYY and this had to corrected using SQL code.



### Exploratory data analysis
There were a lot of interesting metrics to be extracted from the available datasets, but my analysis was focused on the aforementioned objectives. 

#### Objective l
- This was an analysis of the infection rate in each state, collated with each state's total population. 
- This is the SQL code I used for the analysis;

```
SELECT EDI.region, sum(EDI.infected) AS total_infected, EVI.population, (sum(EDI.infected)/EVI.population)*100 AS infection_percentage_per_state
	from extra_death_info EDI
		JOIN extra_vaccination_info EVI
	ON EDI.region = EVI.region
GROUP BY EDI.region;
```
> This code uses SQL joins to combine columns from two tables, in order to get a percentage of the total number of infected persons in each state.
 
- And this is a visualization of this analysis in Tableau![BC978FCB-D91A-44CF-84FE-4753C3824FD3](https://user-images.githubusercontent.com/98137996/180646585-5b3e93aa-8459-46b7-b2ed-23031c26839b.jpeg)
 
As maybe observed from the visualization; 
- Lagos had the highest infection rate, with more than 0.6% if its total population being infected. This is mostly likely the result of Lagos being the most populated state of the country.

- Kogi had the lowest infection rate, as the state reported no infection cases.

- Most of the reported cases of infections were from Lagos and The Federal Capital Territory. 

#### Objective ll
- The second objective was an analysis of the death rate in each state, collated with each state's infected population.
- This is the SQL code I used for the analysis;

```

SELECT EDI.region, SUM(EDI.infected) AS total_infected, SUM(EDI.deaths) AS total_dead, (SUM(EDI.deaths)/SUM(EDI.infected))*100 AS death_percentage_per_state
	from extra_death_info EDI
GROUP BY EDI.region;

```

> The SQL code takes columns from a table named *extra death info* in order to get a percentage of total deaths per state.

- And this is a visualization of this analysis in Tableau ![2D1B1127-3396-4C45-9C4C-F4F4DAF27ABE](https://user-images.githubusercontent.com/98137996/180660220-10461076-5f6d-4ddd-b0c8-b5bb0058662f.jpeg)
As may be observed from the visualization;
- Edo had the highest deaths per infections of all the states.

- Anambra had the lowest deaths per infections of all the states.

- Kogi does not appear on the chart as it had recorded no infection cases which could result in deaths.

- Lagos, although having the highest infection rate, has one of the lowest death rates which could be a product of multiple factors such as; 
> - high number of unreported or misreported deaths
> - access to proper medical facilites
> - early acess to vaccines.

Objective lll
- This was aimed at comparing the national infection rate and death rate. This comparison is done with data collected from February 2020 to March 2022.
- The SQL code used may be observed below;

```
SELECT date, population, total_cases, (total_cases/population)*100 AS infected_population_percentage
	FROM covid_deaths_Nigeria
ORDER BY 1, 2;

```
> This is SQL code showing the infected percentage of the country's total population.

```
SELECT date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS infected_population_percentage
	FROM covid_deaths_Nigeria
ORDER BY 1, 2;
```
> This is SQL code showing the death percentage of the country's total infected population

- This data is visualized below![6DB5EBE9-B7C5-45B6-BBA8-D731890B18CB](https://user-images.githubusercontent.com/98137996/180663039-ac5f0190-043f-4d8a-aef3-87ca8c65d945.jpeg)
As may be observed from the visualization
- Death rate rose rapidly from early 2020, and peaked in mid 2020 around when the pandemic was announced, with the infection rate rapidly climbing, and has been perpetually declining since then.

- Infection rate was continously rising from the start of 2020 and peaked in early 2022, before it started declining with decreasing death rate.

### Conclusion 
The datasets had a lot of stories to tell and there were a lot more metrics to analyze, but those are beyond the scope of this exploratory analysis.

For a more detailed look at the metrics analyzed above, the dashboard containing them is available to be viewed here on [Tableaupublic.com](https://public.tableau.com/app/profile/oladimeji.olaniyan/viz/NigeriaCOVID-19Data/Dashboard1).

All the SQL code i used for the exploratory analysis may be viewed in this [repository](https://github.com/jjjeorgee/Nigeria_Covid_Stats_Analysis/blob/main/Nigeria%20COVID%20data(SQL%20Data%20Exploration%20Project).sql)

### Written in
SQL

### Authors
> 👤 Olaniyan Oladimeji
- Github: [jjjeorgee](https://github.com/jjjeorgee)
- Linkedin: [Olaniyan Oladimeji](https://www.linkedin.com/mwlite/in/oladimeji-olaniyan-a3a114170)
- Twitter: [jjjeorge_v3](https://www.twitter.com/jjjeorge_v3)
