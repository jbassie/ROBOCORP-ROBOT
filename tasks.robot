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
Library    RPA.Archive
Library    RPA.Robocorp.Vault
Library    RPA.Dialogs
Library    RPA.Email.ImapSmtp    smtp_server = smtp.gmail.com    smtp_port = 587
    

*** Variables ***
${OUTPUT_DIRECTORY}  = ${CURDIR}${/}output${/}
${USERNAME}    jsbazman@gmail.com
${PASSWORD}    #############
${RECIPIENT}    jsbazmab@gmail.com
@{ATTACHMENT}    ${OUTPUT_DIRECTORY}${/}orders_receipts.zip

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
        ${pdf}=    Store the reciept as a PDF file    ${row}[Order number]
        ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
        Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
        Go to order another robot
    END
    Create a Zip file for the reciept
    #Get data from user
    #Get site url from vault




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
    Wait Until Keyword Succeeds    20x   1s   Submit Order and Assert for Receipt

Submit Order and Assert for Receipt
    Click Button    id:order
    Page Should Contain Element    id:receipt

Store the reciept as a PDF file
    [Arguments]    ${Order number}
    Wait Until Element Is Visible    id:receipt
    ${robot_preview_html}=    Get Element Attribute    id:receipt    outerHTML
    Html To Pdf    ${robot_preview_html}    ${OUTPUT_DIR}${/}receipts_${Order number}.pdf
    [Return]     ${OUTPUT_DIR}${/}receipts_${Order number}.pdf

Take a screenshot of the robot
    [Arguments]    ${Order number}
    Screenshot    robot-preview-image    ${OUTPUT_DIR}${/}image_${Order number}.png
    [Return]     ${OUTPUT_DIR}${/}image_${Order number}.png

Embed the robot screenshot to the receipt PDF file 
    [Arguments]    ${screenshot}    ${pdf}
    #Open Pdf    ${pdf}
    Log    ${pdf}
    ${files}=    Create List    ${screenshot}
    Add Files To PDF    ${files}    ${pdf}    append=True
    #Close Pdf    ${pdf}

Go to order another robot
    Click Button When Visible    id:order-another

Create a Zip file for the reciept
    Archive Folder With Zip     folder=${OUTPUT_DIR}    archive_name=orders_receipts.zip  include=*.pdf

Send Email
    Authorize    account=${USERNAME}    password=${PASSWORD}
    Send Message    sender    recipients
    
    
    







    

