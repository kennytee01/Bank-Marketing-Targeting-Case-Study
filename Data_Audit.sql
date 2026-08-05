create table bank_marketing (
    age int,
    job text,
    marital text,
    education text,
    default_credit text,
    balance int,
    housing text,
    loan text,
    contact text,
    day int,
    month text,
    duration int,
    campaign int,
    pdays int,
    previous int,
    poutcome text,
    deposit text
);

-- row count and structure check
select count(*) from bank_marketing;
-- i have 11162 rows of data

-- null check across key columns
select
    count(*) - count(age) as null_age,
    count(*) - count(job) as null_job,
    count(*) - count(balance) as null_balance,
    count(*) - count(deposit) as null_deposit
from bank_marketing;
-- no null/blank in the selected column

-- duplicate check
select count(*) as total_rows,
       count(distinct (age, job, marital, education, balance, day, month, duration, campaign)) as distinct_rows
from bank_marketing;
-- no duplcate

-- target balance check (confirms the 47% artificial balance)
select deposit, count(*), round(count(*)*100.0/sum(count(*)) over (), 1) as pct
from bank_marketing
group by deposit;

-- unknown value audit
select
    sum(case when job = 'unknown' then 1 else 0 end) as job_unknown,
    sum(case when education = 'unknown' then 1 else 0 end) as education_unknown,
    sum(case when contact = 'unknown' then 1 else 0 end) as contact_unknown,
    sum(case when poutcome = 'unknown' then 1 else 0 end) as poutcome_unknown
from bank_marketing;

-- prior contact pattern check (pdays / previous / poutcome alignment)
select count(*)
from bank_marketing
where pdays = -1 and previous = 0 and poutcome = 'unknown';

-- duration leakage check
select deposit, round(avg(duration),1) as avg_duration_seconds
from bank_marketing
group by deposit;

--Data Audit Summary
-- 11,162 rows, no nulls, no duplicates
-- Target artificially balanced at 47.4% (real-world baseline ~11%)
-- Unknowns accounted for and understood
-- Prior contact pattern confirmed (8,324 rows = "No Prior Contact")
-- Duration leakage confirmed and excluded from targeting logic
