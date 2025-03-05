USE PortfolioProject

Select *
From Covid_Deaths
Where continent is not null
Order By 3,4

--Select *
--From Covid_Vaccination
--Order By 3,4

-- Select Data that we are going to be using

Select country, date, total_cases, new_cases, total_deaths, population
From Covid_Deaths
Order By 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in your country.

Select country, date, total_cases, total_deaths, ROUND ((CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100, 2) AS DeathPercentage
From Covid_Deaths
Where country like '%Argentina%' 
Order By 1,2


-- Looking at Total Cases vs Population

Select country, date, population, total_cases, ROUND ((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100, 2) AS InfectionPercentage
From Covid_Deaths
-- Where country like '%Argentina%' 
Order By 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select country, population, MAX(total_cases) as HighestInfectionCount, MAX(ROUND ((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100, 2)) AS InfectionPercentage
From Covid_Deaths
-- Where country like '%Argentina%'
Group By country, population
Order By InfectionPercentage DESC


-- Showing Continents with Highest Death Count per Population

Select continent, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From Covid_Deaths
-- Where country like '%Argentina%'
Where continent is not null
Group By continent
Order By TotalDeathCount DESC


-- Now I'll break it down by Countries

Select country, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From Covid_Deaths
-- Where country like '%Argentina%'
Where continent is not null
Group By country
Order By TotalDeathCount DESC


-- Global numbers

Select date, SUM(new_cases) as total_cases, SUM(CAST(new_Deaths as int)) as total_Deaths, SUM(CAST(new_deaths as int))/NULLIF (SUM(new_cases)*100, 0) as Death_Percentage
From Covid_Deaths
-- Where country like '%Argentina%' 
Where continent is not null
Group By date
Order By 1,2

-- Goblal Death percentage

Select
CAST(SUM(new_cases) AS bigint) as total_cases,
CAST(SUM(new_deaths) AS bigint) as total_deaths,
ROUND((CONVERT(float, SUM(CAST(new_deaths as bigint))) / NULLIF(CONVERT(float, SUM(CAST(new_cases as bigint))),0))*100, 2) as Death_Percentage
From Covid_Deaths
Where continent is not null
Order By 1,2


-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.country, dea.population, vac.daily_vaccinations,
     SUM(CONVERT(bigint, vac.daily_vaccinations)) 
	 OVER (Partition By dea.country Order By dea.date) as Rolling_People_Vaccinated
From PortfolioProject..Covid_Deaths dea
JOIN PortfolioProject..Covid_Vaccination vac
ON dea.country = vac.country
and dea.date = vac.date
Where dea.continent is not null
Order By 2,3


-- USE CTE

With PopvsVac (Continent, Country, date, population, daily_vaccinations, Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.country, dea.date, dea.population, vac.daily_vaccinations,
     SUM(CONVERT(bigint, vac.daily_vaccinations)) 
	 OVER (Partition By dea.country Order By dea.date) as Rolling_People_Vaccinated
From PortfolioProject..Covid_Deaths dea
JOIN PortfolioProject..Covid_Vaccination vac
ON dea.country = vac.country
and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3
)
Select *, 
    CAST(CAST(Rolling_People_Vaccinated as decimal(12,2)) / CAST(population as decimal(12,2)) * 100 as decimal(18,2)) as Vaccinated_Percentage
From PopvsVac


-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Country nvarchar(255),
Date date,
Population numeric,
Daily_Vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.country, dea.date, dea.population, vac.daily_vaccinations,
     SUM(CONVERT(bigint, vac.daily_vaccinations)) 
	 OVER (Partition By dea.country Order By dea.date) as Rolling_People_Vaccinated
From PortfolioProject..Covid_Deaths dea
JOIN PortfolioProject..Covid_Vaccination vac
ON dea.country = vac.country
and dea.date = vac.date
--Where dea.continent is not null
--Order By 2,3

Select *, 
    CAST(CAST(Rolling_People_Vaccinated as decimal(18,2)) / CAST(population as decimal(18,2)) * 100 as decimal(18,2)) as Vaccinated_Percentage
From #PercentPopulationVaccinated
GO


-- Creating view to store data for later visualizations

CREATE VIEW Percent_Population_Vaccinated as
Select dea.continent, dea.country, dea.date, dea.population, vac.daily_vaccinations,
     SUM(CONVERT(bigint, vac.daily_vaccinations)) 
	 OVER (Partition By dea.country Order By dea.date) as Rolling_People_Vaccinated
From PortfolioProject..Covid_Deaths dea
JOIN PortfolioProject..Covid_Vaccination vac
ON dea.country = vac.country
and dea.date = vac.date
Where dea.continent is not null
-- Order By 2,3


--Checking if view was created succesfully.
SELECT name 
FROM sys.views 
WHERE name = 'Percent_Population_Vaccinated';

