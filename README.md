# Bank Marketing Business Analytics Case Study

Targeted marketing strategy analysis for a bank telemarketing campaign, built in PostgreSQL. This project answers one specific question: which customers should the bank call first, and how much money is being wasted by not doing that already.

## Business Problem

A bank runs outbound telemarketing campaigns to sell term deposits. Every call costs money, and most calls do not convert. Calling every customer with the same level of effort wastes budget on people who were unlikely to say yes in the first place.

The question I set out to answer: which customer segments and campaign conditions produce the highest conversion probability, and how much could the bank save by prioritizing those segments instead of calling everyone equally?

## Dataset

Bank Marketing dataset (UCI / Kaggle), 11,162 customer contact records across 17 fields covering demographics, financial standing, and campaign history. Zero missing values, zero duplicate rows.

Two things about this dataset shaped every decision in this project:

- The subscription rate here is 47.4 percent, which is not realistic. Real bank telemarketing campaigns convert around 11 percent. This version of the dataset has been resampled for modeling convenience, so every dollar figure in this project is reweighted against the realistic 11 percent baseline instead of the dataset's own inflated rate.
- The call duration field only exists after a call has already happened, so it cannot inform who to call beforehand. I excluded it from all targeting logic and treated it only as a side observation on call quality.

## Tools

PostgreSQL (pgAdmin) for all data auditing, cleaning, and analysis. Power BI was not used for this project since the deliverable is a written business case, not a dashboard.

## Repository Structure

| File | Purpose |
|---|---|
| `bank_converted.csv` | Cleaned dataset export |
| `Data_Audit.sql` | Table creation, row/null/duplicate checks, target balance check, unknown value audit |
| `Data_Cleaning.sql` | Job and month label standardization, prior contact flag, age band, campaign contact bucket |
| `Business_Questions.sql` | 12 queries answering specific business questions on conversion drivers |
| `Key_Insights.sql` | Documented findings from the business questions, written as one consolidated insight log |
| `Cost_Savings_Model.sql` | Comparison of two targeting approaches, plus the cost-per-conversion and capped-contact savings calculations |
| `Cost_Savings_Analysis_Report.sql` | Full write-up of the cost-savings methodology, results, and final recommendation, documented inline |
| `Bank_Marketing_Case_Study_Report.pdf` | Full written report |
| `Bank_Marketing_Case_Study.pdf` | Presentation deck |

## Process

**Audit.** Checked row count, nulls, duplicates, target balance, and unknown/placeholder values before touching anything else.

**Clean.** Standardized job titles (`admin.` to `administration`) and month abbreviations to full names. Built a `prior_contact_flag` field to correctly represent the 74.6 percent of customers who had never been contacted in a previous campaign, replacing three overlapping unknown fields (`pdays = -1`, `previous = 0`, `poutcome = 'unknown'`) with one accurate category instead of treating them as missing data.

**Query.** Wrote 12 SQL queries covering conversion rate by job, education, marital status, housing loan, personal loan, contact method, month, prior contact history, campaign contact count, and age band, plus a combined job and prior-contact ranking used to build the final targeting list.

**Model.** Tested two targeting approaches before picking one. A simple two-variable list (job type plus prior contact) against a five-variable list (adding loan status and contact count). The five-variable list produced a slightly higher top conversion rate, but on customer groups as small as 30 to 70 people, too small to build a confident recommendation on. I went with the two-variable list because a bank cannot defend a cost-savings estimate built on a sample that unstable.

## Key Findings

| Variable | Finding |
|---|---|
| Job type | Student (74.7%) and retired (66.3%) convert highest. Blue-collar (36.4%) converts lowest despite being the second-largest segment. |
| Education | Conversion rises steadily from primary (39.4%) to secondary (44.7%) to tertiary (54.1%). |
| Marital status | Married customers are the largest segment (6,351 contacts) but convert lowest (43.4%). Single customers convert highest (54.3%). |
| Housing loan | Non-holders convert at 57.0% versus 36.6% for holders. |
| Personal loan | Non-holders convert at 49.5% versus 33.2% for holders. |
| Contact method | Cellular (54.3%) and telephone (50.4%) convert well. Unknown method converts at only 22.6%, likely a data logging gap rather than a real behavioral signal. |
| Prior contact | Previously contacted customers convert at 67.1% versus 40.7% for those never contacted before. The strongest single predictor found. |
| Campaign contact count | Conversion falls from 53.4% at one contact to 26.8% at seven or more. |
| Age | 60+ converts highest (76.9%). The working-age middle (30-49) converts lowest (40-44%). |

The pattern across every variable is consistent. Customers with fewer competing financial obligations, and prior familiarity with the campaign, convert at meaningfully higher rates than the segments the campaign currently calls the most.

## Cost Savings Model

Two calculations, built on a $5 cost-per-call assumption and the realistic 11 percent baseline conversion rate:

**Targeted vs. not targeted.** Customers in the qualifying job and prior-contact segments convert at an estimated $30.78 per conversion, versus $53.20 per conversion for everyone else. Targeted calling is roughly 42 percent more cost-efficient. I did not recommend dropping the lower-converting group entirely, since it still accounts for nearly two-thirds of total estimated conversions.

**Capped contact attempts.** Applying a 3-call cap to the lower-converting segment, instead of letting contact attempts run to 7 or more, is estimated to save approximately $32,775 by avoiding 6,555 low-yield repeat calls. About 16 percent of that segment's conversions happened on a fourth call or later, so I recommended piloting the cap before a full rollout rather than assuming the full savings figure with no offsetting loss.

## Recommendations

1. Call the targeted segments (job type combined with prior contact history) earlier in the campaign cycle.
2. Cap contact attempts at 3 calls for the lower-converting segment, piloted before full rollout.
3. Reassess how the offer is positioned for customers carrying housing or personal loans, since they convert at roughly half the rate of customers without existing loan obligations.
4. Audit the contact-logging process behind the unknown contact method category before using it in future targeting decisions.
5. Validate every finding here against the bank's own unweighted campaign data before committing budget, since the source dataset is artificially balanced.

## Notes on Assumptions

Every dollar figure in this project depends on two assumptions I chose deliberately and stated openly rather than hiding inside the numbers: a $5 cost per call, and an 11 percent realistic baseline conversion rate. Change either assumption and the specific dollar amounts change, but the underlying finding, that the campaign's highest-volume segments are also its least efficient, holds regardless of the exact cost-per-call figure used.

---

**Timothy Kehinde Promise**
Data Analyst Intern, AnalystLab Africa
[Linkedin]([https://bit.ly/4qIn19W](https://www.linkedin.com/in/timothy-kehinde-promise-17810529b))
