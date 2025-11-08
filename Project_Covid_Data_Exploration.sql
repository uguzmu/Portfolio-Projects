-- Query 1: Shows COVID data by location and date, calculating the death percentage from total cases and deaths.
SELECT location, datee, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM covid_deaths
-- WHERE location = 'Honduras'
ORDER BY 1,2;


-- Query 2: Shows COVID cases by location and date, calculating the percentage of the population infected.
SELECT location, population, datee, total_cases, (total_cases/population)*100 as infected_percentage
FROM covid_deaths
-- WHERE location = 'Honduras'
ORDER BY 1,2;


-- Query 3: Shows the maximum total cases and infection percentage by location and date, ordered from highest to lowest infection rate.
SELECT location, population, datee, MAX(total_cases), MAX((total_cases/population)*100) as infected_percentage
FROM covid_deaths
GROUP BY location, population, datee
ORDER BY infected_percentage DESC;


-- Query 4: Shows total deaths by location, ordered from highest to lowest.
SELECT location, MAX(total_deaths) as Total_Deaths
FROM covid_deaths
WHERE continent is not NULL
-- WHERE location = 'Honduras'
GROUP BY location
ORDER BY MAX(total_deaths) DESC;


-- Query 5: Shows global totals of cases and deaths, calculating the overall death percentage.
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
FROM covid_deaths
WHERE continent is not NULL
order by 1,2
;


-- QUERYS BELOW SHOWS RESULTS BY CONTINENTS

-- Query 6: Shows COVID data for continents or global regions, calculating the death percentage by date.
SELECT location, datee, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM covid_deaths
-- WHERE location = 'Honduras'
WHERE continent is null
ORDER BY 1,2;


-- Query 7: Shows infection percentages for continents or by date.
SELECT location, population, datee, total_cases, (total_cases/population)*100 as infected_percentage
FROM covid_deaths
WHERE continent is null
ORDER BY 1,2;


-- Query 8: Shows total deaths by continent, ordered from highest to lowest.
SELECT location, MAX(total_deaths) as Total_Deaths
FROM covid_deaths
WHERE continent is NULL and location not in ('World', 'European Union', 'International')
-- WHERE location = 'Honduras'
GROUP BY location
ORDER BY MAX(total_deaths) DESC;


-- Query 9: Combines COVID cases and vaccination data to calculate the cumulative vaccinated population and its percentage by location and date.
WITH P_vs_V (continent, location, datee, population, new_vaccinations, rolling_people_vaccinated)
as
(
SELECT d.continent, d.location, d.datee, d.population, v.new_vaccinations, SUM(v.new_vaccinations)
OVER(PARTITION BY d.location ORDER BY d.location, d.datee) as rolling_people_vaccinated
-- (rolling_people_vaccinated/population)*100
FROM covid_deaths d
JOIN covid_vaccination v
	ON d.location = v.location AND d.datee = v.datee
    WHERE d.continent is not NULL
-- ordery by 2,3
)
SELECT *, (rolling_people_vaccinated/population)*100
FROM P_vs_V