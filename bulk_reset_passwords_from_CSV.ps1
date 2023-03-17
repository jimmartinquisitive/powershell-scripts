# Install AzureAD module if not installed
if (-not (Get-Module -Name AzureAD)) {
    Install-Module -Name AzureAD
}

# Connect to Azure AD
Connect-AzureAD

# Define the path to the CSV file containing UPNs
$csvFilePath = "C:\temp\upn_list.csv"

# Define the output file path
$outputFilePath = "C:\temp\passwords_output.txt"

# Import the CSV file
$upnList = Import-Csv -Path $csvFilePath

function New-RandomPassword {
    param (
        [int]$length = 12,
        [int]$numberOfNonAlphanumericCharacters = 2
    )

    $lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    $uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $digits = "0123456789"
    $nonAlphanumericChars = "!@#$%^&*_-+="

    # Ensure at least one of each character type
    $password = -join (Get-Random -InputObject $lowercaseLetters.ToCharArray()) +
               -join (Get-Random -InputObject $uppercaseLetters.ToCharArray()) +
               -join (Get-Random -InputObject $digits.ToCharArray()) +
               -join ($nonAlphanumericChars.ToCharArray() | Get-Random -Count $numberOfNonAlphanumericCharacters)

    # Add random alphanumeric characters to reach the desired length
    $remainingLength = $length - ($numberOfNonAlphanumericCharacters + 3)
    $alphanumericChars = $lowercaseLetters + $uppercaseLetters + $digits
    $password += -join ($alphanumericChars.ToCharArray() | Get-Random -Count $remainingLength)

    # Shuffle the characters in the password
    $password = -join ($password.ToCharArray() | Get-Random -Count $password.Length)
    return $password
}

# Loop through each UPN in the CSV file
foreach ($upn in $upnList) {
    # Get the user object based on UPN
    $user = Get-AzureADUser -ObjectId $upn.UserPrincipalName

     if ($user) {
        # Generate a new random password
        $newPassword = New-RandomPassword -length 18 -numberOfNonAlphanumericCharacters 6
        $newSecurePassword = ConvertTo-SecureString -String $newPassword -AsPlainText -Force

        # Update the user's password
        Set-AzureADUserPassword -ObjectId $user.ObjectId -Password $newSecurePassword -ForceChangePasswordNextLogin $false

        # Output the new password and write it to the output file
        $outputMessage = "User $($upn.UserPrincipalName) password has been reset to: $newPassword"
        Write-Output $outputMessage
        $outputMessage | Out-File -FilePath $outputFilePath -Append
    } else {
        # Write the warning to the console and the output file
        $warningMessage = "User $($upn.UserPrincipalName) not found in Azure AD."
        Write-Warning $warningMessage
        $warningMessage | Out-File -FilePath $outputFilePath -Append
    }
}

# Disconnect from Azure AD
Disconnect-AzureAD