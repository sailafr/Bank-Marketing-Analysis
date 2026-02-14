-- 1
SELECT * FROM v_campaign_effectiveness;

SELECT * FROM v_campaign_by_age;
SELECT * FROM v_campaign_byjob;
SELECT * FROM v_campaign_byeducation;
SELECT * FROM v_campaign_byloan;

-- 2
CREATE OR REPLACE VIEW v_client_profile_performance AS
SELECT
    'age' AS segment_type,
    CAST(age AS CHAR) AS segment_value,
    total_calls,
    success_calls,
    percent_of_succes,
    avg_campaign
FROM v_campaign_by_age
UNION ALL
SELECT
    'job',
    job,
    total_calls,
    success_calls,
    percent_of_succes,
    avg_campaign
FROM v_campaign_byjob
UNION ALL
SELECT
    'education',
    education,
    total_calls,
    success_calls,
    percent_of_succes,
    avg_campaign
FROM v_campaign_byeducation
UNION ALL
SELECT
    'loan',
    loan,
    total_calls,
    success_calls,
    percent_of_succes,
    avg_campaign
FROM v_campaign_byloan;
SELECT * FROM v_client_profile_performance;

SELECT * FROM v_previous_succes_effect;
SELECT * FROM v_previous_poutcome_effect;
SELECT * FROM v_previous_fail_effectiveness;

-- 3
CREATE OR REPLACE VIEW v_prior_contact_impact AS
SELECT * FROM v_previous_succes_effect
UNION ALL
SELECT * FROM v_previous_poutcome_effect
UNION ALL
SELECT * FROM v_previous_fail_effectiveness;
SELECT * FROM v_prior_contact_impact;


-- 4
SELECT * FROM v_pdays_previous_group_effect;

-- 5
SELECT * FROM v_euribor3m_effect;

-- 6
SELECT * FROM v_emprate_effect;

SELECT * FROM v_contact_effect;
SELECT * FROM v_dayofweek_effect;
SELECT * FROM v_month_effect;

-- 7
CREATE OR REPLACE VIEW v_channel_timing AS
SELECT
    'contact' AS timing_type,
    contact AS timing_value,
    total_calls,
    success_rate
FROM v_contact_effect
UNION ALL
SELECT
    'weekday',
    day_of_week,
    total_calls,
    success_rate
FROM v_dayofweek_effect
UNION ALL
SELECT
    'month',
    month,
    total_calls,
    success_rate
FROM v_month_effect;
SELECT * FROM v_channel_timing;

-- 8
SELECT * FROM v_callduration_effect;

