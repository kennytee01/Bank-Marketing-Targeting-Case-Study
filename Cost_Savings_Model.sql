-- The two targeting approach to Cost savings model analysis
select job, prior_contact_flag, count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by job, prior_contact_flag
having count(*) >= 50
order by conversion_rate desc
limit 15;


select job, prior_contact_flag, housing, loan, campaign_bucket,
       count(*) as contacts,
       round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
from bank_marketing
group by job, prior_contact_flag, housing, loan, campaign_bucket
having count(*) >= 30
order by conversion_rate desc
limit 20;

-- WHY I COMPARED TWO TARGETING APPROACHES

-- I checked two versions of a customer targeting list before deciding which
-- one to use: a simple list based on job type and prior contact history
-- (Query A), and a more detailed list that also factored in loan status and
-- how many times a customer was contacted this campaign (Query B).

-- I did this because I did not just want the highest possible conversion
-- number, I wanted a number I could trust and act on. A more detailed
-- targeting rule can look better on paper, but if it is based on a very
-- small group of customers, that number can be misleading. A rate built from
-- 70 customers can swing significantly with just a few different outcomes,
-- while a rate built from several hundred customers is far more stable and
-- repeatable.

-- Query B did produce a slightly higher conversion rate at the very top
-- (90.1%), but most of its strongest rows were based on customer groups as
-- small as 30 to 70 people. Query A's top segments were built on group sizes
-- from roughly 245 up to over 700 customers, while still delivering strong
-- conversion rates (84.1% down to 60%+).

-- I picked Query A as my primary targeting list because I cannot confidently
-- build a calling strategy, or defend a cost-savings estimate to
-- stakeholders, on customer segments that small. Query A gives a result that
-- is both strong and reliable enough to act on, which matters more to me
-- than a marginally higher number I cannot fully trust. I am keeping Query B
-- as a secondary, more refined targeting option worth testing in a smaller
-- pilot campaign, rather than using it as the basis for a full rollout
-- decision.


-- ============================================
-- COST-SAVINGS MODEL
-- Comparing blanket calling vs. targeted calling
-- Assumptions: $5 cost per call, 11% realistic baseline
-- conversion rate (real-world telemarketing average,
-- not this dataset's artificially balanced 47.4%)
-- ============================================

with target_segments as (
    -- the 10 qualifying segments from Query A (rate >= 60%, contacts >= 50)
    select job, prior_contact_flag
    from (
        select job, prior_contact_flag, count(*) as contacts,
               round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
        from bank_marketing
        group by job, prior_contact_flag
        having count(*) >= 50
    ) q
    where conversion_rate >= 60
),

tagged as (
    -- tag every customer contact as Targeted or Not Targeted
    select b.deposit,
           case when ts.job is not null then 'Targeted' else 'Not Targeted' end as target_group
    from bank_marketing b
    left join target_segments ts
      on b.job = ts.job and b.prior_contact_flag = ts.prior_contact_flag
),

overall as (
    -- this dataset's own overall sample conversion rate (47.4%), used as the
    -- denominator for the lift calculation
    select round(sum(case when deposit='yes' then 1 else 0 end)*100.0/count(*), 1) as overall_sample_rate
    from bank_marketing
),

summary as (
    select target_group,
           count(*) as contacts,
           round(sum(case when deposit='yes' then 1 else 0 end)*100.0/count(*), 1) as sample_conversion_rate
    from tagged
    group by target_group
)

select
    s.target_group,
    s.contacts,
    s.sample_conversion_rate as dataset_sample_rate,
    round(s.sample_conversion_rate / o.overall_sample_rate * 11, 1) as realistic_conversion_rate,
    round(s.contacts * (s.sample_conversion_rate / o.overall_sample_rate * 11) / 100.0) as est_realistic_conversions,
    s.contacts * 5 as cost_at_5_per_call,
    round((s.contacts * 5) / (s.contacts * (s.sample_conversion_rate / o.overall_sample_rate * 11) / 100.0), 2) as cost_per_conversion
from summary s, overall o
order by s.target_group;


-- ============================================
-- COST-SAVINGS FROM CAPPING CONTACT ATTEMPTS
-- (Not Targeted group only — no segment excluded,
-- just reducing wasted repeat calls)
-- Assumption: cap at 3 contact attempts per customer,
-- $5 cost per call
-- ============================================

with target_segments as (
    select job, prior_contact_flag
    from (
        select job, prior_contact_flag, count(*) as contacts,
               round(sum(case when deposit = 'yes' then 1 else 0 end)*100.0/count(*), 1) as conversion_rate
        from bank_marketing
        group by job, prior_contact_flag
        having count(*) >= 50
    ) q
    where conversion_rate >= 60
),

not_targeted as (
    select b.*
    from bank_marketing b
    left join target_segments ts
      on b.job = ts.job and b.prior_contact_flag = ts.prior_contact_flag
    where ts.job is null
)

select
    count(*) as customers_in_group,
    sum(campaign) as actual_total_calls_made,
    sum(case when campaign > 3 then 3 else campaign end) as calls_if_capped_at_3,
    sum(case when campaign > 3 then campaign - 3 else 0 end) as excess_calls_saved,
    sum(case when campaign > 3 then campaign - 3 else 0 end) * 5 as dollars_saved,
    sum(case when campaign > 3 and deposit = 'yes' then 1 else 0 end) as converted_customers_called_more_than_3_times
from not_targeted;