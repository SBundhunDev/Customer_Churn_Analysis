# Customer Churn Analysis for an OTT Platform

Why do subscribers of a streaming (OTT) service cancel, and which customers are most at risk of leaving next? This project loads customer, subscription and support data into SQL Server, cleans it, and analyses it in Python to find the drivers of churn.

> **Status: work in progress.** The database is built and the notebook now covers data import and data cleaning (see [Progress](#progress)). Feature engineering, analysis and charts are still to come, so the Solution and Demo sections below are placeholders.

## Problem

An OTT platform loses a share of its subscribers every year. Each cancellation costs recurring revenue, and winning a new customer costs more than keeping an existing one. The business needs to know:

- How many customers churn, and how much monthly revenue goes with them?
- Which segments churn most (plan, contract type, acquisition channel, location)?
- What reasons do customers give for cancelling?
- Do support complaints, escalations and low satisfaction scores come before a cancellation?

## Data

| File | Contents |
| --- | --- |
| [Data/customer_churn_data_raw.xlsx](Data/customer_churn_data_raw.xlsx) | Raw source workbook |
| [Data/OTT_customer_churn_db.sql](Data/OTT_customer_churn_db.sql) | SQL Server script that creates and populates `OTTCustomerChurnDB` |

The database has three tables joined on `customerid`:

| Table | Rows | Key columns |
| --- | --- | --- |
| `db_customer` | 21 | name, country, state, gender, dob, interests |
| `db_subscription` | 21 | start and renewal dates, subscription type, plan type, contract type, cancellation date and reason, monthly charges, CLTV, churn score |
| `db_support` | 9 | complaint date, escalation flag, CSAT score, comment |

A customer counts as churned when `cancellation_date` is filled in. In the current data that is 6 of the 21 subscriptions.

The raw data is deliberately messy, and cleaning it is part of the project:

- Gender is coded inconsistently (`Male` / `Men`, `Female` / `Women`).
- Country is missing for three customers, stored as a mix of `NULL` and empty strings.
- Acquisition channel (`subscription_type`) contains a misspelling (`Refferal`).
- The subscription date columns arrive in pandas as generic objects, not datetimes.
- `pincode` is empty and `interests` is filled in for only 4 of 21 customers.
- `db_support` has an empty, unnamed column (`col_1`).

## Approach

1. **Load**: run the SQL script to build the database in SQL Server.
2. **Extract**: query the three tables from Python with SQLAlchemy and pyodbc.
3. **Clean**: standardise categories, handle missing values, fix data types.
4. **Engineer**: derive a churn flag, customer tenure, age, and complaint and escalation counts per customer.
5. **Analyse**: compare churn rates across segments and cancellation reasons.
6. **Visualise**: chart the findings with matplotlib and seaborn.
7. **Recommend**: turn the findings into retention actions.

## Progress

Steps 1 to 3 are in the notebook. Steps 4 to 7 have not been started.

### Importing data

- Connects to SQL Server through SQLAlchemy and pyodbc using Windows authentication.
- Discovers the tables from `sys.tables` and loads each one into its own DataFrame (`df_db_customer`, `df_db_subscription`, `df_db_support`).
- Lists every table's columns from `INFORMATION_SCHEMA.COLUMNS`. This is optional for three small tables, and the notebook explains when inspecting the schema first pays off on larger databases.

### Data cleaning

| Table | Issue | Fix applied |
| --- | --- | --- |
| `db_customer` | `interests` is mostly empty and `pincode` is entirely empty | Dropped both columns |
| `db_customer` | `name` is ambiguous once tables are joined | Renamed to `customer_name` |
| `db_customer` | Country missing for 3 customers, as `NULL` or an empty string | Trimmed whitespace and converted blanks to nulls, then filled each one from a state-to-country lookup built from the complete rows (Washington and Texas to USA, Ontario to Canada) |
| `db_customer` | Gender coded four ways | Standardised `Men` to `Male` and `Women` to `Female` |
| `db_subscription` | Start, renewal and cancellation dates loaded as objects | Converted to `datetime` |
| `db_subscription` | Acquisition channel misspelled as `Refferal` | Corrected to `Referral` |
| `db_support` | `col_1` is empty and `comment` is free text filled in for 4 of 9 rows | Dropped both columns |

The country fill relies on each state belonging to a single country, which holds for this dataset.

`cltv`, `churn_score` and `csat_score` are fully populated and are kept for the analysis.

## Solution

*To be added once the analysis is complete: key findings, churn rate by segment, and recommendations.*

## Demo

*Charts will be saved to an `images/` folder and shown here.*

## How to run

**Requirements:** Python 3.14, SQL Server (with SSMS or `sqlcmd`), and ODBC Driver 17 for SQL Server.

1. Clone the repository.

   ```bash
   git clone https://github.com/SBundhunDev/Customer_Churn_Analysis.git
   cd Customer_Churn_Analysis
   ```

2. Create the database: open [Data/OTT_customer_churn_db.sql](Data/OTT_customer_churn_db.sql) in SSMS and execute it. The final query should report 21, 21 and 9 rows.

3. Create a virtual environment and install the dependencies.

   ```powershell
   python -m venv .venv
   .venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

4. Open [Notebook/OTT_Customer_Churn_Analysis.ipynb](Notebook/OTT_Customer_Churn_Analysis.ipynb) in VS Code or Jupyter and select the virtual environment as the kernel.

5. In the connection cell, set `server` to your own SQL Server instance name (the one shown in the SSMS connect dialog, for example `MYPC\SQLEXPRESS`). The notebook connects with Windows authentication, so no username or password is needed.

6. Run all cells.

The notebook reads from the database, not from the script. If you edit the data in [Data/OTT_customer_churn_db.sql](Data/OTT_customer_churn_db.sql), execute the script again in SSMS and then re-run the notebook to see the change.

## Project structure

```
Customer_Churn_Analysis/
├── Data/
│   ├── customer_churn_data_raw.xlsx
│   └── OTT_customer_churn_db.sql
├── Notebook/
│   └── OTT_Customer_Churn_Analysis.ipynb
├── LICENSE
├── README.md
└── requirements.txt
```

## Tech stack

Python · pandas · NumPy · matplotlib · seaborn · SQLAlchemy · pyodbc · SQL Server · Jupyter

## License

Released under the [MIT License](LICENSE).
