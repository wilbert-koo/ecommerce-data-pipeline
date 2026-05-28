import pandas as pd
from pathlib import Path


RAW_DATA_PATH = Path("data/raw/ecommerce_dataset_updated.csv")
PROCESSED_DATA_PATH = Path("data/processed/clean_purchases.csv")


def clean_purchases(input_path: Path, output_path: Path) -> None:
    """
    Clean raw e-commerce purchase data and export a processed CSV file.

    Steps:
    1. Standardize column names
    2. Convert purchase_date to datetime
    3. Validate price, discount, and final price values
    4. Add purchase_month
    5. Add discount_amount
    6. Export clean_purchases.csv
    """

    df = pd.read_csv(input_path)

    # Rename columns to snake_case
    df = df.rename(
        columns={
            "User_ID": "user_id",
            "Product_ID": "product_id",
            "Category": "category",
            "Price (Rs.)": "price_rs",
            "Discount (%)": "discount_pct",
            "Final_Price(Rs.)": "final_price_rs",
            "Payment_Method": "payment_method",
            "Purchase_Date": "purchase_date",
        }
    )

    # Remove duplicate rows
    df = df.drop_duplicates()

    # Convert purchase_date to datetime
    df["purchase_date"] = pd.to_datetime(df["purchase_date"], errors="coerce")

    # Convert numeric columns
    numeric_columns = ["price_rs", "discount_pct", "final_price_rs"]

    for col in numeric_columns:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    # Drop rows with invalid required fields
    required_columns = [
        "user_id",
        "product_id",
        "category",
        "price_rs",
        "discount_pct",
        "final_price_rs",
        "payment_method",
        "purchase_date",
    ]

    df = df.dropna(subset=required_columns)

    # Validate values
    df = df[df["price_rs"] > 0]
    df = df[df["final_price_rs"] > 0]
    df = df[(df["discount_pct"] >= 0) & (df["discount_pct"] <= 100)]

    # Add derived columns
    df["purchase_month"] = df["purchase_date"].dt.to_period("M").astype(str)
    df["discount_amount"] = df["price_rs"] * (df["discount_pct"] / 100)
    df["expected_final_price_rs"] = df["price_rs"] - df["discount_amount"]
    df["price_difference_rs"] = df["final_price_rs"] - df["expected_final_price_rs"]

    # Reorder columns
    final_columns = [
        "user_id",
        "product_id",
        "category",
        "price_rs",
        "discount_pct",
        "discount_amount",
        "expected_final_price_rs",
        "final_price_rs",
        "price_difference_rs",
        "payment_method",
        "purchase_date",
        "purchase_month",
    ]

    df = df[final_columns]

    # Create processed folder if it does not exist
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Export cleaned data
    df.to_csv(output_path, index=False)

    print(f"Cleaning complete.")
    print(f"Rows exported: {len(df)}")
    print(f"Output file: {output_path}")


if __name__ == "__main__":
    clean_purchases(RAW_DATA_PATH, PROCESSED_DATA_PATH)