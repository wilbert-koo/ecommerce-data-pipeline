# E-commerce Purchase Analytics Pipeline

## Overview

This project builds an end-to-end data engineering pipeline for e-commerce purchase analytics.

The pipeline extracts raw transaction data from a CSV file, cleans and standardizes the data using Python, loads it into PostgreSQL, and prepares analytics-ready tables for business reporting.

The dataset contains customer purchase transactions, product categories, pricing, discounts, payment methods, and purchase dates.

## Project Goals

The goal of this project is to simulate a modern data engineering workflow for an e-commerce business.

This project demonstrates:

- Data ingestion from raw CSV files
- Data cleaning and standardization with Python
- Relational database design with PostgreSQL
- SQL-based analytics
- Data modeling for reporting
- Future orchestration with Airflow
- Future transformation workflow with dbt
- Dockerized local development environment

## Dataset

The dataset contains 3,660 e-commerce purchase records.

### Columns

| Column | Description |
|---|---|
| User_ID | Unique identifier for the user |
| Product_ID | Unique identifier for the product |
| Category | Product category |
| Price (Rs.) | Original product price in Indian Rupees |
| Discount (%) | Discount percentage applied to the purchase |
| Final_Price(Rs.) | Final price after discount |
| Payment_Method | Payment method used by the customer |
| Purchase_Date | Date of purchase |

### Dataset Notes

- The dataset has no missing values.
- Purchase dates range from January 2024 to November 2024.
- Prices are listed in Indian Rupees.
- Since each user and product appears to be mostly unique, this project focuses more on transaction, category, pricing, and payment analytics rather than repeat-customer analysis.

## Business Questions

This project answers the following business questions:

1. What is the monthly revenue trend?
2. Which product categories generate the most revenue?
3. What are the most commonly used payment methods?
4. What is the average discount by product category?
5. How does discount percentage affect final purchase price?
6. What is the average transaction value by category?
7. Which months had the highest purchase activity?

## Tech Stack

- Python
- Pandas
- PostgreSQL
- SQL
- dbt
- Airflow
- Docker
- GitHub Actions

## Pipeline Architecture

```text
Raw CSV Data
      ↓
Python Data Cleaning
      ↓
Processed CSV
      ↓
PostgreSQL Raw Table
      ↓
SQL / dbt Transformations
      ↓
Analytics Tables
      ↓
Dashboard / Reporting