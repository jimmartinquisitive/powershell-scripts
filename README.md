# powershell-scripts

A collection of PowerShell scripts designed to automate common administrative tasks in Azure Active Directory (Azure AD) and Microsoft 365.

## Description

This repository contains a suite of utility scripts for managing Azure AD resources. These scripts leverage the `AzureAD` and `Microsoft.Graph` PowerShell modules to perform bulk operations, such as resetting user passwords from a CSV file and exporting detailed user reports. They are intended for IT administrators and support personnel to streamline repetitive tasks, improve efficiency, and ensure consistency in user management.

## Features

*   **Bulk Password Reset:** Reset passwords for multiple Azure AD users simultaneously using a simple CSV input file.
*   **Secure Password Generation:** Includes a function to generate strong, random passwords with configurable length and complexity.
*   **User Data Export:** Export a comprehensive list of Azure AD users, including properties like `EmployeeType`, to a CSV file using the Microsoft Graph API.
*   **Flexible Filtering:** Scripts include commented-out examples for easily filtering data based on specific criteria (e.g., by employee type).
*   **Logging:** Outputs actions and results to both the console and a log file for auditing and review.

## Getting Started

Follow these instructions to get the scripts set up and running on your local machine.

### Prerequisites

Before you begin, ensure you have the following installed and configured:

*   **PowerShell:** Version 5.1 or later. PowerShell 7 is recommended for scripts using the `Microsoft.Graph` module.
*   **Administrator Permissions:** You will need an Azure AD account with appropriate administrative roles (e.g., Global Administrator, Password Administrator, or User Administrator) to execute these scripts.
*   **PowerShell Modules:** The scripts will attempt to install the required modules if they are not present. You can also install them manually:
    *   **Azure AD Module:**
        ```powershell
        Install-Module -Name AzureAD
        ```
    *   **Microsoft Graph Module:**
        ```powershell
        Install-Module -Name Microsoft.Graph
        ```

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/powershell-scripts.git
    ```
2.  **Navigate to the repository directory:**
    ```bash
    cd powershell-scripts
    ```
3.  Unblock the script files if necessary by running the following command in PowerShell:
    ```powershell
    Get-ChildItem -Path . -Recurse | Unblock-File
    ```

## Usage

Each script is designed for a specific task. Below are instructions on how to use them.

### `bulk_reset_passwords_from_CSV.ps1`

This script resets the passwords for Azure AD users listed in a CSV file.

1.  **Prepare the Input CSV:**
    Create a CSV file (e.g., `upn_list.csv`). The file must contain a header named `UserPrincipalName` in the first column, followed by the UPNs of the users whose passwords you want to reset.

    **Example `upn_list.csv`:**
    ```csv
    UserPrincipalName
    user1@yourdomain.com
    user2@yourdomain.com
    user3@yourdomain.com
    ```

2.  **Configure the Script:**
    Open `bulk_reset_passwords_from_CSV.ps1` in a text editor and update the following variables with your desired file paths:
    ```powershell
    # Define the path to the CSV file containing UPNs
    $csvFilePath = "C:\temp\upn_list.csv"

    # Define the output file path
    $outputFilePath = "C:\temp\passwords_output.txt"
    ```

3.  **Execute the Script:**
    Run the script from a PowerShell terminal. You will be prompted to authenticate with Azure AD.
    ```powershell
    .\bulk_reset_passwords_from_CSV.ps1
    ```

4.  **Review the Output:**
    The script will print the new password for each user to the console. A complete log, including new passwords and any users that were not found, will be saved to the file specified in `$outputFilePath` (e.g., `passwords_output.txt`).

### `get-aadusers-employeetype-graph.ps1`

This script exports a list of all Azure AD users and their properties to a CSV file using the Microsoft Graph API.

1.  **Configure the Script:**
    Open `get-aadusers-employeetype-graph.ps1` in a text editor and update the `$outputFilePath` variable:
    ```powershell
    # Define the output file path
    $outputFilePath = "C:\temp\AzureAD_User_Export.csv"
    ```

2.  **(Optional) Filter by Employee Type:**
    If you wish to export only users of a specific employee type, uncomment and modify the following lines:
    ```powershell
    # Define the employee type you want to filter (optional)
    $employeeTypeFilter = "Contractor" # Example: "Employee", "Contractor", "Vendor"

    # Filter users based on their employee type property (optional)
    $filteredUsers = $allUsers | Where-Object { $_.EmployeeType -eq $employeeTypeFilter }
    ```
    If you use the filter, make sure to comment out the line `$filteredUsers = $allUsers`.

3.  **Execute the Script:**
    Run the script from a PowerShell terminal. It will open a browser window or prompt you to authenticate with Microsoft Graph.
    ```powershell
    .\get-aadusers-employeetype-graph.ps1
    ```

4.  **Review the Output:**
    The script will create a CSV file at the specified path. The file will contain the `Id`, `DisplayName`, `UserPrincipalName`, and `EmployeeType` for each user.

## File Structure

```
.
├── bulk_reset_passwords_from_CSV.ps1   # Script to bulk reset Azure AD user passwords from a CSV file.
└── get-aadusers-employeetype-graph.ps1 # Script to export Azure AD users and their properties via MS Graph.
```