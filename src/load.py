import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine


PROCESSED_DATA_PATH = Path("data/processed/clean_purchases.csv")


def get_database_url() -> str:
    load_dotenv()

    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5432")
    db_name = os.getenv("DB_NAME", "ecommerce")
    db_user = os.getenv("DB_USER")
    db_password = os.getenv("DB_PASSWORD", "")

    if not db_user:
        raise ValueError("DB_USER is missing. Please set it in your .env file.")

    if db_password:
        return f"postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

    return f"postgresql+psycopg2://{db_user}@{db_host}:{db_port}/{db_name}"


def load_purchases_to_postgres(input_path: Path) -> None:
    df = pd.read_csv(input_path)

    engine = create_engine(get_database_url())

    df.to_sql(
        name="raw_purchases",
        con=engine,
        if_exists="append",
        index=False,
    )

    print("Load complete.")
    print(f"Rows loaded: {len(df)}")
    print("Target table: raw_purchases")


if __name__ == "__main__":
    load_purchases_to_postgres(PROCESSED_DATA_PATH)