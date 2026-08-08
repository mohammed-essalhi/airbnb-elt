import pandas as pd
import psycopg2
from sqlalchemy import create_engine

# Database connection parameters
db_params = {
    'dbname': 'first_ELT_DB',
    'user': 'postgres',
    'password': '<YOUR_POSTGRES_PASSWORD>',
    'host': 'localhost',
    'port': '5432'
}

# Schema and table details for ELT Staging
schema = 'public'
table_name = 'raw_airbnb_data'

# Function to load raw data to PostgreSQL
def load_raw_data(csv_file_path, schema, table_name, conn_params):
    try:
        # Load CSV into DataFrame
        df = pd.read_csv(csv_file_path, low_memory=False)
        print(f"Loaded {len(df)} rows & {len(df.columns)} cols from {csv_file_path}")

        # Clean column names just to be safe for SQL
        df.columns = [col.replace(' ', '_').lower() for col in df.columns]

        # Create SQLAlchemy engine
        conn_string = f"postgresql+psycopg2://{conn_params['user']}:{conn_params['password']}@{conn_params['host']}:{conn_params['port']}/{conn_params['dbname']}"
        engine = create_engine(conn_string)

        # Load raw DataFrame to PostgreSQL (Pandas automatically creates the table)
        df.to_sql(table_name, engine, schema=schema, if_exists='replace', index=False, chunksize=10000)
        print(f"Data loaded successfully into {schema}.{table_name}")

    except Exception as e:
        print(f"Error loading data: {e}")

# Main execution
if __name__ == "__main__":
    # CSV file path (Relative path for GitHub)
    csv_file_path = 'sample_data/airbnb_sample.csv'

    print("Starting data load process...")
    # Clean and load data directly
    load_raw_data(csv_file_path, schema, table_name, db_params)
    print("Process finished.")