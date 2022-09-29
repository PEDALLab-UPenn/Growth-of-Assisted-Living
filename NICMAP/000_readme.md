# New Document
**README file for posted estimation files**

**"**** Growth of Private Pay Senior Housing Communities in Metropolitan Statistical Areas in the United States: 2015–2019 "**

by Katherine E. M. Miller, Jiayi Zhao, Liisa T. Laine, and Norma B. Coe

**Overview:**

Before running the code:

- Copy file contents into personal folder on HSRDC
- Change the file path of the data and output global statements at the beginning of each .do file to the location of the project folder

Once these changes have been made, running the file labeled "1\_DataSet\_Construction" will construct the analytic data set; running the file labeled "2\_Tables" file will produce the tables corresponding to the manuscript; and running the file labeled "3\_Figure" will create the figure for the manuscript.

For questions about the code, please contact Katherine Miller (Katherine.miller@pennmedicine.upenn.edu).

**Data required:**

First, NIC-MAP data permissions will be required. Three files from NIC-MAP will be used. The Property Segment Level Inventory file includes the type of care (nursing care, assisted living, independent living, continuing care retirement community) at the property-quarter of the year level. The Property Traits Across Time includes the property type (majority nursing care, majority assisted living, majority independent living) and ownership characteristics (e.g., for profit status and chain status). The NICMAP\_Property\_Inventory includes geographic data of the property (e.g., county, state) as well as month opened.

Second, researchers will need the publicly available Area Health Resource File dataset at the year-county level to capture the population estimates aged 65+ and the number of skilled nursing facility beds.

**Running the code:**

This code is for Stata, and has been verified to run in version 16. The maptile package is required to produce the maps.

**Description of files:**

The following describes how the files correspond to the inputs and output:

| File | Description | Inputs/Outputs | Notes |
| --- | --- | --- | --- |
| 1\_DataSet\_Construction.do | Cleans and merges all raw data files | Inputs:<br/> Property Segment Level Inventory Data 2Q2020.xlsx<br/>NICMAP\_Property\_Inventory\_2Q2020.xlsx<br/>ALF\_states\_Medicaid.xlsx<br/>PopEstimates65+.dta<br/>Property Traits Across Time 2Q2020.xlsx <br/><br/>Output: <br/>AnalyticDataset\_R&R\_REPLICATION.dta | Only edit the global statements |
| 2\_Tables.do | Creates summary statistics | Input: <br/>AnalyticDataset\_R&R\_REPLICATION.dta<br/>Output: Tables 1 - 3 | Only edit the global statements |
| 3\_Figure.do | Creates maps for manuscript | Input: <br/>AnalyticDataset\_R&R\_REPLICATION.dta<br/>Output: Figure 1 | Only edit the global statements |
