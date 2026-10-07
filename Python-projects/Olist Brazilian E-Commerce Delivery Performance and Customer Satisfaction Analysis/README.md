# Olist Brazilian E-Commerce: Delivery Performance & Customer Satisfaction

![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white)
![pandas](https://img.shields.io/badge/pandas-data%20wrangling-150458?logo=pandas&logoColor=white)
![SciPy](https://img.shields.io/badge/SciPy-hypothesis%20testing-8CAAE6?logo=scipy&logoColor=white)
![Jupyter](https://img.shields.io/badge/Notebook-Colab%20%2F%20Jupyter-F37626?logo=jupyter&logoColor=white)

> How much do late deliveries actually hurt customer satisfaction, and where should Olist act first?

An end-to-end data analytics project on **99,441 real Brazilian e-commerce orders (2016-2018)**. I cleaned and merged the linked tables in pandas, engineered delivery and satisfaction features, and tested **5 hypotheses** with Mann-Whitney U, Spearman correlation, Chi-square, and bootstrap resampling to pinpoint the weakest spots in Olist's logistics network.

---

## Table of Contents

- [Business Problem](#business-problem)
- [Key Results](#key-results)
- [Dataset](#dataset)
- [Research Questions](#research-questions)
- [Hypotheses & Verdicts](#hypotheses--verdicts)
- [Methodology](#methodology)
- [Detailed Findings](#detailed-findings)
- [Recommendations](#recommendations)
- [Limitations](#limitations)
- [Repository Structure](#repository-structure)
- [How to Run](#how-to-run)
- [Tech Stack](#tech-stack)
- [Slide Preview](#slide-preview)
- [Author](#author)

---

## Business Problem

Olist connects small and medium sellers across Brazil to major online marketplaces and handles logistics through partner carriers. Reviews and repeat purchases drive seller and platform revenue, and delivery time is typically the biggest complaint in e-commerce logistics.

Some deliveries arrive well past their estimated date, but it was unclear **how much that actually hurts customer satisfaction**, or **which sellers, states, and time periods are most responsible**. Answering this lets Olist fix specific weak points in its network instead of making broad, unfocused changes.

## Key Results

| Metric | Result |
|---|---|
| Review score, on-time orders | **4.29 / 5** |
| Review score, late orders | **2.28 / 5** (a **2.01-point drop**, 95% CI 1.98-2.05) |
| Delivery time, same-state orders | **7.4 days** |
| Delivery time, cross-state orders | **14.4 days** (almost 2x slower) |
| Overall late-delivery rate | **6.5%** (6,249 of 96,182 delivered orders) |
| Worst state for late deliveries | **Alagoas, 20.8%** (vs. 4.4% in Sao Paulo) |
| Worst month for late deliveries | **March, 14.7%** (beats the November peak at 12.1%) |
| Worst reliable seller | **50% late rate** across 46 items |
| Repeat purchase, late vs. on-time first order | 2.55% vs. 3.03% (small, borderline effect) |

**Bottom line:** lateness is the one factor with a large, clear impact on satisfaction, and it is concentrated geographically (Northeast states), seasonally (March and November), and in a small group of sellers. Freight cost and loyalty effects are real but small.

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle): real orders placed between 2016 and 2018 across Brazil.

| Table | Rows | Used in analysis |
|---|---|---|
| `olist_orders_dataset` | 99,441 | Yes: order status and all timestamps |
| `olist_order_items_dataset` | 112,650 | Yes: price, freight, seller per item |
| `olist_order_reviews_dataset` | 99,224 raw / 98,673 after de-duplication | Yes: review score |
| `olist_customers_dataset` | 99,441 | Yes: customer state, `customer_unique_id` |
| `olist_sellers_dataset` | 3,095 | Yes: seller state |
| `olist_order_payments_dataset` | 103,886 | Loaded, not used |
| `olist_products_dataset` | 32,951 | Loaded, not used |
| `product_category_name_translation` | - | Loaded, not used |
| `olist_geolocation_dataset` | - | Not used |

> The raw data is **not** included in this repo. Download it from Kaggle (see [How to Run](#how-to-run)).

## Research Questions

1. What factors are associated with late deliveries?
2. How much do late deliveries reduce customer review scores?
3. Which states and sellers have the worst delivery performance?
4. Does a late first delivery reduce the chance a customer orders again?
5. What should Olist change to reduce delays and protect satisfaction?

## Hypotheses & Verdicts

| # | Hypothesis | Test | Result | Verdict |
|---|---|---|---|---|
| H1 | Late orders receive lower review scores than on-time orders | Mann-Whitney U (one-sided) + bootstrap CI | U = 99,223,042.5, p < 0.001, gap 2.01 (CI 1.98-2.05) | Supported, strong effect |
| H2 | Cross-state orders take longer to deliver than same-state orders | Mann-Whitney U (one-sided) | 14.38 vs. 7.39 days, p < 0.001 | Supported, strong effect |
| H3 | Higher freight-to-price ratio is associated with lower review scores | Spearman correlation (one-sided) | rho = -0.031, p < 0.001 | Weakly supported, negligible effect |
| H4a | Late-delivery rates differ across states | Chi-square | chi2 = 1611.4, df = 26, p < 0.001 | Supported |
| H4b | Late-delivery rates are higher in peak months (e.g. November) | Chi-square | chi2 = 2503.2, df = 11, p < 0.001 | Partially supported |
| H5 | Customers with a late first order are less likely to order again | Chi-square | chi2 = 4.37, df = 1, p = 0.037 | Weakly supported, borderline |

## Methodology

### 1. Data cleaning

- Parsed all five order timestamp columns to `datetime`.
- Confirmed no duplicate `order_id`s and no orders delivered before they were purchased.
- Kept only **`delivered`** orders (96,478 of 99,441), because cancelled or unavailable orders have no real delivery date.
- Dropped 8 delivered orders with a missing delivery timestamp.
- Removed **288 extreme outliers** with delivery time above 60 days.
- Kept only the **latest review per order** (some orders have several), giving 98,673 unique reviews. 631 delivered orders have no review and are excluded from review-based tests.
- Result: a clean, merged analysis table of **96,182 orders x 21 columns**.

### 2. Feature engineering

| Feature | Definition |
|---|---|
| `delivery_days` | Delivered-to-customer date minus purchase timestamp |
| `delay_days` | Delivered-to-customer date minus estimated delivery date |
| `is_late` | `delay_days > 0` |
| `main_seller_state` | Most common seller state among an order's items |
| `cross_state` | `customer_state != main_seller_state` |
| `total_price`, `total_freight` | Summed per order from the items table |
| `freight_ratio` | `total_freight / total_price`, binned into 0-0.2, 0.2-0.4, 0.4-0.6, 0.6-1.0, 1.0+ |
| `customer_unique_id` | Used to follow one real person across orders (`customer_id` changes per order) |
| `is_repeat_customer` | Customer placed more than one delivered order |

### 3. Assumptions

1. Only `delivered` orders are used for delivery-time analysis.
2. Review score reflects the overall purchase experience; delivery timing is a main driver, not the only one.
3. 2016 is too small to compare months reliably (264 orders), so 2017 to mid-2018 is the main window for the monthly analysis.
4. `customer_unique_id` represents one real person; `customer_id` is not used for repeat-purchase analysis.
5. The estimated delivery date shown at checkout is the promise Olist needs to keep, regardless of why an order was delayed.
6. Sellers operate under similar platform rules, so comparing them is fair.
7. No one-off events (strikes, courier issues) caused permanent shifts in delivery patterns, only temporary spikes.

### 4. Statistical approach

- **Mann-Whitney U** for comparing review scores and delivery times between two groups (non-normal, ordinal / skewed data).
- **Bootstrap resampling** (1,000 resamples, `seed=42`) for a 95% confidence interval on the review-score gap.
- **Spearman correlation** for the monotonic freight-ratio vs. review-score relationship.
- **Chi-square test of independence** for lateness vs. state, month, and repeat-purchase status.

## Detailed Findings

### H1: Late delivery hurts reviews, a lot

On-time orders average **4.29 / 5**; late orders drop to **2.28**, a **2.01-point fall**. The bootstrap interval (1.98-2.05) is tight, so the gap is stable. This is the strongest pattern in the dataset.

### H2: Distance slows delivery

Of the delivered orders, 61,571 are cross-state and 34,611 are same-state. Cross-state orders take **14.4 days on average, almost double** the 7.4 days for same-state orders.

### H3: Freight cost barely moves satisfaction

Higher freight-to-price ratios are linked to slightly lower scores (rho = -0.031), but the effect is negligible. Average review score only slips from 4.19 (ratio 0-0.2) to 4.04 (ratio 1.0+), so **every bin still averages above 4.0**.

### H4: Location and timing matter

- **By state:** Alagoas (20.8%), Maranhao (17.0%), Sergipe (14.5%), Piaui (13.1%), and Ceara (12.4%) are the worst. Sao Paulo, the main seller hub, is among the best at 4.4%, and the lowest rates are in Acre (1.3%), Amapa (1.5%), and Amazonas (2.1%).
- **By month (2017-2018):** March has the highest late rate (**14.7%**), ahead of November (**12.1%**), then February (11.3%) and December (7.1%). June is the lowest (1.6%). Black Friday volume explains part of the November spike, but **March is worse than November**, which points to causes beyond holiday demand.

### H5: Lateness has a small effect on loyalty

Of 93,071 unique customers, 90,278 ordered only once. Customers whose first order was late repeat at **2.55%** vs. **3.03%** when it was on time. The difference is statistically significant only marginally (p = 0.037) and the effect is small, so a single late delivery is not a strong standalone driver of churn in this data.

### Additional analysis: seller performance

Across **2,967 sellers** with delivered items, 880 have at least 20 items sold (the threshold used to trust a late rate). Among them, the **worst seller is late 50% of the time across 46 items**, roughly 8x the 6.5% platform average, and the **10 worst sellers all exceed a 23% late rate**. A small number of consistently underperforming sellers appears to be responsible for a disproportionate share of bad outcomes.

## Recommendations

1. **Set distance-based delivery estimates, not a flat default.** Cross-state orders take about twice as long, so promises should reflect it.
2. **Prioritize logistics fixes in Alagoas and Maranhao first.** They have the highest late rates, at roughly 4-5x the Sao Paulo rate.
3. **Audit the small group of sellers with 25-50% late rates.** Targeted intervention beats platform-wide policy changes.
4. **Investigate March specifically.** It beats the November peak, so something other than Black Friday volume is driving delays.

## Limitations

- **Association, not causation.** All tests are observational; late orders may also differ in other ways (product type, seller, region).
- **Order-to-seller-state mapping is approximate.** For multi-seller orders, `main_seller_state` uses the most common seller state among the items.
- **Small states have unstable rates.** For example, Roraima has only 38 delivered orders and Amapa 66, so their late rates should be read with care.
- **Monthly comparison pools 2017 and 2018.** Seasonality cannot be fully separated from one-off events in a two-year window.
- **Repeat purchase is rare in this dataset** (about 3% of customers), which limits the statistical power of H5.
- **Product category is not analysed.** The seller-level analysis is included; a category-level breakdown is a natural next step.

## Repository Structure

> Adjust the paths below to match how you organise the repo.

```
.
├── README.md
├── notebooks/
│   └── Olist_Brazilian_E_Commerce_Delivery_Performance_and_Customer_Satisfaction_Analysis.ipynb
├── reports/
│   └── Olist_Delivery_Performance_Report.pdf     # business problem, assumptions, research questions, hypotheses
├── slides/
│   └── slide_1.png ... slide_8.png               # 8-slide project summary
└── data/                                         # not tracked: download from Kaggle
```

Suggested `.gitignore` entry so the raw CSVs are never committed:

```
data/*.csv
```

## How to Run

**1. Get the data.** Download the [Olist dataset from Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and place the CSV files in a `data/` folder.

**2. Install dependencies.**

```bash
pip install pandas numpy matplotlib seaborn scipy jupyter
```

**3. Point the notebook at your data.** The notebook was written in Google Colab and mounts Google Drive. To run it locally, skip the Drive-mount cell and change the data path:

```python
DATA_DIR = "data/"
```

**4. Run all cells** in the notebook. Everything, from cleaning to the final seller analysis, runs top to bottom.

**Or** open it directly in Google Colab, mount your Drive, and set `DATA_DIR` to the folder containing the CSVs.

## Tech Stack

- **Python**: core language
- **pandas / NumPy**: cleaning, merging, feature engineering
- **Matplotlib / Seaborn**: visualisation (blue = on-time / baseline, red = late / problem)
- **SciPy.stats**: Mann-Whitney U, Spearman, Chi-square

## Slide Preview

<details>
<summary><b>Click to expand the 8-slide summary</b></summary>

<br>

![Slide 1: Title and business problem](slides/slide_1.png)
![Slide 2: Dataset and cleaning](slides/slide_2.png)
![Slide 3: Hypothesis 1](slides/slide_3.png)
![Slide 4: Hypothesis 2](slides/slide_4.png)
![Slide 5: Hypothesis 3](slides/slide_5.png)
![Slide 6: Hypothesis 4](slides/slide_6.png)
![Slide 7: Hypothesis 5](slides/slide_7.png)
![Slide 8: Key takeaways and recommendations](slides/slide_8.png)

</details>

## Author

**Jobyar Ahmed**
Dhaka, Bangladesh

<!-- Add your links, e.g.: [LinkedIn](https://linkedin.com/in/your-handle) · [Email](mailto:you@example.com) -->

---

*Dataset: Brazilian E-Commerce Public Dataset by Olist, via Kaggle. This is an independent portfolio project and is not affiliated with Olist.*
