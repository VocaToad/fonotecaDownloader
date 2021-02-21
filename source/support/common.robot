*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${browser}=    firefox

*** Keywords ***
Start Browser
    Set Selenium Timeout    00:01:00
    Open Browser    browser=${browser}