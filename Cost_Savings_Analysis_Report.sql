-- ============================================
-- COST-SAVINGS ANALYSIS REPORT
-- Bank Marketing Business Analytics Case Study
-- Week 5, AnalystLab Africa Internship
-- Author: Timothy Kehinde Promise
-- ============================================

-- BUSINESS QUESTION
-- Telemarketing is expensive per contact, and most campaigns convert only a
-- small fraction of the people they call. I wanted to know which customer
-- segments and campaign conditions produce the highest conversion
-- probability, so the bank can prioritize its call list and reduce spend on
-- low-probability segments, instead of calling every customer the same way.

-- ASSUMPTIONS USED
-- 1. Cost per call: $5, a standard mid-range estimate for telemarketing /
--    call center cost per contact attempt.
-- 2. Realistic baseline conversion rate: 11%, the real-world average for
--    bank telemarketing campaigns. This dataset's own conversion rate
--    (47.4%) is artificially balanced for modeling purposes and does not
--    reflect a real campaign, so all cost projections were reweighted
--    against the realistic 11% baseline instead.


-- ============================================
-- MODEL 1: TARGETED VS NOT TARGETED COST EFFICIENCY
-- ============================================

-- WHAT I DID
-- I built a targeting list from Query A (job type combined with prior
-- contact history), keeping only segments with a conversion rate of 60% or
-- higher and at least 50 contacts, to keep the list statistically reliable.
-- I then split all customers into "Targeted" and "Not Targeted" groups and
-- compared cost per conversion between the two, using the realistic 11%
-- baseline.

-- RESULT
-- Targeted group: 2,612 contacts, 16.2% realistic conversion rate,
-- approximately 424 conversions, $13,060 total cost, $30.78 cost per
-- conversion.
-- Not Targeted group: 8,550 contacts, 9.4% realistic conversion rate,
-- approximately 804 conversions, $42,750 total cost, $53.20 cost per
-- conversion.

-- BUSINESS READ
-- Targeted calling is roughly 42% more cost-efficient per conversion than
-- untargeted calling ($30.78 vs $53.20). Every $1,000 spent on the Targeted
-- segments yields around 32 conversions, compared to roughly 19 conversions
-- for the same $1,000 spent without targeting.

-- WHY I DID NOT RECOMMEND DROPPING THE NOT TARGETED GROUP
-- Even though this group is less efficient, it still produces 804 of the
-- total 1,228 estimated conversions, nearly two-thirds of total volume.
-- Recommending the bank stop calling this group entirely would mean giving
-- up most of the pipeline, not improving it. A more responsible
-- recommendation is to reduce waste within this group rather than eliminate
-- it, which is what Model 2 addresses.


-- ============================================
-- MODEL 2: CAPPED CONTACT ATTEMPTS (THE ACTUAL RECOMMENDATION)
-- ============================================

-- WHAT I DID
-- Using the Not Targeted group only, I calculated what would happen if
-- contact attempts per customer were capped at 3 calls instead of allowed to
-- run up to 7 or more, based on the conversion decay pattern already found
-- in the campaign_bucket analysis (conversion drops from 53.4% at 1 contact
-- down to 26.8% at 7+ contacts).

-- RESULT
-- 8,550 customers in this group received 22,994 total calls. Capping at 3
-- calls per customer would reduce that to 16,439 calls, avoiding 6,555
-- excess low-yield calls and saving approximately $32,775.

-- THE TRADEOFF (STATED HONESTLY, NOT HIDDEN)
-- 562 customers in this group only converted after their 3rd call, roughly
-- 16% of this segment's total conversions. Capping at 3 calls does not
-- guarantee these conversions are lost, since some of these customers might
-- have converted on an earlier call under a different calling pattern, but
-- it is a real risk that should not be ignored. The decline in conversion
-- rate as call count rises may also partly reflect reverse causality,
-- meaning harder-to-reach or more resistant customers naturally receive more
-- calls and still do not convert, rather than the repeated calls themselves
-- causing refusal. This is a correlation-based recommendation, not a proven
-- causal one.

-- FINAL RECOMMENDATION
-- 1. Prioritize the Targeted segments (job type plus prior contact history)
--    earlier in the calling cycle, since they convert at nearly double the
--    cost efficiency of the general customer base.
-- 2. Apply a 3-call cap specifically to the Not Targeted group, saving an
--    estimated $32,775 in reduced repeat-call costs.
-- 3. Pilot the 3-call cap on a subset of the campaign before full rollout,
--    to measure actual conversion impact rather than assuming the full
--    savings figure is realized with no offsetting loss in conversions.

-- ============================================