-- reason for cancellation per driver assignment
with cte as (
select 
case
	when order_status_key = 4 then 'client'
	else 'system'
end as 'cancellation reason',
case
	when is_driver_assigned_key = 1 then 'driver assigned'
	else 'no driver assigned'
end as 'driver assignment'
from data_orders
)
select *,
count(*) as cancellations
from cte
group by
[cancellation reason],
[driver assignment]

-- cancellations per hour
select 
datepart(hour, order_datetime) as 'hour',
count(order_gk) as cancellations
from data_orders
group by datepart(hour, order_datetime)
order by hour 

-- average time to cancellation in seconds per driver assignment & hour
;with cte as (
select 
case
	when is_driver_assigned_key = 1 then 'driver assigned'
	else 'no driver'
end as 'driver assignment',
datepart(hour, order_datetime) as 'hour',
cancellations_time_in_seconds
from data_orders
)
select 
[driver assignment],
hour,
round(avg(cancellations_time_in_seconds), 0) 'average cancellation time in seconds'
from cte
group by 
[driver assignment],
hour

-- average eta by hour
select 
datepart(hour, order_datetime) as 'hour',
round(avg(m_order_eta), 0) as 'average eta'
from data_orders
group by datepart(hour, order_datetime)
