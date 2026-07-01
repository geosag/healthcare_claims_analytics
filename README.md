# Healthcare Claims Analytics

A comprehensive data model and Power BI dashboard for monitoring and analyzing healthcare claims processing, financial performance, and patient demographics. Relational data spanning members, providers, and payment transactions is transformed into an analytical schema and visualized across a 3-page interactive report.

📊 [**View the live dashboard**](https://app.powerbi.com/view?r=eyJrIjoiOWI5MWU2N2MtMjJiNC00NTQxLWIyNzAtZGY4MzAyZGRiMThkIiwidCI6IjIyMzk4NzFkLTBmNmItNDQ4NS04ZjIzLTM1NmE0MzJlYzNmYiJ9)

---

## Overview

This analytical solution processes complex healthcare data to provide stakeholders with actionable insights into claims operations. The dashboard tracks the entire lifecycle of a claim, from initial submission to final payout, highlighting financial gaps, operational bottlenecks (like denied claims), and demographic trends among patients and providers.

---

## Dashboard

The report is divided into three distinct thematic views, all cross-filtered by a global "Select Year" slicer and persistent top-level KPIs.

**Global KPIs (Persistent across all pages):**
* Total Claims Volume
* Total Billed Amount
* Total Net Payment
* Total Patient Responsibility
* Average Payment per Claim

**Page 1 - Financial Performance View**
* **Financial Gap:** A combo chart comparing Total Billed Amount, Total Approved Amount, and Total Net Payment over time.
* **Facilities by Billed Amount:** A treemap highlighting the distribution of billed amounts across different hospitals and clinics (e.g., Advent Health, Smile Dental).
* **Total Net Payment by Provider Degree:** A funnel chart breaking down payments by provider credentials (MBBS, RD, MS, PSYD, etc.).
* **Patient Cost Breakdown:** A donut chart dividing total patient responsibility into Coinsurance Amount and Copay Amount.

**Page 2 - Operational & Claims Analysis View**
* **Claims Volume Over Time:** An area chart tracking the historical trend of claim submissions.
* **Claim Status Distribution:** A bar chart categorizing the current standing of claims (Deny, History, In Progress, Paid, Pend).
* **In vs. Out of Network Compliance:** A stacked column chart evaluating the volume of claims processed within the provider network versus out-of-network over time.
* **Denied Claims by Facility:** A matrix table identifying which specific facilities experience the highest number of denied claims.

**Page 3 - Member & Demographic Insights View**
* **Geographic Distribution of Claims:** A map visual plotting claim origination across the globe.
* **Claims Volume by Age Group:** A column chart utilizing custom bins (0-18, 19-35, 36-50, 50+) to track which patient demographics drive the most claims.
* **Total Spend by Coverage Plan:** A waterfall chart showing how different insurance tiers (Bronze, Gold, Platinum, Silver) contribute to the overall net payment.
* **Member Volume by Gender:** A pie chart detailing the gender breakdown of the patient population.

---

## Data Architecture

### Database Schema & Power BI Data Model

The underlying data model has been optimized for Power BI, transitioning from a normalized relational database (containing tables like `st`, `claim`, `cov`, `add`, `claim_payment`, `mem`, and `pr`) into a robust analytical schema. 

| Table | Description | Key Visible Fields |
|---|---|---|
| `claims` | **Primary Fact Table:** Core claims header data | `claim_id`, `date_of_service`, `received_date`, `status_id` |
| `payments` | **Secondary Fact Table:** Granular financial transaction details | `claim_payment_id`, `claim_id`, `billed_amount`, `approved_amount`, `net_payment` |
| `members` | **Dimension:** Patient demographics | `member_id`, `coverage_id`, `age_bins`, `gender`, `member_dob` |
| `providers` | **Dimension:** Healthcare professional and facility data | `provider_id`, `degree`, `network`, `practice_name` |
| `coverages` | **Dimension:** Insurance plan details | `coverage_id`, `coverage_name`, `effective_date`, `term_date` |
| `statuses` | **Dimension:** Claim lifecycle states | `status_id`, `claim_status`, `type` |
| `addresses` | **Dimension:** Geographic locations for members/providers | `address_id`, `city`, `country`, `zipcode` |
| `Dashboard Measures` | **Measure Table:** Dedicated repository for DAX calculations | *(Contains DAX measures like 'Average Payment per Claim' and 'Claims Volume by Age Group')* |

*(Relationships: The architecture relies on a hybrid star/snowflake schema centered around the `claims` and `payments` fact tables. The `claims` table acts as the central hub, connecting to dimensions like `statuses`, `providers`, and `members`. The model utilizes targeted snowflake designs to map extended attributes; for example, the `members` dimension branches out to filter the `coverages` table, while both `members` and `providers` connect to a shared `addresses` dimension for geographic routing.)*

---

## Project structure

```text
healthcare_claims_analytics/
├── postgres_database/
│   └── select_queries.sql
├── .gitignore
└── README.md

---

## Tech stack

* SQL - Data extraction, modeling, and transformation
* Power BI - Data modeling (Power Query/DAX), visualization, and interactive dashboarding

---

*Note: Dataset used in this project was provided by Big Blue Data Academy.*

---
*Built by [Georgios Sagris](https://www.linkedin.com/in/georgesagris/)