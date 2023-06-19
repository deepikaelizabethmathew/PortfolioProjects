--Select * 
--from CovidVaccinations$
--order by 3,4

Select * 
from CovidDeaths$
order by 3,4

Select Location,Date,total_cases,new_cases,total_deaths,population
from CovidDeaths$
order by 1,2


Select Location,Date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRate
from CovidDeaths$
where Location like '%India%'
order by 1,2


--total case vs population
--What % population affecte by covid
Select Location,Date,total_cases,population,(total_cases/population)*100 as Percentofpopulationaffected
from CovidDeaths$
--where Location like '%India%'
order by 1,2

--chech each country's infection rate
Select Location,MAX(total_cases) as Highest_infection_count,population,MAX((total_cases/population))*100 as Percentofpopulationainfected
from CovidDeaths$
--where Location like '%India%'
Group by Location, population
order by Percentofpopulationainfected desc



---Showing Counting with highest death count per population

Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths$
where continent is not null 
Group by Location
order by TotalDeathCount desc


--Lets break it down by continent
Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths$
where continent is not null 
Group by continent
order by TotalDeathCount desc


--Global numbers

Select Date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRate
from CovidDeaths$
--where Location like '%India%'
where continent is not null
order by 1,2

Select Date, sum(cast(new_cases as int))as Sumofnewcases, sum(cast(new_deaths as int))as Sumofnewdeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercent
from CovidDeaths$
--where Location like '%India%'
where continent is not null
group by date
order by 1,2

Select  sum(cast(new_cases as int))as Sumofnewcases, sum(cast(new_deaths as int))as Sumofnewdeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercent
from CovidDeaths$
--where Location like '%India%'
where continent is not null
--group by date
order by 1,2

--join table
select *
from CovidDeaths$ dea
Join CovidVaccinations$ vac
on dea.location= vac.location and dea.date= vac.date

--total polulation vs vaccination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over 
(partition by dea.location order by dea.location,dea.date) as Cummlativevaccinationcount
from CovidDeaths$ dea
Join CovidVaccinations$ vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null
order by 2,3

--Using CTE

with PopvsVac (continent,location,date,population,new_vaccinations,Cummlativevaccinationcount)
as (select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over 
(partition by dea.location order by dea.location,dea.date) as Cummlativevaccinationcount
from CovidDeaths$ dea
Join CovidVaccinations$ vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null
)
Select *,(Cummlativevaccinationcount/population)*100
from PopvsVac

create view Popvsvac as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over 
(partition by dea.location order by dea.location,dea.date) as Cummlativevaccinationcount
from CovidDeaths$ dea
Join CovidVaccinations$ vac
on dea.location= vac.location and dea.date= vac.date
where dea.continent is not null