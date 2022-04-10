
--the global number of covid infections & deaths & mortality rate
Select SUM(new_cases) as Total_Infections, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Mortality_Rate
From CovidDeath
where continent is not null 
order by 1,2;

--Find total deaths by five continents
Select location as Continent, SUM(cast(new_deaths as int)) as Total_Deaths
From CovidDeath
Where location  in ('europe', 'north america', 'asia','south america','africa')
Group by location
order by Total_Deaths desc;

--Find the latest infection rate by country
Select Location, max (date),Population, SUM(cast(new_deaths as int)) as Total_Deaths,  Max((total_cases/population))*100 as Infection_Rate
From CovidDeath
--Where location like '%states%'
Group by Location, Population
order by Infection_Rate desc;


--Find daily infection rate by country
Select Location, Population,date, MAX(total_cases) as Total_Infection,  Max((total_cases/population))*100 as Daily_Infection_Rate
From CovidDeath
where continent is not null 
Group by Location, Population, date
order by Daily_Infection_Rate desc