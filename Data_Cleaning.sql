select * from bank_marketing;

-- Data Standardization
select count(*) job from bank_marketing
where job = 'admin.';
-- i have 1334 datas affected

update bank_marketing
set job = 'administration'
where job = 'admin.';

select count(*) job from bank_marketing
where job = 'administration';

select distinct job from bank_marketing order by job;
-- all admin. are replaced with administration for consistency

select distinct job,marital, education,contact,month,poutcome,deposit
from bank_marketing 
order by job,marital, education,contact,month,poutcome,deposit;

-- month column standardization
update bank_marketing
set month = case month
    when 'jan' then 'january'
    when 'feb' then 'february'
    when 'mar' then 'march'
    when 'apr' then 'april'
    when 'may' then 'may'
    when 'jun' then 'june'
    when 'jul' then 'july'
    when 'aug' then 'august'
    when 'sep' then 'september'
    when 'oct' then 'october'
    when 'nov' then 'november'
    when 'dec' then 'december'
    else month
end;
select distinct month from bank_marketing order by month;

-- add prior contact flag, replacing pdays/previous/poutcome unknown pattern
alter table bank_marketing add column prior_contact_flag text;

update bank_marketing
set prior_contact_flag = case
    when pdays = -1 and previous = 0 and poutcome = 'unknown' then 'No Prior Contact'
    else 'Previously Contacted'
end;

-- verify the flag distribution
select prior_contact_flag, count(*),
       round(count(*)*100.0/sum(count(*)) over (), 1) as pct
from bank_marketing
group by prior_contact_flag;

-- add age band for segment analysis
alter table bank_marketing add column age_band text;

update bank_marketing
set age_band = case
    when age < 30 then '18-29'
    when age < 40 then '30-39'
    when age < 50 then '40-49'
    when age < 60 then '50-59'
    else '60+'
end;

-- add campaign contact bucket
alter table bank_marketing add column campaign_bucket text;

update bank_marketing
set campaign_bucket = case
    when campaign = 1 then '1 contact'
    when campaign between 2 and 3 then '2-3 contacts'
    when campaign between 4 and 6 then '4-6 contacts'
    else '7+ contacts'
end;