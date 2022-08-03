*** Settings ***
Documentation       Orders Robot From RobotSpareBin Industries Inc.
...                 Saves the Order HTML reciept as a PDF File
...                 Saves the Screenshot of the Ordered Robot
...                 Embeds the Screenshot of the robot the PDF reciept
...                 Creates ZIP archive of the reciept and the images.

Library    RPA.Browser
Library    RPA.HTTP
Library    RPA.Tables

*** Tasks ***
Minimal task
    Log    Done.

Order Robot From RobotSpareBin
    Open the robot website
    Get Orders




*** Keywords ***
Open the robot website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Get Orders
    Download    https://robotsparebinindustries.com/orders.csv    overwrite= True
    ${table}=    Read table from CSV    orders.csv
    Log    Found columns: ${table.columns}



    

