# Festive Season Sales Analysis

Exploratory Data Analysis (EDA) on festive-season retail sales data using Python, uncovering who buys the most during the season, what they buy, and where they're from.

## Overview

This project analyzes a retail sales dataset collected during a major shopping season to identify purchasing patterns across customer demographics (gender, age, marital status, occupation, location) and product categories. The goal is to help a business understand its core customer segment and top-performing products/regions for targeted marketing.

## Dataset

The raw dataset contains **11,251 rows and 15 columns**:

| Column | Description |
|---|---|
| User_ID | Unique customer identifier |
| Cust_name | Customer name |
| Product_ID | Unique product identifier |
| Gender | Customer gender |
| Age Group | Binned age range |
| Age | Customer age |
| Marital_Status | 0 = unmarried, 1 = married |
| State | Customer's state |
| Zone | Customer's zone/region |
| Occupation | Customer's occupation |
| Product_Category | Category of product purchased |
| Orders | Number of orders |
| Amount | Purchase amount |
| Status, unnamed1 | Empty/irrelevant columns (dropped during cleaning) |

> **Note:** The source file was originally named `Diwali Sales Data.csv`. If you want the repo fully rebranded, rename it to something like `Festive_Sales_Data.csv` and update the `read_csv` call in the notebook to match.

## Data Cleaning

- Dropped the empty `Status` and `unnamed1` columns.
- Removed 12 rows with null `Amount` values, leaving **11,239 clean rows**.
- Cast `Amount` to integer type for analysis.

## Exploratory Data Analysis

The notebook walks through count plots and bar plots (via `matplotlib`/`seaborn`) to break down total orders and total sales `Amount` across:

- **Gender** — who buys more, and who spends more
- **Age Group** — spending by age bracket, split by gender
- **State** — top 10 states by order volume and by total sales
- **Marital Status** — spending by marital status, split by gender
- **Occupation** — spending across occupation categories
- **Product Category** — most popular and highest-grossing categories
- **Top Products** — top 10 best-selling `Product_ID`s by order count

## Key Insights

- Female shoppers place more orders and drive more total revenue than male shoppers.
- The **26–35** age group is the largest and highest-spending segment, especially among women.
- **Uttar Pradesh, Maharashtra, and Karnataka** lead in both order volume and total sales.
- **Married women** are the strongest-spending customer segment overall.
- Buyers working in **IT, Healthcare, and Aviation** contribute the most in sales.
- **Food, Clothing, and Electronics** are the top-selling product categories.

**Bottom line:** Married women aged 26–35, based in UP, Maharashtra, and Karnataka, working in IT, Healthcare, or Aviation, are the most likely to buy — mainly Food, Clothing, and Electronics. This segment is the ideal target for festive-season marketing campaigns.

## Tech Stack

- Python 3
- pandas, numpy
- matplotlib, seaborn
- Jupyter Notebook / Google Colab

## Project Structure

```
├── Festive_Season_Sales_Analysis.ipynb   # Main analysis notebook
├── Festive_Sales_Data.csv                # Raw dataset (add your own copy)
└── README.md
```

## Getting Started

1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd <your-repo-folder>
   ```
2. Install dependencies:
   ```bash
   pip install numpy pandas matplotlib seaborn
   ```
3. Place your sales data CSV in the project folder.
4. Open the notebook in Jupyter or Google Colab and run all cells.

> **Note:** The notebook was originally written for Google Colab and uses `from google.colab import files` with `files.upload()` to load the CSV interactively. If running locally in Jupyter, replace that cell with:
> ```python
> df = pd.read_csv('Festive_Sales_Data.csv', encoding='unicode_escape')
> ```

## License

Add a license of your choice (e.g., MIT) if you plan to share this publicly.
