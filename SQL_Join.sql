
--Joining PortfolioProject..CovidDeaths & PortfolioProject..CovidVaccinations

--Looking at Total Population vs Vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum( cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by vac.date) as VacTot
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by location,date


--Using CTE 

with PopvsVac  as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum( cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by vac.date) as VacTot
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
)
select *, (VacTot/population)*100 as PrctgeVac
from PopvsVac;
--where location = 'Egypt';


--Creating View

USE PortfolioProject
GO
create view PrctgePopVacc as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum( cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by vac.date) as VacTot
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null