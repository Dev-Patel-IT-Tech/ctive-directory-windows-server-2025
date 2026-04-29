# Runbook: Password Reset

## Trigger
User forgot password or password has expired.

## Resolution

1. Verify identity of the requester
2. Open ADUC on DC-1
3. Locate the user account
4. Right-click and select Reset Password
5. Enter a temporary password meeting complexity requirements
6. Tick "User must change password at next logon"
7. Tick "Unlock the user's account" if applicable
8. Click OK
9. Communicate temporary password to user via secure channel (phone callback, never email)
10. Confirm user logged in and changed password successfully

## Notes
Never share temporary passwords over email in plain text. Always confirm requester identity before performing a reset, particularly for privileged accounts.
