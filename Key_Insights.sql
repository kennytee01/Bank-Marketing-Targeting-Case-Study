-- ============================================
-- KEY INSIGHTS — BANK MARKETING CASE STUDY
-- (Business Analytics Case Study, Week 5)
-- ============================================

-- Insight 1: Baseline conversion rate is artificially balanced in this dataset
-- (47.4% yes vs real-world telemarketing baseline of ~11%). All targeting and
-- cost-savings conclusions must be reweighted against the ~11% baseline, not
-- this dataset's balanced sample, or the business case will overstate impact.

-- Insight 2: Occupation-based conversion is inverted from typical assumption.
-- Student (74.7%) and retired (66.3%) segments convert far above average,
-- while blue-collar (36.4%) converts lowest despite being the second-largest
-- segment by volume (1,944 contacts).

-- Insight 3: Education level shows a consistent gradient — conversion rises
-- from primary (39.4%) to secondary (44.7%) to tertiary (54.1%). "Unknown"
-- education (50.7%) converts above secondary and should not be excluded as
-- bad data.

-- Insight 4: Marital status shows the same volume-vs-conversion inversion as
-- job type. Married customers are the largest segment (6,351 contacts) but
-- convert lowest (43.4%), while single customers convert highest (54.3%).

-- Insight 5: Existing debt obligations strongly suppress conversion. Housing
-- loan holders convert at 36.6% vs 57.0% for non-holders (20pt gap). Personal
-- loan holders convert at 33.2% vs 49.5% (16pt gap). Reinforces the theme that
-- competing financial obligations are the strongest behavioral driver against
-- subscribing to a term deposit.

-- Insight 6: Contact channel matters. Cellular (54.3%) and telephone (50.4%)
-- convert similarly well; "unknown" channel converts at less than half the
-- rate (22.6%) — likely a data logging gap rather than a true behavioral
-- signal, and worth flagging as a process improvement, not just an insight.

-- Insight 7: Prior campaign contact is the single strongest predictor found.
-- Previously contacted customers convert at 67.1% vs 40.7% for those never
-- previously contacted — a 26-point gap, larger than any single demographic
-- variable alone.

-- Insight 8: More calls within the same campaign produce diminishing, then
-- negative, returns. Conversion drops steadily from 53.4% (1 contact) to
-- 26.8% (7+ contacts). Over-calling actively damages conversion odds rather
-- than improving them — supports a recommended contact cap.

-- Insight 9: Age shows a U-shaped relationship with conversion. 60+ converts
-- highest (76.9%), 18-29 second highest (59.8%), while the working-age middle
-- (30-49) converts lowest (40-44%). Mirrors the job/marital pattern: segments
-- with fewer competing financial obligations convert best.

-- Insight 10: Prior contact is a multiplier on top of job type, not an
-- independent effect. The top combined segments are retired + previously
-- contacted (84.1%), unemployed + previously contacted (83.7%), and student +
-- previously contacted (83.2%) — all well above any single-variable result.
-- This combination should anchor the final targeting list.

-- ============================================
-- MAIN POINT:
-- Conversion is driven primarily by
-- (a) absence of competing debt/financial obligations
-- (b) whether the customer has prior campaign familiarity.
-- The campaign's highest-volume segments (blue-collar, married, working-age,
-- no prior contact) are consistently its lowest-converting,
-- this is the core inefficiency the cost-savings model must quantify.
-- ============================================