USE PortfolioProject


/*
Queries used for Tableau Project
*/

-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, ROUND(SUM(cast(new_deaths as float))/SUM(CAST(New_Cases as float))*100,2) as DeathPercentage
From PortfolioProject..Covid_Deaths
--Where country like '%argentina%'
where continent is not null 
--Group By date
order by 1,2



Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, ROUND(SUM(cast(new_deaths as float))/SUM(New_Cases)*100,2) as DeathPercentage
From PortfolioProject..Covid_Deaths
--Where location like '%argentina%'
where country = 'World'
--Group By date
order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select country, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths
--Where location like '%argentina%'
Where continent is null 
and country not in ('World', 'European Union', 'International','World excl. China', 'World excl. China and South Korea','World excl. China, South Korea, Japan and Singapore',
'High-income countries', 'Upper-middle-income countries','Asia excl. China','European Union (27)','Lower-middle-income countries','Low-income countries','Winter Olympics 2022',
'Summer Olympics 2020','Transnistria','Scotland','Wales','England','England & Wales','Northern Ireland') 
Group by country
order by TotalDeathCount desc


-- 3.

Select country, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Covid_Deaths
--Where location like '%argentina%'
Group by country, Population
order by PercentPopulationInfected desc


-- 4.


Select country, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Covid_Deaths
--Where location like '%states%'
Group by country, Population, date
order by PercentPopulationInfected desc





--Some extra analysis queries.

Select dea.continent, dea.country, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_Deaths dea
Join PortfolioProject..Covid_Vaccination vac
	On dea.country = vac.country
	and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.country, dea.date, dea.population
order by RollingPeopleVaccinated DESC;





Select country, date, population, total_cases, total_deaths
From PortfolioProject..Covid_Deaths
--Where location like '%argentina%'
where continent is not null 
order by total_deaths DESC;



 

Select country, Population,date, MAX(total_cases) as HighestInfectionCount,  ROUND(Max(CAST(total_cases as float)/(CAST(population as float)*100)),2) as PercentPopulationInfected
From PortfolioProject..Covid_Deaths
--Where location like '%argentina%'
Group by country, Population, date
order by PercentPopulationInfected desc




