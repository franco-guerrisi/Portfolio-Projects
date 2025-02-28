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
First I check if all tables share the same name and quantity of columns, then the data is merged using an SQL query. The 12 CSV files are uploaded to the dataset '2023_tripdata', and a new table named "combined_data" is created, consolidating 5,719,877 rows of data for the entire year.


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

![image](https://github.com/user-attachments/assets/20253bbf-7ca9-49a5-b2a1-fb85821aeafd)


6. The __started_at__ and __ended_at__ shows start and end time of the trip in YYYY-MM-DD hh:mm:ss UTC format. New column ride_length can be created to find the total trip duration. There are 5360 trips which has duration longer than a day and 122283 trips having less than a minute duration or having end time earlier than start time so need to remove them. Other columns day_of_week and month can also be helpful in analysis of trips at different times in a year.
7. Total of 833064 rows have both __start_station_name__ and __start_station_id__ missing which needs to be removed.  
8. Total of 892742 rows have both __end_station_name__ and __end_station_id__ missing which needs to be removed.
9. Total of 5858 rows have both __end_lat__ and __end_lng__ missing which needs to be removed.
10. __member_casual__ column has 2 uniqued values as member or casual rider.

    ![image](https://user-images.githubusercontent.com/125132307/226212522-aec43490-5d86-4e2e-a92e-b3bf52050415.png)

11. Columns that need to be removed are start_station_id and end_station_id as they do not add value to analysis of our current problem. Longitude and latitude location columns may not be used in analysis but can be used to visualise a map.

### Data Cleaning
SQL Query: [Data Cleaning](https://github.com/SomiaNasir/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/blob/main/03.%20Data%20Cleaning.sql)  
1. All the rows having missing values are deleted.  
2. 3 more columns ride_length for duration of the trip, day_of_week and month are added.  
3. Trips with duration less than a minute and longer than a day are excluded.
4. Total 1,375,912 rows are removed in this step.
  
## Analyze and Share
SQL Query: [Data Analysis](https://github.com/SomiaNasir/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/blob/main/04.%20Data%20Analysis.sql)  
Data Visualization: [Tableau](https://public.tableau.com/app/profile/somia.nasir/viz/bike-tripdata-casestudy/Dashboard1#1)  
The data is stored appropriately and is now prepared for analysis. I queried multiple relevant tables for the analysis and visualized them in Tableau.  
The analysis question is: How do annual members and casual riders use Cyclistic bikes differently?  

First of all, member and casual riders are compared by the type of bikes they are using.  

![image](https://user-images.githubusercontent.com/125132307/226692931-ecd2eb32-ffce-481a-b3c2-a6c3b4f3ceb7.png)
  
The members make 59.7% of the total while remaining 40.3% constitutes casual riders. Each bike type chart shows percentage from the total. Most used bike is classic bike followed by the electric bike. Docked bikes are used the least by only casual riders. 
  
Next the number of trips distributed by the months, days of the week and hours of the day are examined.  
  
![image](https://user-images.githubusercontent.com/125132307/230122705-2f157258-e673-4fc5-bbed-88050b6aae68.png)
![image](https://user-images.githubusercontent.com/125132307/230122935-8d0889c3-f0ff-43ce-94ab-393f2e230bee.png)
  
__Months:__ When it comes to monthly trips, both casual and members exhibit comparable behavior, with more trips in the spring and summer and fewer in the winter. The gap between casuals and members is closest in the month of july in summmer.   
__Days of Week:__ When the days of the week are compared, it is discovered that casual riders make more journeys on the weekends while members show a decline over the weekend in contrast to the other days of the week.  
__Hours of the Day:__ The members shows 2 peaks throughout the day in terms of number of trips. One is early in the morning at around 6 am to 8 am and other is in the evening at around 4 pm to 8 pm while number of trips for casual riders increase consistently over the day till evening and then decrease afterwards.  
  
We can infer from the previous observations that member may be using bikes for commuting to and from the work in the week days while casual riders are using bikes throughout the day, more frequently over the weekends for leisure purposes. Both are most active in summer and spring.  
  
Ride duration of the trips are compared to find the differences in the behavior of casual and member riders.  
  
![image](https://user-images.githubusercontent.com/125132307/230164787-3ea46ee9-aa5f-486b-9dd1-8f43dfce8e1c.png)  
![image](https://user-images.githubusercontent.com/125132307/230164889-1c7943d2-7ada-411b-adc7-a043eb480ba1.png)
  
Take note that casual riders tend to cycle longer than members do on average. The length of the average journey for members doesn't change throughout the year, week, or day. However, there are variations in how long casual riders cycle. In the spring and summer, on weekends, and from 10 am to 2 pm during the day, they travel greater distances. Between five and eight in the morning, they have brief trips.
  
These findings lead to the conclusion that casual commuters travel longer (approximately 2x more) but less frequently than members. They make longer journeys on weekends and during the day outside of commuting hours and in spring and summer season, so they might be doing so for recreation purposes.    
  
To further understand the differences in casual and member riders, locations of starting and ending stations can be analysed. Stations with the most trips are considered using filters to draw out the following conclusions.  
  
![image](https://user-images.githubusercontent.com/125132307/230248445-3fe69cbb-30a9-42c6-b5e8-ab433a620ff3.png)  
  
Casual riders have frequently started their trips from the stations in vicinity of museums, parks, beach, harbor points and aquarium while members have begun their journeys from stations close to universities, residential areas, restaurants, hospitals, grocery stores, theatre, schools, banks, factories, train stations, parks and plazas.  
  
![image](https://user-images.githubusercontent.com/125132307/230253219-4fb8a2ed-95e3-4e52-a359-9d86945b7a75.png)
  
Similar trend can be observed in ending station locations. Casual riders end their journay near parks, museums and other recreational sites whereas members end their trips close to universities, residential and commmercial areas. So this proves that casual riders use bikes for leisure activities while members extensively rely on them for daily commute.  
  
Summary:
  
|Casual|Member|
|------|------|
|Prefer using bikes throughout the day, more frequently over the weekends in summer and spring for leisure activities.|Prefer riding bikes on week days during commute hours (8 am / 5pm) in summer and spring.|
|Travel 2 times longer but less frequently than members.|Travel more frequently but shorter rides (approximately half of casual riders' trip duration).|
|Start and end their journeys near parks, museums, along the coast and other recreational sites.|Start and end their trips close to universities, residential and commercial areas.|  
  
## Act
After identifying the differences between casual and member riders, marketing strategies to target casual riders can be developed to persuade them to become members.  
Recommendations:  
1. Marketing campaigns might be conducted in spring and summer at tourist/recreational locations popular among casual riders.
2. Casual riders are most active on weekends and during the summer and spring, thus they may be offered seasonal or weekend-only memberships.
3. Casual riders use their bikes for longer durations than members. Offering discounts for longer rides may incentivize casual riders and entice members to ride for longer periods of time.
