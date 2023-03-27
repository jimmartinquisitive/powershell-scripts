# Run once only to install the microsoft graph api powershell cmdlet. Runs best in powershell 7
Install-Module -Name Microsoft.Graph

# Import the Microsoft.Graph module if not already imported
Import-Module Microsoft.Graph

# Connect to Microsoft Graph with the required scope
Connect-MgGraph -Scopes "User.Read.All"

# Define the output file path
$outputFilePath = "<Output_File_Path>.csv"

# Define the employee type you want to filter (optional)
#$employeeTypeFilter = "<Employee_Type_Here>"

# Get all users from Azure AD, including the EmployeeType property
$allUsers = Get-MgUser -All -Select "Id,DisplayName,UserPrincipalName,EmployeeType"

# Filter users based on their employee type property (optional)
#$filteredUsers = $allUsers | Where-Object { $_.EmployeeType -eq $employeeTypeFilter }

# Returns all users if not using the $employeetypefilter filter. Comment out this line and uncomment the line above if using the $employteetypefilter
$filteredUsers = $allUsers

# Select the properties you want to include in the CSV file
$selectedProperties = $filteredUsers | Select-Object Id, DisplayName, UserPrincipalName, EmployeeType

# Export the user list to a CSV file
$selectedProperties | Export-Csv -Path $outputFilePath -NoTypeInformation

# Output the filtered users (optional)
$selectedProperties
