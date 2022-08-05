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
    ${orders}=    Get Orders
    FOR    ${row}    IN     @{orders}
        Close the annoying modal
        Fill the form    ${row}
        Preview the Robot
        Submit the order
    END





*** Keywords ***
Open the robot website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Get Orders
    Download    https://robotsparebinindustries.com/orders.csv    overwrite= True
    ${orders}=    Read table from CSV    orders.csv
    Log    Found columns: ${orders.columns}

Close the annoying modal
    Wait And Click Button    OK

Reading the form
    [Arguments]    ${orders}
    Select All From List    head    ${orders}[Head]
    Select Radio Button    body   ${orders}[Body]
    Input Text    1659719686644    ${orders}[Legs]
    Input Text    address    &{orders}[Address]


Fill the form
    ${orders}=    Read table from CSV    orders.csv
     FOR    ${orders}    IN    @{orders}
        Reading the form     ${orders}
    END
    
Preview the Robot
    Click Button   preview

Submit the order
    Click Button    order
    Wait Until Keyword Succeeds    1 min    1 sec    Submit the order






    

