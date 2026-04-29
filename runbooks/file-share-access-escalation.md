# Runbook: File Share Access Request

## Trigger
User reports they cannot access a shared folder on the file server.

## Resolution

1. Confirm the share exists and is reachable from a domain-joined machine (\\DC-1\sharename)
2. Check share permissions: Right-click folder, Properties, Sharing, Advanced Sharing, Permissions
3. Check NTFS permissions on the Security tab
4. Identify the security group controlling access (e.g., ACCOUNTANTS for the accounting share)
5. In ADUC, add the user to the appropriate group
6. Inform user they must log off completely and log back on for the change to take effect
7. Confirm access after re-login

## Critical Note: Kerberos Token Refresh
Group membership changes do not apply until the user starts a new logon session. The Kerberos security token issued at logon is cached for the duration of the session. A user added to a group at 10:00 AM will not see the change until they log off and back on.

This is the most commonly mishandled file share ticket. The user reports "I was added to the group but I still cannot access the folder" and the help desk re-checks permissions when the actual fix is "log off and log back on".

## Escalation
If access remains denied after re-login and group membership is confirmed, validate effective permissions via Advanced Security Settings > Effective Access tab and escalate to Tier 2.
