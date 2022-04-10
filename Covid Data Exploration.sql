
--Review CovidDeath table
SELECT *
FROM dbo.CovidDeath
ORDER BY date;

--Find useful data in CovidDeath data by country
SELECT *
FROM DBO.CovidDeath
WHERE continent is not null;


SELECT location, date,population, total_cases, new_cases, total_deaths
FROM dbo.CovidDeath
ORDER BY 1,2;

/*mortality rate*/
--Find daily mortality rate by country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as MortalityRate
FROM dbo.CovidDeath
WHERE continent is not null
ORDER BY 1,2;
--Find daily mortality rate by continent or area
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as MortalityRate
FROM dbo.CovidDeath
WHERE continent is null
ORDER BY 1,2;
--Find daily mortality rate in china
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as MortalityRate
FROM dbo.CovidDeath
WHERE location='china'
ORDER BY 2;
--Find daily mortality rate in US
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as MortalityRate
FROM dbo.CovidDeath
WHERE location='United States'
ORDER BY 2;
--Find the highest mortality rate by country
Select Location,Max((total_deaths/total_cases))*100 as HighestMortalityRate
From dbo.CovidDeath
WHERE continent is not null
Group by Location
order by HighestMortalityRate desc;
--Find the total death cases by country
Select  location, Max (cast(Total_deaths as int))as total_deaths
From dbo.CovidDeath
WHERE continent is not null
Group by Location
order by total_deaths desc;
--Find the highest mortality rate by continent or area
Select Location,Max((total_deaths/total_cases))*100 as HighestMortalityRate
From dbo.CovidDeath
WHERE continent is null
Group by Location
order by HighestMortalityRate desc;
--Find the total death cases by continent or area
Select  location, Max(cast(Total_deaths as int))as total_deaths
From dbo.CovidDeath
WHERE continent is null
Group by Location
order by total_deaths desc;



/*Infection Rate*/
--Find daily Infection Rate by country
SELECT location, date,population, total_cases, (total_cases/population)*100 as InfectionRate
FROM dbo.CovidDeath
WHERE continent is not null
ORDER BY 1,2;
--Find daily Infection Rate by continent or area
SELECT location, date,population, total_cases, (total_cases/population)*100 as InfectionRate
FROM dbo.CovidDeath
WHERE continent is null
ORDER BY 1,2;
--Find daily Infection Rate in china
SELECT location, date,population, total_cases, (total_cases/population)*100 as InfectionRate
FROM dbo.CovidDeath
WHERE location='china'
ORDER BY 2;
--Find daily Infection Rate in US
SELECT location, date,population, total_cases, (total_cases/population)*100 as InfectionRate
FROM dbo.CovidDeath
WHERE location='United States'
ORDER BY 2;
--Find the most of infection cases &the highest Infection Rate by country
Select Location, Population,Max (cast(total_cases as int))as total_cases, Max((total_cases/population))*100 as HighestInfectionRate
From dbo.CovidDeath
WHERE continent is not null
Group by Location, Population
order by HighestInfectionRate desc;
--Find the most of infection cases &the highest Infection Rate by continent or area
Select Location,Population,Max (cast(total_cases as int))as total_cases, Max((total_cases/population))*100 as HighestInfectionRate
From dbo.CovidDeath
WHERE continent is null
Group by Location, population
order by HighestInfectionRate desc;


--Goble total cases &total deaths & mortality rate
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as MortalityRate
From dbo.CovidDeath
where continent is not null ;

Select max(total_cases) as total_cases, max(cast(total_deaths as int)) as total_deaths, max(cast(total_deaths as int))/MAX(total_cases)*100 as MortalityRate
From dbo.CovidDeath;


--Review CovidVaccinated table
SELECT *
FROM dbo.CovidVaccinated

--Join CovidVaccinated and CovidDeath two tables
SELECT *
FROM CovidDeath dea
JOIN CovidVaccinated vac
	ON dea.location=vac.location
	and dea.date=vac.date;

--Find the daily total vaccination 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as total_vaccinations
FROM CovidDeath dea
JOIN CovidVaccinated vac
	ON dea.location=vac.location
	and dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 2,3;

--Find the daily total vaccination &vaccinations rate
WITH vaccinations_rate_couclate (continent,location,date, population, new_vaccinations,total_vaccinations)
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as total_vaccinations
FROM CovidDeath dea
JOIN CovidVaccinated vac
	ON dea.location=vac.location
	and dea.date=vac.date
WHERE dea.continent is not null)
SELECT *, (total_vaccinations/population)*100
FROM vaccinations_rate_couclate;


