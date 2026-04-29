# Runbook: Account Lockout Investigation

## Trigger
User reports they cannot log in. Receives "account locked" message.

## Resolution

1. Verify identity of the requester (callback, badge, manager confirmation as required by policy)
2. Open Active Directory Users and Computers on DC-1
3. Locate the user account
4. Right-click and select Properties, then the Account tab
5. Tick the "Unlock account" checkbox
6. Click Apply and OK
7. Advise user to attempt login

## If Account Locks Again Immediately
See troubleshooting/event-id-4740-root-cause.md for full root cause investigation procedure.

## Key Event IDs
- 4740: Account lockout (DC Security log)
- 4625: Failed login (client Security log)
- 4767: Account unlocked (DC Security log)

## Escalation
If lockout source cannot be identified or account continues to lock after credential update at source machine, escalate to Tier 2 with the Event 4740 caller computer name and the Event 4625 details.
