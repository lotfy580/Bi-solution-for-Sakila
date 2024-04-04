# End-to-End Bi-solution-for-Sakila

<img src="https://github.com/lotfy580/Bi-solution-for-Sakila/blob/main/Project%20Map.png"></img>


In this project, I implemented a Business Intelligence (BI) solution for a DVD rental store. My approach began with designing and implementing multiple transactional systems for the business, utilizing MySQL, PostgreSQL, SQL Server databases, and CSV files. I then proceeded to generate data for these Online Transaction Processing (OLTP) systems.

Following this, I designed and implemented a centralized data warehouse powered by the SQL Server engine. Integration of data from various sources into the data warehouse was achieved through the Extract, Transform, Load (ETL) method using SQL Server Integration Services (SSIS).

Additionally, I implemented a multidimensional database (cube) to analyze the data using SQL Server Analysis Services (SSAS). This enabled me to build insightful reports using SQL Server Reporting Services (SSRS).

Finally, I leveraged Power BI and Tableau to generate interactive dashboards, providing stakeholders with intuitive visualizations and insights derived from the analyzed data.

## 01) Desgin and implementaion of databases
### ERD & Mapping
<div>
  <img src="https://raw.githubusercontent.com/lotfy580/Bi-solution-for-Sakila/main/03_OLTP%20implementation%20and%20Queries/P01_Database%20ERD.jfif" width=600></img>
  <img src="https://github.com/lotfy580/Bi-solution-for-Sakila/blob/main/03_OLTP%20implementation%20and%20Queries/P02_Database%20mapping.png" width=320></img>
</div>

### Implemntaiton on SQL-Server
<img src="https://github.com/lotfy580/Bi-solution-for-Sakila/blob/main/03_OLTP%20implementation%20and%20Queries/P03_Database%20diagram%20SQL-Server.png"></img>

### MySQL
<img src="https://github.com/lotfy580/Bi-solution-for-Sakila/blob/main/03_OLTP%20implementation%20and%20Queries/P04_Database%20diagram%20MySQL.png"></img>

### PostgreSQL
<img src="https://github.com/lotfy580/Bi-solution-for-Sakila/blob/main/03_OLTP%20implementation%20and%20Queries/P05_Database%20Diagram%20PostgreSQL.png"></img>
for more about code check the OLTP implemetaion folder in the repository




## 02) Data warehouse Design 
<img src="https://github.com/lotfy580/Bi-solution-for-Sakila/blob/main/04_Data%20Warehouse/Sakila_DWH.png"></img>

### Introduction

A data warehouse is a specialized database designed to store historical data from various sources, primarily for analytical purposes. In our approach, we will construct our data warehouse using dimensional modeling, specifically utilizing a star schema.
To ensure the effectiveness of our design, we will follow specific steps to achieve a well-structured architecture. Firstly, we'll identify the business use cases, understanding the specific analytical needs and objectives of the organization. Next, we'll determine the grain of our data, which essentially defines the level of detail at which we will store our measures. This involves identifying the most detailed level of data relevant to our analytical objectives.
Following this, we'll proceed to identify the dimensions that provide context to our measures, answering questions such as What, When, Where, and by Whom. These dimensions will form the backbone of our dimensional model, providing the necessary context for meaningful analysis. Lastly, we'll pinpoint the measures we need to track and analyze. These measures represent the key metrics or performance indicators that will populate our fact table(s), capturing the quantitative data points essential for analysis and reporting.
By systematically following these steps, we aim to create a data warehouse design that is optimized for analytical purposes, providing the organization with valuable insights and facilitating informed decision-making.

### Define business use cases

To discern our business use cases, it's imperative to comprehend the business processes that warrant tracking within our data warehouse. Our business operations unfold in distinct steps: a customer visits a particular store, requests to rent a specific DVD from a designated staff member, subsequently returns the DVD after a defined duration, and settles the rental payment to same/another staff member.

In order to ascertain the requirements for tracking and storing these processes effectively, we must gather pertinent information regarding the customer, store, staff member, film, as well as the commencement and conclusion dates of the rental period, and the payment transaction date. This comprehensive dataset will equip us with the necessary insights to accurately capture and analyze the intricacies of our business operations.

### Identify the grain
In our business operations, the most granular level of detail lies within the transaction where a customer rents a DVD film.

### Design Dimensions 
Dimensions primarily aim to address key questions such as "what?", "where?", "when?", and "by whom?" In our context:
<div>•	"What?" pertains to the film of the rented DVD.</div>
<div>•	"Where?" denotes the specific store where the transaction occurred.</div>
<div>•	"When?" signifies both the start and end dates of the rental period.</div>
<div>•	"Who?" encompasses both the customer and staff involved in the transaction.</div>
<div>                  .                     </div>
<div>For the Film dimension, it encompasses several multi-valued attributes such as Features, Category, and Actors. For Features and Category, due to their relatively low count numbers, we can horizontally scale them within the dimFilm table.</div>
<div></div>However, in the case of Actors, where there are approximately 200 different individuals, it is impractical to include them directly in the dimFilm table. Therefore, we need to create another dimension specifically for Actors and establish a linkage with the Film dimension using a factless or bridge table. This approach allows us to efficiently manage and query data related to actors while maintaining a well-structured dimensional model.</div>



### Design fact table
In our business case, the main measures we need to track are payments and the accumulated transactions occurring between rental and payment. Typically, this would necessitate two separate fact tables: one for tracking business transactions and another for accumulated processes. However, in our scenario, we can consolidate these into a single fact table. This unified fact table can effectively track both measures, as payments align with the granularity of the entire business process. Since payments cannot be measured at a lower level of granularity, merging the two fact tables simplifies the design.
However, this integration presents a challenge: some transactions in the accumulated fact may not yet have a corresponding payment, resulting in null payment amounts. This is acceptable because aggregation functions handle nulls as expected. Additionally, we can introduce a binary column indicating whether the rental has been paid for, facilitating filtering and payment count calculations

## 3) ETL
ETL, or Extract Transform Load, is a methodology used to manage data flow. It involves three key phases:

<div>Extraction: Data is gathered from various sources.</div>
<div>Transformation: The data is processed and cleaned to align with the structure and quality standards of the data warehouse, as defined by the team.</div>
<div>Loading: The processed data is then loaded into the data warehouse for storage and analysis.</div>
<div>.</div>


To accomplish this task, I utilized SSIS, a widely used ETL tool developed by Microsoft. Known for its ease of use, practicality, and extensive feature set, SSIS streamlines the extraction, transformation, and loading processes, making data management more efficient and effective 
