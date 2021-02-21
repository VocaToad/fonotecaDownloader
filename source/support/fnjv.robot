*** Settings ***
Library    SeleniumLibrary    timeout=0:01:00
Library    Collections
Library    JSONLibrary
Library    OperatingSystem
Library    Process
Library    String
Variables    locators/fnjv.py

*** Variables ***
${animalsJsonFile}     animals.json

*** Keywords ***
Navigate to FNJV Site
    Go To    ${fnjvUrl}
    
Click On Sound Collection Link
    Wait Until Spinner is Not Visible
    Wait Until Element is Visible    ${soundCollectionLink}
    Click Element    ${soundCollectionLink}

Wait Until Spinner is Not Visible
    Wait Until Element Is Not Visible    ${spinner}

Expand Search Block
    Wait Until Element Is Visible    ${searchTitle}
    ${isNotVisible}    Run Keyword and Return Status    Element Should Not Be Visible    ${searchBlock}
    Run Keyword If    ${isNotVisible}    Click Element    ${searchTitle}

Click on Phylum Selector
    Wait Until Spinner is Not Visible
    Wait Until Element Is Visible    ${phylumSelector}
    Click Element    ${phylumSelector}

On Phylum Selector, Select Chordata Option
    Click on Phylum Selector
    Wait Until Element Is Visible    ${phylumSelectorResults}
    Wait Until Page Contains Element    ${chordataOption}
    Click Element    ${chordataOption}

Wait Until Class Spinner is Not Visible
    Wait Until Element Is Not Visible    ${classSpinner}

Click on Class Selector
    Wait Until Class Spinner is Not Visible
    Wait Until Element Is Visible    ${classSelector}
    Click Element    ${classSelector}

On Class Selector, Select Amphibia Option
    Click on Class Selector
    Wait Until Page Contains Element    ${amphibiaOption}
    Click Element    ${amphibiaOption}

Wait Until Order Spinner is Not Visible
    Wait Until Element Is Not Visible    ${orderSpinner}

Click on Order Selector
    Wait Until Order Spinner is Not Visible
    Wait Until Element Is Visible    ${orderSelector}
    Click Element    ${orderSelector}

On Order Selector, Select Anura Option
    Click on Order Selector
    Wait Until Page Contains Element    ${anuraOption}
    Click Element    ${anuraOption}
    
Click On Search Button
    Wait Until Element is Visible    ${searchButton}
    Click Element    ${searchButton}

Get Number Of Pages in Search Results
    Wait Until Element is Visible    ${numberOfPages}
    ${numberOfPages}    Get Text    ${numberOfPages}
    [Return]    ${numberOfPages}

Click On Next Page Button
    Wait Until Element Is Visible    ${nextPage}
    Sleep    2
    Click Element    ${nextPage}
    Sleep    2

Set Animal Exists
    [Arguments]    ${value}
    ${animalExists}    Set Variable    ${value}
    Set Test Variable    ${animalExists}

Set Animal Failed
    [Arguments]    ${value}
    ${animalfailed}    Set Variable    ${value}
    Set Test Variable    ${animalfailed}

Download All Records in Search Results
    ${animalData}    Load Previous Run
    ${numberOfPages}    Get Number Of Pages in Search Results
    ${animals}    Set Variable    ${animalData["animals"]}
    Set Animal Exists    ${false}
    Set Animal Failed    ${false}
    FOR    ${page}    IN RANGE    ${numberOfPages}
        Run Keyword If    ${page}<${animalData["page"]} and ${page}<${numberOfPages}-1    Click On Next Page Button
        Continue For Loop If    ${page}<${animalData["page"]}
        ${verifyAnimal}     Run Keyword If    ${page}==${animalData["page"]}    Set Variable    ${true}    ELSE    Set Variable    ${false}
        Set Test Variable    ${verifyAnimal}
        ${pageAnimals}    Download Animals in Page
        ${animals}    Combine Lists    ${animals}    ${pageAnimals}
        Run Keyword If    ${page}<${numberOfPages}-1    Click On Next Page Button
        Set To Dictionary    ${animalData}     animals=${animals}     page=${page}
        Create Animals Json    ${animalData}
        Run Keyword If    ${animalfailed}    Fail
    END

Load Previous Run
    ${animals}    Create List
    ${animalData}     Create Dictionary    page=0    animals=${animals}
    Set Test Variable    ${animalData}
    ${animalsJsonNotExist}     Run Keyword And Return Status     File Should Not Exist     ${animalsJsonFile}
    Return From Keyword If    ${animalsJsonNotExist}    ${animalData}
    ${animalData}    Load JSON From File    ${animalsJsonFile}
    Set Test Variable    ${animalData}
    [Return]    ${animalData}

Create Animals Json
    [Arguments]     ${animalsData}
    Create Json File    ${animalsData}     ${animalsJsonFile}

Create Json File
    [Arguments]    ${data}    ${filename}
    ${jsonString}     Convert JSON To String    ${data}
    Create File    ${OUTPUT_DIR}/${filename}    ${jsonString}    SYSTEM

Get Animals Count
    ${animals}    Get Element Count    ${tableRow}
    [Return]    ${animals}

Download Animals in Page
    ${animals}    Get Animals Count
    ${animalList}    Create List
    FOR    ${index}    IN RANGE    ${animals}
        Set Animal Exists     ${false}
        Set Test Variable    ${animalExists}
        Set Focus To Element    ${tableRow}:nth-child(${index+1})
        ${hasNotSound}    Run Keyword and Return Status     Page Should Not Contain Element    ${tableRow}:nth-child(${index+1})${audioButton}
        Continue For Loop If    ${hasNotSound}
        ${animalData}    Download Animal Data    ${tableRow}:nth-child(${index+1})
        Return From Keyword If    ${animalfailed}
        Continue For Loop If    ${verifyAnimal} and ${animalExists}
        Append To List    ${animalList}    ${animalData}
    END
    [Return]   ${animalList}

Download Animal Data
    [Arguments]     ${locator}
    Set Focus To Element    ${locator} td:nth-child(1)
    ${number}    Get Text    ${locator} td:nth-child(1)
    Verify If Record Exists    ${number}
    Return From Keyword If    ${animalExists}
    ${class}    Get Text    ${locator} td:nth-child(2)
    ${family}    Get Text    ${locator} td:nth-child(3)
    ${gender}    Get Text    ${locator} td:nth-child(4)
    ${species}    Get Text    ${locator} td:nth-child(5)
    ${popularName}    Get Text    ${locator} td:nth-child(6)
    ${individualData}    Get Individual Data    ${locator}
    Return From Keyword If    ${animalfailed}     
    ${animal}    Create Dictionary    number=${number}    class=${class}    family=${family}    gender=${gender}    species=${species}    popularName=${popularName}    individualData=${individualData}
    ${filename}    Write Animal Data File     ${animal}
    ${animalFile}    Create Dictionary    number=${number}     filename=${filename}
    [Return]    ${animalFile}

Verify If Record Exists
    [Arguments]    ${number}
    Return From Keyword If    not ${verifyAnimal}
    ${doesNotHaveRecords}    Run Keyword And Return Status    Dictionary Should Not Contain Key    ${animalData}    animals
    Return From Keyword If    ${doesNotHaveRecords}
    FOR     ${record}    IN    @{animalData["animals"]}
        ${isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${record["number"]}    ${number}
        ${animalExists}    Run Keyword If    ${isEqual}    Set Variable    ${true}    ELSE    Set Variable    ${false}
        Set Animal Exists    ${animalExists}
        Return From Keyword If    ${animalExists}
    END

Write Animal Data File
    [Arguments]    ${animal}
    Create Json File    ${animal}    ${animal["number"]}.json
    [Return]    ${animal["number"]}.json

Click on Individual Data
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator} td:nth-child(1)
    Click Element    ${locator} td:nth-child(1)

Individual Data Popup Must Be Opened
    Wait Until Element Is Visible    ${individualDataPopup}

Close Individual Data Popup
    Wait Until Element Is Visible    ${individualDataPopupCloseButton}
    ${passed}    Run Keyword And Return Status    Click Element    ${individualDataPopupCloseButton}
    ${animalfailed}    Run Keyword And Return Status     Should Not Be True    ${passed}
    Set Animal Failed     ${animalfailed}
    Return From Keyword If    ${animalfailed}
    Wait Until Element Is Not Visible    ${individualDataPopup}

Get Individual Data
    [Arguments]    ${locator}
    Click on Individual Data   ${locator}
    Individual Data Popup Must Be Opened
    ${individualInfo}    Get Individual Info
    ${registerInfo}    Get Register Info
    ${locationInfo}    Get Location Info
    ${audio}    Get Individual Audio
    Close Individual Data Popup
    ${individualData}    Create Dictionary    individual=${individualInfo}    register=${registerInfo}    location=${locationInfo}    audio=${audio}
    [Return]    ${individualData}

Get Individual Info
    ${individualInfo}    Get Popup Info    ${individualInfoHeader}
    [Return]     ${individualInfo}

Get Register Info
    ${registerInfo}    Get Popup Info    ${registerInfoHeader}
    [Return]     ${registerInfo}

Get Location Info
    ${locationInfo}    Get Popup Info    ${locationInfoHeader}
    [Return]     ${locationInfo}

Get Popup Info
    [Arguments]    ${header}
    Wait Until Element is Visible    ${header}
    Click Element    ${header}
    ${info}    Get Text    ${individualDataActiveContent}
    Click Element    ${header}
    Wait Until Element is Not Visible    ${individualDataActiveContent}
    [Return]     ${info}

Download From URL
    [Arguments]     ${url}
    ${urlList}    Split String    ${url}    separator=/
    ${filename}    Set Variable    ${urlList[-1]}
    ${fileExists}    Run Keyword and Return Status    File Should Exist    ${OUTPUT_DIR}/${filename}
    Run Keyword If   ${fileExists}    Remove File    ${OUTPUT_DIR}/${filename}
    Wait Until Removed    ${OUTPUT_DIR}/${filename}
    Run Process    wget     ${url}
    Wait Until Created   ${OUTPUT_DIR}/${filename}
    [Return]    ${OUTPUT_DIR}/${filename}

Get Individual Sound Specter
    Wait Until Element is Visible    ${individualSoundElement}
    ${soundSpecterUrl}    Get Element Attribute    ${individualAudioElement}    player_image
    ${soundSpecterPath}    Download From URL    ${soundSpecterUrl}
    ${specter}    Create Dictionary    url=${soundSpecterUrl}    file=${soundSpecterPath}
    [Return]    ${specter}

Get Individual Sound Audio
    Wait Until Element is Visible    ${individualSoundElement}
    ${soundAudioUrl}    Get Element Attribute    ${individualAudioElement}    src
    ${soundAudioPath}    Download From URL    ${soundAudioUrl}
    ${audio}    Create Dictionary    url=${soundAudioUrl}    file=${soundAudioPath}
    [Return]    ${audio}

Get Individual Audio
    ${soundSpecter}    Get Individual Sound Specter
    ${soundAudio}    Get Individual Sound Audio
    ${audio}    Create Dictionary    specter=${soundSpecter}    audio=${soundAudio}
    [Return]     ${audio}