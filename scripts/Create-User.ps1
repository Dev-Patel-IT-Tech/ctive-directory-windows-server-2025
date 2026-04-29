# Create-User.ps1
# Bulk provisions Active Directory user accounts from a name list
# into the _EMPLOYEES OU. Designed for new-hire onboarding at scale.
#
# Usage: Place names.txt in the same directory (one "first last" per line)
# and run from PowerShell ISE as a Domain Admin.

$PASSWORD_FOR_USERS = "Password1"
$USER_FIRST_LAST_LIST = Get-Content .\names.txt
$count = 1

foreach ($n in $USER_FIRST_LAST_LIST) {
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()
    $username = "$($first).$($last)"
    $password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan

    New-AdUser -AccountPassword $password `
        -GivenName $first `
        -Surname $last `
        -DisplayName $username `
        -Name $username `
        -EmployeeID $username `
        -PasswordNeverExpires $true `
        -Path "ou=_EMPLOYEES,$(([ADSI]``"``").distinguishedName)" `
        -Enabled $true

    $count++
}
