*** Settings ***
Documentation       Orders Robot From RobotSpareBin Industries Inc.
...                 Saves the Order HTML reciept as a PDF File
...                 Saves the Screenshot of the Ordered Robot
...                 Embeds the Screenshot of the robot the PDF reciept
...                 Creates ZIP archive of the reciept and the images.

Library    RPA.Browser
Library    RPA.HTTP
Library    RPA.Tables
Library    RPA.PDF

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
        Submit the order
        ${pdf}=    Store the reciept as a PDF file    ${row}[Order number]
        #${screenshot}=    Take a screenshot of the robot    ${row}[Order number]

    END





*** Keywords ***
Open the robot website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Get Orders
    Download    https://robotsparebinindustries.com/orders.csv    overwrite= True
    ${orders}=    Read table from CSV    orders.csv

    [Return]    ${orders}
    #Log    Found columns: ${orders.columns}

Close the annoying modal
    Click Button    Yep

Fill the form
    [Arguments]     ${orders}
    Select From List By Value    head    ${orders}[Head]
    Select Radio Button    body   ${orders}[Body]
    Input Text   //input[@type= "number"]    ${orders}[Legs]
    Input Text    address    ${orders}[Address]

Preview the Robot
    Click Button   preview

Submit the order
    Click Button    order
    Wait Until Keyword Succeeds    1 min    1 sec    Submit the order

Store the reciept as a PDF file
    [Arguments]    ${Order Number}
    Wait Until Element Is Visible    id:reciept
    ${robot_preview_html}=    Get Element Attribute    id:reciept    outerHTML
    Html To Pdf    ${robot_preview_html}    ${OUTPUT_DIR}${/}${Order Number}.pdf

#Take a screenshot of the robot
    
    







    

