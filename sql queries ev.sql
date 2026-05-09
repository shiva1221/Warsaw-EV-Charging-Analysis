-- 1. List all districts along with their income tiers.
Select distinct(district_name), income_tier from districts;
-- 2. Count the total number of charging stations in each district.
select district_name, count(station_id) as charging_stations from charging_stations group by district_name;
-- 3. Find the total number of charging plugs available per district.
select district_name, sum(plugs_count) as charging_plugs from charging_stations group by district_name;
-- 4. Calculate the total number of charging sessions recorded.
select count(session_id) as total_charging_session from charging_sessions;
-- 5. Find the average energy charged (kWh) per charging session.
select avg(kwh_charged) as avg_energy_charged from charging_sessions;

-- 6. Calculate total energy charged (kWh) by each district.
select charging_stations.district_name, round(sum(charging_sessions.kwh_charged),2) as total_energy_charged
from charging_stations join charging_sessions on charging_stations.station_id = charging_sessions.station_id group by district_name;
-- 7. Identify the top 5 charging stations based on number of charging sessions.
select station_id, count(session_id) as charging_session from charging_sessions group by station_id order by charging_session limit 5;
-- 8. Calculate total charging revenue generated per district.
select charging_stations.district_name, round(sum(charging_sessions.total_cost),2) as total_charging_revenue 
from charging_stations join charging_sessions on charging_stations.station_id = charging_sessions.station_id group by charging_stations.district_name;
-- 9. Find the average charging cost per session for each income tier.
select charging_stations.income_tier, round(avg(charging_sessions.total_cost),2) as avg_charging_cost 
from charging_stations join charging_sessions on charging_stations.station_id = charging_sessions.station_id group by charging_stations.income_tier;
-- 10. Analyze average energy charged per customer
select round(avg(kwh_charged),2) as avg_energy_charged from charging_sessions ;

-- 11. Compare projected EV count with total available charging plugs for each district.

-- 12. Identify districts where projected EVs exceed available charging plugs.

-- 13. Analyze charging demand per projected EV by district (total kWh / projected EVs).
select districts.district_name, districts.projected_evs, round(sum(charging_sessions.kwh_charged),2) as total_kwh_charged, 
round(sum(charging_sessions.kwh_charged) / districts.projected_evs,2) as demand_per_projected_ev
from districts join charging_stations on districts.district_name = charging_stations.district_name
join charging_sessions on charging_stations.station_id = charging_sessions.station_id 
group by districts.district_name, districts.projected_evs;
-- 14. Rank districts based on infrastructure readiness using actual charging usage vs projections.
select districts.district_name, districts.projected_evs, round(sum(charging_sessions.kwh_charged),2) as total_kwh_charged, 
round(sum(charging_sessions.kwh_charged) / districts.projected_evs,2) as demand_per_projected_ev,
rank() over(order by sum(charging_sessions.kwh_charged) / districts.projected_evs desc)
from districts join charging_stations on districts.district_name = charging_stations.district_name
join charging_sessions on charging_stations.station_id = charging_sessions.station_id 
group by districts.district_name, districts.projected_evs;