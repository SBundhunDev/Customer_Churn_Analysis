# Customer Churn Analysis for an OTT Platform

Why do subscribers of a streaming (OTT) service cancel, and which customers are most at risk of leaving next? This project loads customer, subscription and support data into SQL Server, cleans it, and analyses it in Python to find the drivers of churn.

> **Status: work in progress.** The database and raw data are in place. The analysis notebook is still to be written, so the Solution and Demo sections below are placeholders.

## Problem

An OTT platform loses a share of its subscribers every year. Each cancellation costs recurring revenue, and winning a new customer costs more than keeping an existing one. The business needs to know:

- How many customers churn, and how much monthly revenue goes with them?
- Which segments churn most (plan, contract type, acquisition channel, location)?
- What reasons do customers give for cancelling?
- Do support complaints and escalations come before a cancellation?

## Data

| File | Contents |
| --- | --- |
| [Data/customer_churn_data_raw.xlsx](Data/customer_churn_data_raw.xlsx) | Raw source workbook |
| [Data/OTT_customer_churn_db.sql](Data/OTT_customer_churn_db.sql) | SQL Server script that creates and populates `OTTCustomerChurnDB` |

The database has three tables joined on `customerid`:

| Table | Rows | Key columns |
| --- | --- | --- |
| `db_customer` | 21 | name, country, state, gender, dob, interests |
| `db_subscription` | 21 | start and renewal dates, subscription type, plan type, contract type, cancellation date and reason, monthly charges |
| `db_support` | 9 | complaint date, escalation flag, CSAT score, comment |

A customer counts as churned when `cancellation_date` is filled in.

The raw data is deliberately messy, and cleaning it is part of the project:

- Gender is coded inconsistently (`Male` / `Men`, `Female` / `Women`).
- Country is blank or missing for some customers, and some states do not match their country.
- Acquisition channel contains a misspelling (`Refferal`).
- `cltv`, `churn_score`, `pincode` and `csat_score` are empty, and `db_support` has an unnamed column (`col_1`).

## Approach

1. **Load**: run the SQL script to build the database in SQL Server.
2. **Extract**: query the three tables from Python with SQLAlchemy and pyodbc.
3. **Clean**: standardise categories, handle missing values, fix data types.
4. **Engineer**: derive a churn flag, customer tenure, age, and complaint and escalation counts per customer.
5. **Analyse**: compare churn rates across segments and cancellation reasons.
6. **Visualise**: chart the findings with matplotlib and seaborn.
7. **Recommend**: turn the findings into retention actions.

## Solution

*To be added once the analysis is complete: key findings, churn rate by segment, and recommendations.*

## Demo

*Charts will be saved to an `images/` folder and shown here.*

## How to run

**Requirements:** Python 3.14, SQL Server (with SSMS or `sqlcmd`), and the ODBC Driver for SQL Server.

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

4. Open [Notebook/OTT_Customer_Churn_Analysis.ipynb](Notebook/OTT_Customer_Churn_Analysis.ipynb) in VS Code or Jupyter, select the virtual environment as the kernel, and run all cells.

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
