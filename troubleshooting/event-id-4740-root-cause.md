# Root Cause Analysis: Event ID 4740 (Account Lockout)

## Symptom
A user reports they cannot log in. ADUC shows the account is locked. After unlock, the account locks again within minutes.

## Why This Happens
A device on the network is retrying old cached credentials in the background. Each failed retry counts toward the lockout threshold. Common culprits:

- Mapped network drive on a personal laptop after password change
- Saved credential in Outlook desktop client
- Mobile device with cached Exchange credentials
- Service account hardcoded in a scheduled task
- RDP session holding stale credentials

## Investigation Path

### Step 1: Confirm the lockout in ADUC
Open Active Directory Users and Computers on the Domain Controller. Locate the user. Properties > Account tab. Confirm "Unlock account" message is visible.

### Step 2: Pull Event ID 4740 from the DC
Open Event Viewer on the Domain Controller. Navigate to Windows Logs > Security. Filter for Event ID 4740. The event details show the locked account name, the domain, and the Caller Computer Name. The Caller Computer Name field identifies the machine that triggered the lockout. This is the single most important field on the help desk.

### Step 3: Pull Event ID 4625 from the source machine
Log on to the caller computer. Open Event Viewer. Filter Security log for Event ID 4625. Each entry shows the failure reason (typically "Unknown user name or bad password") and the calling process. This identifies which application is sending the stale credential.

### Step 4: Remediate at the source

| Source | Action |
|---|---|
| Outlook desktop | Credential Manager > Windows Credentials > remove stale entry |
| Mapped drive | net use [drive]: /delete then re-map with current credentials |
| Mobile device | Remove and re-add Exchange account |
| Saved RDP | mstsc /edit > clear saved credentials |
| Scheduled task | Update task with current service account password |

### Step 5: Confirm resolution
Unlock the account. Wait 15 minutes. Verify in Event Viewer that no new 4740 events appear and no new 4625 events from the previously offending source.

## Why This Matters
A help desk that just unlocks the account without investigating the source will see the same ticket again within an hour. A help desk that pulls Event ID 4740 and remediates at the source closes the ticket once.
