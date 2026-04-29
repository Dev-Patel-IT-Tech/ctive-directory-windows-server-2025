# Active Directory on Windows Server 2025 (Azure)

Production-style Windows Server 2025 Active Directory domain deployed on Microsoft Azure. The environment serves 11,367 provisioned identities across a delegated organizational unit structure, with Group Policy enforced security, authoritative DNS, NTFS-controlled file shares, and full Tier 1 / Tier 2 operational scenarios documented end-to-end.

Every workflow in this repository maps to a recurring help desk ticket: account lockout investigation, password reset, file share access escalation, DNS change management, and identity lifecycle from onboarding through offboarding.

## Architecture

Identity and infrastructure components:

- Domain Controller DC-1 running Windows Server 2025 Datacenter
- Member workstation Client-1 running Windows Server 2025 Datacenter
- Single forest, single domain (mydomain.com)
- Azure Virtual Network 10.0.0.0/24 in Canada Central
- Static private IPs (DC-1: 10.0.0.4, Client-1: 10.0.0.6)
- Authoritative DNS hosted on the domain controller

## Environment

| Component | Detail |
|---|---|
| Cloud Platform | Microsoft Azure (Canada Central) |
| Domain Controller | Windows Server 2025 Datacenter |
| Client Endpoint | Windows Server 2025 Datacenter |
| VM Size | Standard_D2s_v3 |
| Domain | mydomain.com |
| Network | 10.0.0.0/24 Virtual Network |
| Identity Population | 11,367 user accounts |
| Privileged Account | dev_admin (Domain Admin) |

## Capabilities Delivered

1. Centralized identity for 11,367 users provisioned via PowerShell automation into a delegated OU structure (_ADMINS, _CLIENTS, _EMPLOYEES, _Groups)

2. Group Policy enforced account lockout at five invalid logon attempts, validated end-to-end across the domain

3. Authoritative DNS administration including A-record cutover, cache invalidation, and CNAME alias resolution

4. NTFS file share permission model across four shares with security group based access control and Kerberos token refresh validation

5. Full account lifecycle operations: provision, lock, unlock, reset, disable, re-enable

6. Root-cause analysis of authentication failures via Windows Event Log correlation (Event ID 4740 on Domain Controller, Event ID 4625 on client)

## Operational Scenarios Executed

### Account Lockout Investigation (Tier 1 / Tier 2)
Triggered five failed authentication attempts to enforce GPO lockout. Identified locked account in ADUC. Pulled Event ID 4740 from the Domain Controller Security log to identify Caller Computer Name as the source of the lockout. Unlocked the account and forced password change at next logon.

Runbook: [runbooks/account-lockout-investigation.md](runbooks/account-lockout-investigation.md)

### DNS Change Management (Tier 2)
Created an A-record for an internal mainframe host pointing to 10.0.0.4. Updated the record to 8.8.8.8 to simulate a server migration. Validated client-side stale cache via ipconfig /displaydns. Cleared the resolver cache and confirmed updated resolution. Created and validated a CNAME alias resolving to an external host using nslookup.

Runbook: [runbooks/dns-record-cutover.md](runbooks/dns-record-cutover.md)

### File Share Access Escalation (Tier 1 / Tier 2)
Provisioned four NTFS shares (read-access, write-access, no-access, accounting) on the file server. Created the ACCOUNTANTS security group and granted Read/Write on the accounting share. Validated that Kerberos ticket caching requires a fresh logon session before group membership changes take effect, which is the most commonly mishandled file share ticket on a help desk.

Runbook: [runbooks/file-share-access-escalation.md](runbooks/file-share-access-escalation.md)

### Identity Lifecycle (Tier 1)
Performed full lifecycle operations on a test account: provisioned in _EMPLOYEES, locked via failed logons, unlocked in ADUC with simultaneous password reset, disabled to simulate offboarding, validated authentication denial from the client, and re-enabled to simulate return-from-leave.

## Security and Compliance

- Account Lockout Policy: lockout after 5 invalid attempts, 30-minute lockout duration, 10-minute reset counter
- OU-delegated administration enforcing least-privilege scoping for the dev_admin account
- Security group based file share access (ACCOUNTANTS) rather than direct ACL grants on user accounts
- Disabled accounts validated to deny authentication at the client (Remote Desktop Connection)

## Observability and Troubleshooting

| Event ID | Source | Meaning |
|---|---|---|
| 4740 | DC Security log | A user account was locked out |
| 4625 | Client Security log | An account failed to log on |
| 4767 | DC Security log | A user account was unlocked |
| 4624 | Either | Account logged on successfully |

Validation commands used in this environment:

ipconfig /displaydns | Select-String -Pattern "mainframe" -Context 0,6
ipconfig /flushdns
nslookup search
Get-ADUser -Filter * -SearchBase "OU=_EMPLOYEES,DC=mydomain,DC=com" | Measure-Object
Unlock-ADAccount -Identity bac.rago
gpresult /r
gpupdate /force

## Repository Layout

- README.md
- runbooks/ (account-lockout-investigation.md, password-reset.md, file-share-access-escalation.md, dns-record-cutover.md)
- scripts/ (Create-User.ps1, Reset-LockedAccount.ps1)
- screenshots/ (36 annotated operational screenshots)
- troubleshooting/ (event-id-4740-root-cause.md)

## Tooling

PowerShell ISE, Active Directory Users and Computers, Group Policy Management Console, DNS Manager, Event Viewer, Azure Portal, Remote Desktop Protocol.

## About

Maintained by Dev Patel, IT Support Specialist based in the Greater Toronto Area. Targeting Help Desk, Service Desk, and Desktop Support roles across the GTA. Open work permit valid through February 2029.

LinkedIn: linkedin.com/in/devpatel-itsupport
Email: devpatel6217@gmail.com
