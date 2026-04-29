# Reset-LockedAccount.ps1
# Unlocks a locked Active Directory user account and forces
# password change on next logon. Used by Tier 1 during account
# lockout resolution.
#
# Usage: .\Reset-LockedAccount.ps1 -Username bac.rago

param (
    [Parameter(Mandatory=$true)]
    [string]$Username
)

Import-Module ActiveDirectory

try {
    Unlock-ADAccount -Identity $Username
    Set-ADUser -Identity $Username -ChangePasswordAtLogon $true
    Write-Host "Account unlocked: $Username" -ForegroundColor Green
    Write-Host "User must change password at next logon." -ForegroundColor Yellow
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
