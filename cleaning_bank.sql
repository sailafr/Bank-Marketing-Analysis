-- CLEANING BANK DATASET --

select *
from bank;

-- 1. Remove Duplicate
-- 2. Standarizing Dataset
-- 3. Null Values or Blank Values
-- 4. Remove any Coloumn

-- Remove Duplicate
create table bank_stagging
like bank;

insert into bank_stagging
select *
from bank;

select *,
row_number() over(
partition by age, job, marital, education, `default` ,housing, loan, contact, `month`, day_of_week, duration,
campaign, pdays, previous, poutcome, `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`, euribor3m, `nr.employed`, y) as row_num
from bank_stagging;

with duplicates_cte as
(
select *,
row_number() over(
partition by age, job, marital, education, `default` ,housing, loan, contact, `month`, day_of_week, duration,
campaign, pdays, previous, poutcome, `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`, euribor3m, `nr.employed`, y) as row_num
from bank_stagging
)
select *
from duplicates_cte
where row_num > 1;

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT
    CONCAT_WS('|',
      age, job, marital, education, `default` ,housing, loan, contact, `month`, day_of_week, duration,
      campaign, pdays, previous, poutcome, `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`, euribor3m, `nr.employed`, y
    )
  ) AS distinct_rows
FROM bank_stagging;

select *
from bank_stagging;

CREATE TABLE `bank_stagging2` (
  `age` int DEFAULT NULL,
  `job` text,
  `marital` text,
  `education` text,
  `default` text,
  `housing` text,
  `loan` text,
  `contact` text,
  `month` text,
  `day_of_week` text,
  `duration` int DEFAULT NULL,
  `campaign` int DEFAULT NULL,
  `pdays` int DEFAULT NULL,
  `previous` int DEFAULT NULL,
  `poutcome` text,
  `emp.var.rate` double DEFAULT NULL,
  `cons.price.idx` double DEFAULT NULL,
  `cons.conf.idx` double DEFAULT NULL,
  `euribor3m` double DEFAULT NULL,
  `nr.employed` int DEFAULT NULL,
  `y` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from bank_stagging2;

insert into bank_stagging2
select *,
row_number() over(
partition by age, job, marital, education, `default` ,housing, 
loan, contact, `month`, day_of_week, duration, campaign, pdays, 
previous, poutcome, `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`, 
euribor3m, `nr.employed`, y) as row_num
from bank_stagging;

select *
from bank_stagging2
where row_num>1;

set sql_safe_updates = 0;
delete
from bank_stagging2
where row_num>1;

-- Standardizing Dataset
select * 
from bank_stagging2
order by age asc;
#standardizing is not requared bcs the data is already consist

-- Null Values or Blank Values
select *
from bank_stagging2
where age is null or job is null or marital is null or education is null or 
`default` is null or housing is null or loan is null or 
contact is null or `month` is null or day_of_week is null or 
duration is null or campaign is null or pdays is null or previous is null or 
poutcome is null or `emp.var.rate` is null or `cons.price.idx` is null or 
`cons.conf.idx` is null or euribor3m is null or `nr.employed` is null or y is null;
 
 select min(age), max(age), min(duration), max(duration), min(pdays), max(pdays)
 from bank_stagging2;
 
alter table bank_stagging2
drop row_num;