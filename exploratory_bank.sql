-- EXPLORATORY BANK DATASET --

-- 1. Distribution and effectiveness of contact frequency (campaign)
-- 2. Campaign intensity across different client profiles
-- 3. Impact of previous successful campaigns on current subscription
-- 4. Re-contact effectiveness after previous failures
-- 5. Effect of prior contact history (previous, pdays) on subscription outcome
-- 6. Relationship between macroeconomic indicators and campaign success
-- 7. Channel and timing effectiveness (contact type, month, weekday)
-- 8. Client segments with the highest subscription rates
-- 9. Call duration vs outcome (with leakage consideration)

-- ANALYSIS:
-- 1. Distribution and effectiveness of contact frequency (campaign)
select *
from bank_stagging2;

select campaign, count(*)
from bank_stagging2
group by campaign
order by campaign asc;

select campaign, count(*) as sum_call
from bank_stagging2
group by campaign
order by sum_call desc;

select campaign, count(*) as sum_call
from bank_stagging2
where y = 'yes'
group by campaign
order by sum_call desc;

select campaign, count(*) as sum_call
from bank_stagging2
where y = 'no'
group by campaign
order by sum_call desc;

SELECT
    campaign,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls
FROM bank_stagging2
GROUP BY campaign
ORDER BY campaign;

CREATE VIEW v_campaign_effectiveness AS
SELECT
    campaign,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    SUM(CASE WHEN y = 'no' THEN 1 ELSE 0 END) AS failed_calls,
    round(
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) as percent_of_succes,
    round(
    SUM(CASE WHEN y = 'no' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) as percent_of_failed
FROM bank_stagging2
GROUP BY campaign
ORDER BY campaign;

-- 2. Campaign intensity across different client profiles
SELECT *
FROM bank_stagging2;

SELECT age, COUNT(*) as total_calls, 
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY age
ORDER BY total_calls desc;

CREATE VIEW v_campaign_by_age AS
SELECT
    age,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    round(
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) as percent_of_succes,
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY age
HAVING COUNT(*) >= 500
ORDER BY percent_of_succes desc;

SELECT job, COUNT(*) as total_calls, 
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY job
ORDER BY total_calls desc;

CREATE VIEW v_campaign_byjob AS
SELECT
    job,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    round(
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) as percent_of_succes,
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY job
ORDER BY percent_of_succes desc;

SELECT education, COUNT(*) as total_calls, 
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY education
ORDER BY total_calls desc;

CREATE VIEW v_campaign_byeducation AS
SELECT
    education,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    round(
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) as percent_of_succes,
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY education
HAVING COUNT(*) >= 500
ORDER BY percent_of_succes desc;

SELECT loan, COUNT(*) as total_calls, 
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY loan
ORDER BY total_calls desc;

CREATE VIEW v_campaign_byloan AS
SELECT
    loan,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    round(
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) as percent_of_succes,
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY loan
HAVING COUNT(*) >= 100
ORDER BY percent_of_succes desc;

SELECT
    job, education, marital, housing, loan,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    round(
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) as percent_of_succes,
	ROUND(AVG(campaign),2) as avg_campaign
FROM bank_stagging2
GROUP BY job, education, marital, housing, loan
HAVING COUNT(*) >= 100
ORDER BY percent_of_succes desc;

-- 3. Impact of previous successful campaigns on current subscription
SELECT *
FROM bank_stagging2;

CREATE OR REPLACE VIEW v_previous_succes_effect AS
SELECT
    'previous_contact' AS impact_type,
    CASE 
        WHEN previous = 0 THEN 'New Client'
        ELSE 'Previously Contacted'
    END AS impact_value,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM bank_stagging2
GROUP BY impact_value;

CREATE OR REPLACE VIEW v_previous_poutcome_effect AS
SELECT
    'previous_poutcome' AS impact_type,
    poutcome AS impact_value,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM bank_stagging2
WHERE previous > 0
GROUP BY poutcome;

SELECT
    previous,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    round(
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*), 2
    ) as percent_of_succes
FROM bank_stagging2
where previous between 1 and 5
group by previous
order by previous;

-- 4. Re-contact effectiveness after previous failures
select *
from bank_stagging2;

CREATE OR REPLACE VIEW v_previous_fail_effectiveness AS
SELECT
    'previous_failure' AS impact_type,
    CAST(previous AS CHAR) AS impact_value,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM bank_stagging2
WHERE poutcome = 'failure'
GROUP BY previous;

-- 5. Effect of prior contact history (previous, pdays) on subscription outcome

CREATE OR REPLACE VIEW v_pdays_group_effect AS
SELECT
    CASE 
        WHEN pdays = 999 THEN 'New Client'
        WHEN pdays BETWEEN 0 AND 7 THEN '0-7 days'
        WHEN pdays BETWEEN 8 AND 30 THEN '8-30days'
        WHEN pdays BETWEEN 31 AND 90 THEN '30-90 days'
        ELSE '>90'
    END AS 'pdays_group',
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM bank_stagging2
GROUP BY pdays_group
ORDER BY total_calls DESC;

CREATE OR REPLACE VIEW v_pdays_previous_group_effect AS
SELECT
    CASE
        WHEN previous = 0 THEN 'No previous contact'
        WHEN previous = 1 THEN '1 previous contact'
        ELSE '2+ previous contacts'
    END AS previous_group,
    CASE
        WHEN pdays = 999 THEN 'New client'
        WHEN pdays BETWEEN 0 AND 30 THEN 'Recently contacted'
        ELSE 'Contacted long ago'
    END AS pdays_group,
    COUNT(*) AS total_calls,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM bank_stagging2
GROUP BY previous_group, pdays_group
HAVING COUNT(*) >= 100;

-- 6. Relationship between macroeconomic indicators and campaign success
select *
from bank_stagging2;

CREATE OR REPLACE VIEW v_euribor3m_effect AS
SELECT
    CASE
        WHEN euribor3m < 1 THEN 'Low interest'
        WHEN euribor3m BETWEEN 1 AND 3 THEN 'Medium interest'
        ELSE 'High interest'
    END AS interest_level,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate
FROM bank_stagging2
GROUP BY interest_level
ORDER BY success_rate DESC;

CREATE OR REPLACE VIEW v_emprate_effect AS
SELECT
    y,
    COUNT(*) AS total_calls,
    ROUND(AVG(`emp.var.rate`), 2) AS avg_emp_var_rate,
    ROUND(AVG(`cons.price.idx`), 2) AS avg_cons_price,
    ROUND(AVG(`cons.conf.idx`), 2) AS avg_cons_conf,
    ROUND(AVG(euribor3m), 2) AS avg_euribor,
    ROUND(AVG(`nr.employed`), 0) AS avg_nr_employed
FROM bank_stagging2
GROUP BY y;

-- 7. Channel and timing effectiveness (contact type, month, weekday)
SELECT *
FROM bank_stagging2;

CREATE OR REPLACE VIEW v_contact_effect AS
select 
	contact,
    count(*) as total_calls,
    sum(case when y = 'yes' then 1 else 0 end) as success_calls,
    round(
    sum(case when y = 'yes' then 1 else 0 end)*100/count(*),2
    ) as success_rate
from bank_stagging2
group by contact;

CREATE OR REPLACE VIEW v_month_effect AS
select 
	`month`,
    count(*) as total_calls,
    sum(case when y = 'yes' then 1 else 0 end) as success_calls,
    round(
    sum(case when y = 'yes' then 1 else 0 end)*100/count(*),2
    ) as success_rate
from bank_stagging2
group by `month`
order by success_rate desc;

CREATE OR REPLACE VIEW v_dayofweek_effect AS
select 
	day_of_week,
    count(*) as total_calls,
    sum(case when y = 'yes' then 1 else 0 end) as success_calls,
    round(
    sum(case when y = 'yes' then 1 else 0 end)*100/count(*),2
    ) as success_rate
from bank_stagging2
group by day_of_week;

select 
	contact,
    day_of_week,
    count(*) as total_calls,
    sum(case when y = 'yes' then 1 else 0 end) as success_calls,
    round(
    sum(case when y = 'yes' then 1 else 0 end)*100/count(*),2
    ) as success_rate
from bank_stagging2
group by contact, day_of_week
having count(*)>100
order by success_rate desc;

-- 8. Call duration vs outcome (with leakage consideration)
SELECT *
FROM bank_stagging2;

CREATE OR REPLACE VIEW v_callduration_effect AS
SELECT
    CASE 
        WHEN duration = 0 THEN '0 sec'
        WHEN duration <= 60 THEN '1 min'
        WHEN duration <= 120 THEN '2 min'
        WHEN duration <= 180 THEN '3 min'
        WHEN duration <= 240 THEN '4 min'
        WHEN duration <= 300 THEN '5 min'
        WHEN duration <= 360 THEN '6 min'
        WHEN duration <= 420 THEN '7 min'
        WHEN duration <= 480 THEN '8 min'
        WHEN duration <= 540 THEN '9 min'
        WHEN duration <= 600 THEN '10 min'
        ELSE '> 10 min'
    END AS 'duration_group',
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM bank_stagging2
GROUP BY duration_group;

CREATE OR REPLACE VIEW v_callduration_all AS
SELECT
	duration AS 'duration_group',
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS success_calls,
    ROUND(
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM bank_stagging2
GROUP BY duration_group
ORDER BY duration;
