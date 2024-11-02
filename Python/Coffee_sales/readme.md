In this coffee sales data analysis project, I undertook a series of data processing and exploration tasks aimed at extracting insights and trends from the dataset.

1. **Data Import and Initial Processing**: I started by importing the raw coffee sales data and creating a copy for analysis. I conducted preliminary checks for metadata, missing values, and duplicate records to ensure the data’s accuracy.

2. **Data Cleaning**: Some columns, like the date, were found redundant and removed to streamline the dataset. I then focused on the `datetime` column, converting its data type to `datetime` format and extracting specific time-based features such as hour, month, year, and day, which added more dimensions to the dataset for detailed time-based analysis.

3. **Handling Missing Values**: For fields like `card` that contained missing values, I filled these gaps using the mode value of the column, ensuring a complete dataset for analysis.

4. **Categorical Analysis**: I examined categorical variables like `cash_type` and `coffee_name`. For coffee names, I calculated both the frequency and percentage of each type, identifying the most popular coffee products in terms of sales volume.

5. **Exploratory Data Analysis (EDA)**:
   - **Revenue Analysis**: I calculated revenue by coffee type to identify high-earning products. Visualizations, including bar charts, highlighted the revenue distribution across coffee types.
   - **Monthly and Weekly Sales Trends**: I grouped the data by `coffee_name` and `Month` to observe monthly sales trends for each coffee type. This approach was extended to weekly sales as well, where I visualized sales for each day of the week, helping to pinpoint peak days for sales.
   - **Hourly Sales Patterns**: I also analyzed sales by hour to understand peak sales times throughout the day.

6. **Data Visualization**: Various plots, such as bar charts and line graphs, were created to showcase monthly, weekly, and hourly sales trends across different coffee products, providing clear, visual insights into the sales patterns.

This project involved a structured approach to data analysis and visualization, yielding a detailed breakdown of coffee sales patterns by time, payment type, and product type. The insights derived could aid in strategic decisions regarding product offerings and promotional timings.
