# Powershell-Host-Scanning

Coded By Ender Phan

Written in Powershell 5.0

Operating System: Windows Server 2012 

# Introduction

- Host discovering with port scanning and Services, OS detection
- Finding directory of website
- Reverse IP Domain name lookup

# Usage

## discover.ps1

- StartScanIP
- EndScanIP
- Ports

## request.ps1

- url
- ip 


# Guide

## Requirements

Power shell version 5.0

## discover.ps1
+ Command: 

    `.\discover.ps1 -StartScanIP 193.40.194.102 -EndScanIP 193.40.194.110 -Port 80,443,22`

## request.ps1
+ Command to scan directory:

     `.\request.ps1 -url http://google.com/`
     
+ Command to reverse domain name lookup:

     `.\request.ps1 -ip 192.168.0.10`
