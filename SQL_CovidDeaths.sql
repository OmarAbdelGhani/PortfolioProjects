
--Viewing the Data

select *
from PortfolioProject..CovidDeaths
order by location

--changing coloumns data type to avoid errors and casting

ALTER TABLE CovidDeaths
--ALTER COLUMN total_cases float
ALTER COLUMN total_deaths float

--Ratio of TotalDeaths to TotalCases

select location,date,total_cases,total_deaths,(total_deaths/total_cases) as ratio
from CovidDeaths
where location = 'Egypt'
order by location

--changing coloumns data type to avoid errors and casting

ALTER TABLE CovidDeaths
ALTER COLUMN population bigint

--Ratio of TotalDeaths to TotalPopulation

select location,date,total_cases,population,(total_cases/population)*100 as CovidPrctge
from CovidDeaths
where location = 'Egypt'
order by location


--Maximum Infection Percentage in each country

select location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as CovidPrctge
from CovidDeaths
--where location = 'Egypt'
group by location,population
order by CovidPrctge DESC 

--Total Deaths in each country
select location,population,MAX(total_deaths) as TotalDeaths
from CovidDeaths
--where location = 'Egypt'
where continent is not null
group by location,population
order by TotalDeaths DESC 

--Total Deaths in each continent

select continent,MAX(total_deaths) as TotalDeaths
from CovidDeaths
--where location = 'Egypt'
where continent is not null
group by continent
order by TotalDeaths DESC 

--Total Deaths in each continent in another way -> displays more accurate results for some reason

select location,MAX(total_deaths) as TotalDeaths
from CovidDeaths
--where location = 'Egypt'
where continent is  null
group by location
order by TotalDeaths DESC 

--New Cases,New Deaths, Percentage of New Deaths to New Cases each day

select date,sum(new_cases) as cases,sum(new_deaths) as deaths,sum(new_deaths)*100/sum(new_cases) as DeathPrctge 
from PortfolioProject..CovidDeaths
where continent is not null
group by date
having sum(new_cases) !=0
order by date
