# Crop Recommendation Dashboard

This project is a Shiny-based dashboard created using `flexdashboard` to analyze and visualize data from a crop recommendation dataset. The dashboard provides functionalities for exploratory data analysis, regression analysis, histogram generation, and distribution visualizations. It also supports interactive data editing and displays.

## Features

### 1. **Data Table**
- Displays the `Crop_recommendation.csv` dataset in a dynamic, interactive table.
- Powered by the `DT` library.

### 2. **Analysis**
#### Sidebar
- Select specific columns for analysis using dropdowns.
- Calculate and display summary statistics such as mean, standard deviation, and interquartile range (IQR).

#### Main Panel
- Show the calculated values of:
  - Minimum and Maximum
  - Summary statistics
  - Standard Deviation
  - Interquartile Range (IQR)

### 3. **Regression Analysis**
Performs regression analysis on specific variable pairs:
- **ph ~ Rainfall**: Analyzes the relationship between `ph` and `rainfall`.
- **ph ~ Humidity**: Analyzes the relationship between `ph` and `humidity`.
- **N ~ ph**: Analyzes the relationship between `N` and `ph`.
- **P ~ ph**: Analyzes the relationship between `P` and `ph`.
- **K ~ ph**: Analyzes the relationship between `K` and `ph`.

Each analysis includes:
- Linear regression modeling (`lm`).
- Scatter plots with regression lines.

### 4. **Histogram**
Generates histograms grouped by selected metrics:
- Users can select a column to group by and a numeric metric to visualize.
- Generates a histogram dynamically based on the selected inputs.

### 5. **Edit Table**
- Provides an editable table for modifying the `Crop_recommendation.csv` data.
- Allows inserting or deleting rows interactively.

### 6. **Distributions**
- Visualizes data distributions (Normal or Uniform) based on user inputs.
- Sidebar inputs:
  - Distribution type (Normal/Uniform).
  - Sample size, mean, and standard deviation (for Normal distribution).
  - Minimum and maximum values (for Uniform distribution).
- Main panel shows a histogram of the generated distribution.

### 7. **Interactive Table and Chart**
- Group data dynamically by selected columns.
- Summarize numeric data with user-defined metrics.
- Export data in various formats (`CSV`, `Excel`, `PDF`, etc.).

## Dependencies

Ensure you have the following R packages installed:
- `shiny`
- `flexdashboard`
- `DT`
- `tidyverse`
- `datasets`
- `rlang`

## Installation

1. Clone or download the repository.
2. Place the `Crop_recommendation.csv` file in the same directory as the R Markdown file.
3. Install required R libraries:
   ```R
   install.packages(c("shiny", "flexdashboard", "DT", "tidyverse", "datasets", "rlang"))
   ```
4. Run the app by opening the .Rmd file in RStudio and clicking "Run Document".

## Usage

1. Launch the dashboard.
2. Use the sidebar inputs to interact with the analysis and visualizations.
3. View summary statistics, regression plots, and data visualizations.
4. Edit and update the table or download/export data as needed.

## Dataset

The Crop_recommendation.csv file contains columns for the following attributes:

- Nitrogen (N)
- Phosphorus (P)
- Potassium (K)
- Temperature
- Humidity
- pH
- Rainfall

## Output

- Interactive data tables.
- Regression plots with trend lines.
- Histograms and distribution plots.
- Editable tables with data export functionality.

---
