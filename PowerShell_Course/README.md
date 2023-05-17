# PowerShell Course Curriculum

*This document contains information about each of the PowerShell course sections including the goal of each project, an estimated time frame, and a non-exhaustive list of the concepts involved while making them.*

![PowerShell Icon](https://raw.githubusercontent.com/drummermanrob20/Misc/main/resources/PowerShell_Core_6.0_icon.png)
## <img src="https://raw.githubusercontent.com/drummermanrob20/Misc/main/resources/shell.prompt.icon2.png" width="25"/> Starting Automatic Services (3 hours)

- Explore the shell by discovering what is necessary to find all services with an automatic startup type and get them started 
- Use PowerShell ISE to translate the interactive command into a basic script that can be run which also outputs the services that were started 
- Concepts involved 
  - Basic cmdlets 
  - Help and discovery systems 
  - Objects and members 
  - Pipeline 
  - Filtering 
  - $_ 
  - “Dot syntax” 
  - Selective output 
  - Variable string concatenation for output 
  - Basic script development, running scripts, and execution policy

## <img src="https://raw.githubusercontent.com/drummermanrob20/Misc/main/resources/shell.prompt.icon2.png" width="25"/> Interlude - Scripting Environment, Version Control, and Collaboration (2 hours) 

- VS Code
  - Why we need to care about where and how we develop 
  - Setting up VS Code 
  - Exploring common shortcuts 
  - Installing plugins/extensions (PowerShell Extension Pack by Justin Grote)
- Git
  - Why we need to care about version control 
  - How does version control work? 
  - Setting up Git 
  - Explore how we can use Git through VS Code extensions and commands 
- GitHub 
  - Why you need to care about collaboration and how it is best accomplished 
  - Setting up GitHub accounts 
  - Setting up GitHub extensions in VS Code 
  - Push the local repository to a remote repository

## <img src="https://raw.githubusercontent.com/drummermanrob20/Misc/main/resources/shell.prompt.icon2.png" width="25"/> Server Info Report (4 hours) 

- Learn how to extrapolate various data points from multiple sources on multiple systems, combine them into desired, digestible data, and present them in a format that can be handed off.  Information gathered will include the server's name, operating system version, number of logical drives, number of shares, and free on the system drive measured in gigabytes.  We will also include a piece of information chosen by the participants. 
- Concepts involved 
  - Variables
  - Custom object creation
  - Hash tables
  - Gathering basic AD information
  - Custom object properties
  - PowerShell remoting
  - Controlling errors
  - Parallelization
  - Exporting data

## <img src="https://raw.githubusercontent.com/drummermanrob20/Misc/main/resources/shell.prompt.icon2.png" width="25"/> Create Microsoft 365 User (2 hours) 

- Reference script [here](https://github.com/OpsChasingDev/Microsoft365/blob/main/Create.User.ps1)
- Explore what it takes to create a user account in Microsoft 365. 
- Concepts involved 
  - Module discovery and installation 
  - Reading and storing user input 
  - Splatting

## <img src="https://raw.githubusercontent.com/drummermanrob20/Misc/main/resources/shell.prompt.icon2.png" width="25"/> Script Maturity and Safeguards (4 hours) 

- We will revisit our earlier project “Create Microsoft 365 User” and make modifications to formalize and parameterize this script as well as add safety features to prevent accidental change.  As a final stage, we will add an option in the script to take input from a CSV file of information instead of requiring user input from parameters. 
- Concepts involved 
  - Enabling safety measures on scripts that make changes like “-Confirm” and “-WhatIf” 
  - Parameterization 
  - Parameter sets 
  - Taking input from existing, persistent data sources like CSV files

## <img src="https://raw.githubusercontent.com/drummermanrob20/Misc/main/resources/shell.prompt.icon2.png" width="25"/> What’s Next? (1 hour) 

- Demonstrating other components of PowerShell’s capabilities 
  - Making web calls to APIs to show how, given the capability is available, PowerShell can work with all kinds of information systems
  - Working with providers to do things like parse xml files 
  - Introducing the use of AI and machine learning tools
- Concepts involved 
  - Using “Invoke-RestMethod” on open-source REST API demos 
  - Showing API calls to our ticketing system using authenticated web calls
  - Using AI and machine learning tools properly to save time