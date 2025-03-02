# Google Data Analytics 
# Capstone Project: Cyclistic Case Study
Course: [Google Data Analytics Capstone: Complete a Case Study](https://www.coursera.org/learn/google-data-analytics-capstone)
## Introduction
In this case study, I will take on the role of a junior data analyst at a fictional Cyclistic company , performing a variety of real-world tasks. And to address the key business questions, I will follow the six data analysis phases:

[Ask] (https://github.com/SomiaNasir/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/blob/main/README.md#ask), 
[Prepare], 
[Process], 
[Analyze], 
[Share], and 
[Act].

### Data Source:
[divvy_tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html)
  
SQL Queries:  
[Explore and Process Data](https://github.com/SomiaNasir/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/blob/main/01.%20Data%20Combining.sql)    
[Data Cleaning]
[Data Analysis]
  
Data Visualizations: [Tableau](https://public.tableau.com/app/profile/somia.nasir/viz/bike-tripdata-casestudy/Dashboard1#1)  

### Background
Cyclistic operates a bike-share program with over 5,800 bicycles and 600 docking stations. What makes Cyclistic unique is its inclusive approach, offering reclining bikes, hand tricycles, and cargo bikes to accommodate individuals with disabilities and riders who cannot use a standard two-wheeled bike. While the majority of users prefer traditional bicycles, around 8% take advantage of these assistive options. Most Cyclistic riders use the service for leisure, although approximately 30% rely on it for daily commuting.

To date, Cyclistic’s marketing efforts have focused on generating general awareness and targeting broad consumer groups. A key element of this strategy has been the flexibility of its pricing plans, which include single-ride passes, full-day passes, and annual memberships. Customers who opt for single-ride or full-day passes are called casual riders, while those who purchase annual memberships are considered Cyclistic members.

Financial analysis reveals that annual members generate significantly more profit than casual riders. While the flexible pricing structure has been effective in attracting customers, Moreno, Cyclistic’s director of marketing, believes the company’s growth depends on increasing the number of annual memberships. Rather than focusing on acquiring entirely new customers, she sees an opportunity to convert casual riders into annual members, as these riders are already familiar with Cyclistic and use the service for their transportation needs.

Moreno has outlined a clear goal: develop marketing strategies to turn casual riders into annual members. To achieve this, the marketing analyst team needs to explore how annual members and casual riders differ, identify the factors that would encourage casual riders to purchase a membership, and assess the potential role of digital media in their marketing efforts. To support this, Moreno’s team plans to analyze historical bike trip data to uncover trends and actionable insights.

### Scenario
As a junior data analyst on Cyclistic’s marketing team in Chicago, my primary focus is helping the company achieve its goal of maximizing annual memberships. My team aims to understand how casual riders and annual members utilize Cyclistic’s services differently. These insights will guide the creation of a targeted marketing strategy to convert casual riders into members. However, before implementation, the recommendations must be validated with compelling data insights and professional data visualizations to gain executive approval.

## Ask
### Business Task
Analyze Cyclistic's historical bike trip data to identify trends and patterns in how casual riders and annual members use the service. This analysis aims to uncover insights that will guide the development of targeted marketing strategies to convert casual riders into annual members, thereby increasing overall profitability and supporting the company’s growth objectives.
### Analysis Questions
Questions that will guide the future marketing program:  
- Usage Patterns: How do casual riders and annual members differ in their usage of Cyclistic’s services (e.g., trip duration, time of use, popular routes)?
- Conversion Motivators: What factors might encourage casual riders to transition to annual memberships (e.g., cost savings, convenience, frequency of use)?
- Digital Media Impact: How can digital marketing channels and campaigns effectively influence casual riders to become annual members?

Moreno has assigned me the first question to answer: How do casual riders and annual members differ in their usage of Cyclistic’s services?

## Prepare
### Data Source
Cyclistic's historical trip data, covering the period from January 2023 to December 2023, will be utilized to analyze and identify trends. The dataset is publicly accessible and can be downloaded from [divvy_tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html). It has been provided by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement).

This data allows for an exploration of how different customer segments use Cyclistic's services. However, due to data privacy constraints, personally identifiable information about riders cannot be used. As a result, it is not possible to link pass purchases to credit card details to determine whether casual riders live within the Cyclistic service area or have purchased multiple single passes.

### Data Organization
The dataset has 12 files named according to the format YYYYMM-divvy-tripdata, with each file representing one month of data. The data includes key details such as ride ID, bike type, start and end times, start and end stations, geographic locations, and rider type (casual or member). The corresponding columns are labeled as ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, and member_casual.

## Process
To manage the dataset efficiently, BigQuery is employed for combining and cleaning the data.  
**Reason:**  
Microsoft Excel's worksheet capacity is limited to 1,048,576 rows, making it unsuitable for handling large datasets. With over 5.7 million rows of data, BigQuery offers the required scalability to manage such volumes effectively.

### Combining the Data
First I check if all tables share the same name and quantity of columns, then the data is merged using an SQL query. The 12 CSV files are uploaded to the dataset '2023_tripdata', and a new table named "2023_tripdata_combined" is created, consolidating 5,719,877 rows of data for the entire year.


![image](https://github.com/user-attachments/assets/dadc21ec-ec14-431c-87dc-107e2bb50e9b)


### Data Process and Exploration
I first examine the table structure, getting the column names datatypes. The __ride_id__ column will be my primary key.  


![image](https://github.com/user-attachments/assets/c129f893-35c0-41f1-a5f4-8a7a7076b340)
 

Then I check for number of null values in all columns. The notation COUNT(column_name) only considers rows where the column contains a non-NULL value. Also checking earliest and latest date for quality. 
   

![image](https://github.com/user-attachments/assets/fea3da6b-85d9-4e12-a406-e83f86f4b695)


I note that some columns have same number of missing values. So, this may be due to missing information in the same row i.e. station's name and id for the same station and latitude and longitude for the same ending station.

Finally, as ride_id has no null values, I'll use it to check for duplicates. 
No __duplicate__ rows were found.
   
All __ride_id__ values have length of 16 so no need to clean it.

Now I check the unique types of bikes(__rideable_type__) in our data.


![image](https://github.com/user-attachments/assets/ff596606-cbf1-4dae-a000-c5dee79c49ec)


The __started_at__ and __ended_at__ shows start and end time of the trip in YYYY-MM-DD hh:mm:ss UTC format. 

New column ride_length can be created to find the total trip duration. 

There are 6418 trips which has duration longer than a day and 151069 trips having less than a minute duration or having end time earlier than start time so need to remove them. Other columns day_of_week and month can also be helpful in analysis of trips at different times in a year.

Total of 875848 rows have both __start_station_name__ and __start_station_id__ missing which needs to be removed.  
Total of 929343 rows have both __end_station_name__ and __end_station_id__ missing which needs to be removed.
Total of 6990 rows have both __end_lat__ and __end_lng__ missing which needs to be removed.
The __member_casual__ column has 2 uniqued values as member or casual rider.

So, the columns that need to be removed are: start_station_id and end_station_id, as they do not add value, only the names are usefull. Longitude and latitude location columns may not be used in analysis but can be used to visualise a map.

### Data Cleaning

Here I create a new table, called 'new_2023_tripdata_combined' only incluiding rides duration that lasts longer than 1 minute and less than a day, using CASE on day_of_week and month for further analysis adding three new columns (ride_length, day_of_week and month), and deleting all missing values using WHERE IS NOT NULL. 
So, in total 1,476,445 rows are removed in this step.

Then I set ride_id as primary key, and use ROUND on ride_lenght to round minutes.
  
## Analyze 
SQL Query: [Data Analysis] 
  
The analysis question is: How do casual riders and annual members differ in their usage of Cyclistic’s services?  

#### User Segmentation Analysis
My first query shows a clear distinction between member and casual riders:


![image](https://github.com/user-attachments/assets/6988c4dc-dce6-495f-93e9-61fba5b2e6f0)



- Usage Volume: Members (2,738,451 rides) account for about 65% of total rides, while casual riders (1,504,981 rides) make up 35%. This indicates your subscription model is successfully capturing the majority of rides.

- Ride Duration: There's a striking difference in how these groups use the service. Casual riders take significantly longer trips (22.7 minutes on average) compared to members (11.89 minutes). This suggests members are primarily using the service for efficient, purposeful transportation like commuting, while casual riders are more likely using it for leisure, sightseeing, or recreation.

- Geographic Diversity: Members start their rides from more unique locations (940,972) than casual riders (563,932), indicating they use the system more widely across the service area. This suggests members integrate bike-sharing more thoroughly into their daily lives, while casual riders might concentrate around tourist attractions, parks, or popular destinations.


#### Bike Type Preferences
The second query reveals interesting equipment preferences:


![image](https://github.com/user-attachments/assets/4703b740-b4fb-45e8-a95f-7893fe50c40e)


- Casual Riders: Among casual riders, classic bikes are most popular (860,517 trips), followed by electric bikes (569,092 trips), with relatively few docked bike trips (75,372). The preference for classic bikes might indicate price sensitivity (if e-bikes cost more) or that many casual riders enjoy the exercise aspect of cycling.
- Members: Members also prefer classic bikes (1,788,516 trips) to electric bikes (949,935 trips), but the proportion of electric bike usage is higher among members (35%) than among casual riders (30%). This might suggest that members, who are using the system for more practical transportation, value the speed and reduced effort of e-bikes for their regular commutes.
- Docked Bikes: The presence of docked bikes only in the casual rider category might indicate a legacy system or special bikes available only at certain stations, potentially tourist-oriented locations.


#### Temporal Patterns
The third query (granular) mainly shows:

- Peak Usage Periods:
High ride counts are observed during working hours (7 AM to 7 PM) on weekdays, suggesting that many riders are commuting.
Weekends have relatively fewer morning rides but experience significant increases in the afternoon and early evening hours, indicating a focus on leisure activities.
Month-wise, summer and late spring months (e.g., June, July) exhibit higher ride volumes, correlating with favorable weather conditions and hollydays.

- Average Ride Duration (Ride Usage Trends)
Extended Rides:
Leisure hours, weekends, and evenings show higher average ride durations (sometimes exceeding 20–30 minutes). This pattern likely indicates casual riders using the service for exploration or recreational purposes.
Month-wise, ride durations tend to be higher in warm months (e.g., July and August), coinciding with leisurely activities.
Short Rides:
Commute-focused periods (weekday mornings and evenings) have shorter average durations (10–15 minutes), aligned with quick trips for work-related travel.

After the 3rd query, I broke the analysis into separate time focused queries, which offers several advantages:

Clarity of insights: Each focused query makes specific patterns more apparent and interpretable, monthly, weekly and daily.
Ease of visualization: The simpler queries are much easier to turn into clear, impactful charts.
Segmentation by user type: These queries add the crucial member/casual dimension that the third query lacks.
Different ordering priorities: Each query can order results to highlight different priorities (seasonal peaks, busiest days, etc.)

Monthly
![image](https://github.com/user-attachments/assets/34b87fc4-b2a8-47cc-8b5e-43f73dd99ca8)

Day of the week
![image](https://github.com/user-attachments/assets/46980013-47fa-482e-a841-83968e4876dd)

Hour of the day
![image](https://github.com/user-attachments/assets/48bdd48b-5bd3-429c-a536-295dc3fdebf9)



#### Duration distribution by user type. Median and Mean.
The previous queries gave me information about ride counts and average durations across different dimensions (user types, time periods, bike types). However, averages alone can be misleading when we have skewed distributions, which is common in ride duration data.
The next query addresses that limitation by calculating both the median and mean duration for each user type. This comparison tells me something fundamentally important about the data distribution:

Mean vs. Median Comparison
Casual Riders: Mean = 22.72 minutes, Median = 12 minutes
Member Riders: Mean = 11.89 minutes, Median = 8 minutes
Since the mean is higher than the median in both cases (especially for casual riders), it suggests that ride duration data is right-skewed, meaning some casual riders take very long rides that inflate the mean.

Understanding the Distribution Shape
The large gap between mean and median for casual riders suggests a subset of long rides is affecting the average.
Members have a smaller gap between mean and median, indicating a more consistent and predictable ride duration.

Operational and Business Implications
Bike Availability & Demand Planning: Since half of casual rides are under 12 minutes, but some are very long, planners need to factor in both typical and extreme cases for bike availability.
Pricing Strategy: If some casual riders are taking very long rides, you could explore whether they’re tourists or users misusing the system. Adjusting pricing (e.g., charging more for very long trips) could balance usage.
Potential Anomalies: Some casual rides might be so long that they indicate user forgetfulness (e.g., not ending trips properly). Investigating these cases could reduce operational inefficiencies.

As my goal is to explore trends by time (month, day, hour), the next queries with average duration in months, weeks and days are highly valuable.

#### Understanding station usage patterns and travel routes

Most Popular Start and End Stations:
- Identifies the most frequently used starting/ending stations for bike trips. 
- Differentiates usage casual vs. member.
- Provides approximate coordinates (average latitude and longitude) for mapping.
- Helps optimize bike distribution — more bikes should be available at high-traffic start stations at certain times. Therefore, also useful for expansion planning—if certain stations are frequently used, adding more bikes or stations nearby may improve service.
- Helps understand drop-off patterns—bikes should be rebalanced toward high-arrival stations.
- Useful for service adjustments, ensuring that stations with high arrivals have enough docking space.
- Helps in predicting future station placement needs.


![image](https://github.com/user-attachments/assets/ee192a48-2989-4b47-b77b-2a2851e44499)


![image](https://github.com/user-attachments/assets/4f154bec-8d97-4d28-9b1f-9d22f9c72e54)


Route Analysis
- Identifies the most frequently used routes.
- Shows trip counts to rank the most popular routes.
- Helps understand commuting behavior.
- Allows optimization of bike availability along popular routes.
- Useful for marketing and promotions—discounts or incentives can be targeted at specific routes.
- Supports infrastructure planning, like adding bike lanes along high-traffic routes.

![image](https://github.com/user-attachments/assets/aa509ecd-a2b6-4780-b066-fa989469c0c5)


### Summary:  
Casual riders tend to take longer trips on average, but their ride durations are highly variable, often influenced by outliers. They are more likely to ride on weekends and during warmer months, suggesting a preference for recreational or tourism-based cycling. In contrast, annual members take shorter, more consistent trips, with higher usage during weekdays and peak commuting hours, indicating a reliance on bike-sharing for daily transportation.

To convert casual riders into members, Cyclistic could offer targeted incentives such as discounted first-month memberships, loyalty rewards, or flexible pricing plans. Highlighting the cost savings of membership for frequent riders, improving convenience with station expansions, and offering perks like priority access or referral bonuses could also increase conversions. Additionally, promoting the benefits of membership through personalized marketing and in-app notifications at the end of casual trips may encourage sign-ups.

## Share
Data Visualization: [Tableau]
...relevant tables for the analysis and visualized them in Tableau.
  
## Act
After identifying the differences between casual and member riders, marketing strategies to target casual riders can be developed to persuade them to become members.  
Recommendations:  
1. Marketing campaigns might be conducted in spring and summer at tourist/recreational locations popular among casual riders.
2. Casual riders are most active on weekends and during the summer and spring, thus they may be offered seasonal or weekend-only memberships.
3. Casual riders use their bikes for longer durations than members. Offering discounts for longer rides may incentivize casual riders and entice members to ride for longer periods of time.
4. 
To convert casual riders into members, Cyclistic could offer targeted incentives such as discounted first-month memberships, loyalty rewards, or flexible pricing plans. Highlighting the cost savings of membership for frequent riders, improving convenience with station expansions, and offering perks like priority access or referral bonuses could also increase conversions. Additionally, promoting the benefits of membership through personalized marketing and in-app notifications at the end of casual trips may encourage sign-ups.
