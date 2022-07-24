# SQL Exploratory Data Analysis of Nigeria Covid-19 Data.

![alt](https://github.com/jjjeorgee/Portfolio-Projects/blob/61b007560bfa539d208dbbb13c6f207e77911f54/wew.PNG)

#### Abstract
   This is a project utilizing SQL to perform an exploratory analysis of COVID-19 data from the month of February 2020 to the month of March 2022, specifically from Nigeria.
   
This data is taken from multiple sources chief of which is [OurworldinData.org](https://ourworldindata.org/). 

#### Objectives
This analysis is aimed at exploring a few key metrics.

- The infection rate in each state collated with each state's total population.

- The death rate on each state collated with each states infected population.

- The national infection rate collated with the national death rate.

- Vaccinated population of each state of the country.

#### Data wrangling 
Before getting to any of these objectives, the data provided must first be cleaned and organized. I worked with 3 major datasets
- Global COVID-19 dataset from [ourworldindata.org](https://ourworldindata.org/covid-deaths)

- COVID-19 dataset from [The NCDC](http://covid19.ncdc.gov.ng).

- COVID-19 vaccinations dataset from [africaopendata.org](https://africaopendata.org/dataset/covid-19-data)

The wrangling was done with the Microsoft Excel soreadsheet tool which was used to covert some xlsx files to the CSV format, and also with SQL.

Majority of the data wrangling was  done using SQL. 
The dataset initially included a lot of redundant or unwanted columns,
and so with the aid of SQL, I was able to retrieve only the data needed for the analysis.

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

>The code above shows how I was able to do this with *SQL Joins* and *Embedded queries*

#### Exploratory data analysis
There were alot of interesting metrics to be extracted from the available datasets, but my analysis was focused certain onjectives. 

#### Visualization 
 This was done using tableau to create a dashboard of some key metrics.
This dashboard is available here on [Tableaupublic.com](https://public.tableau.com/app/profile/oladimeji.olaniyan/viz/NigeriaCOVID-19Data/Dashboard1)

#### Written in
SQL

#### Authors
> 👤 Olaniyan Oladimeji
- Github: [jjjeorgee](https://github.com/jjjeorgee)
- Linkedin: [Olaniyan Oladimeji](https://www.linkedin.com/mwlite/in/oladimeji-olaniyan-a3a114170)
- Twitter: [jjjeorge_v3](https://www.twitter.com/jjjeorge_v3)
