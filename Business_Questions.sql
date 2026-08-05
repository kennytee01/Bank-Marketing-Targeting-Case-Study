-- Q1: overall baseline conversion rate (dataset level)
select deposit, count(*), round(count(*)*100.0/sum(count(*)) over (), 1) as pct
from bank_marketing
group by deposit;

-- Q2: which job types convert best?
select job, count(*) as contacts,
       sum(case when deposit = 'yes' then 1 else 0 end) as conversions,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by job
order by conversion_rate desc;

-- Q3: does education level affect conversion?
select education, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by education
order by conversion_rate desc;

-- Q4: marital status effect
select marital, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by marital
order by conversion_rate desc;

-- Q5: does having a housing loan reduce conversion?
select housing, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by housing
order by conversion_rate desc;

-- Q6: does having a personal loan reduce conversion?
select loan, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by loan
order by conversion_rate desc;

-- Q7: which contact method works best?
select contact, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by contact
order by conversion_rate desc;

-- Q8: which months convert best? (seasonality)
select month, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by month
order by conversion_rate desc;

-- Q9: does prior campaign contact predict conversion?
select prior_contact_flag, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by prior_contact_flag
order by conversion_rate desc;

-- Q10: does calling more during this campaign help or hurt?
select campaign_bucket, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by campaign_bucket
order by conversion_rate desc;

-- Q11: which age bands convert best?
select age_band, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by age_band
order by conversion_rate desc;

-- Q12: ranked target list - segments above overall baseline (job + prior contact combined)
select job, prior_contact_flag, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by job, prior_contact_flag
having count(*) >= 50
order by conversion_rate desc
limit 15;