# dbt Project Commands: first_ELT_Project

This document lists all PowerShell commands for setting up and running the `first_ELT_Project` dbt project, which loads and transforms Airbnb data (102,599 rows, 26 columns) in `first_ELT_DB` using PostgreSQL, Python, and dbt on Windows with VS Code. Follow these steps sequentially to replicate the project.

## 1. Setup Python Virtual Environment
Create and activate a virtual environment (`dbt_env`) for Python and dbt dependencies.

```powershell
# Navigate to project directory Create virtual environment (use Python 3.11 for compatibility)
python3.11 -m venv dbt_env

# Activate virtual environment
.\dbt_env\Scripts\activate

# Fix PowerShell execution policy if activation fails
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

## 2. Install Python Dependencies
Install libraries for `load_to_postgres.py` and dbt.

```powershell
pip install -r requirements.txt
```

## 3. Setup PostgreSQL
Ensure PostgreSQL is running and create the `first_ELT_DB` database.

```powershell
# Check PostgreSQL status
pg_isready -h localhost -p 5432
```

```sql
-- In pgAdmin or psql:
CREATE DATABASE first_ELT_DB;
```

## 4. Load Airbnb Data
Run the Python script from the root of the project to load the raw sample data into the public.raw_airbnb_data table.

```powershell
# Run the script (update path if kept in dbt_env)
python .\load_to_postgres.py
```

## 5. Setup dbt Project
Initialize and configure the dbt project.

```powershell
# Initialize dbt project (if not already done)
dbt init first_ELT_Project

# Navigate to project
cd first_ELT_Project

# Test dbt connection
dbt debug
```

**Configure `profiles.yml`** (at `C:\Users\YOUR_NAME\.dbt\profiles.yml`):
```yaml
first_ELT_Project:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      password: <YOUR_POSTGRES_PASSWORD>
      port: 5432
      dbname: first_ELT_DB
      schema: public
```

## 6. Create dbt Source & Run Models
Define the source in models/sources.yml and then execute the dbt transformation models to clean the data directly within PostgreSQL:

```PowerShell
# Execute dbt transformations in-database
dbt run

# Run data quality tests
dbt test
```

# Repository Structure
airbnb-elt-vs-etl/
├── first_ELT_Project/       # dbt project (SQL models and configurations)
├── sample_data/             # Data sample (CSV)
├── scripts/                 # Automation scripts (Pandas cleaning & Loading)
├── .gitignore               # Files and folders ignored by Git
├── requirements.txt         # Python dependencies for the project
└── README.md                # Project documentation

# Notes
Environment: Windows, VS Code, Python 3.11, PostgreSQL.
Database: first_ELT_DB, public schema.

##  Author
**Mohammed Essalhi**
* [LinkedIn](https://linkedin.com/in/mohammed-essalhi-23794b24b)



