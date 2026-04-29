# Runbook: DNS Record Cutover

## Trigger
A server migration or service relocation requires updating an internal DNS A-record. Users report they cannot reach the service after the change.

## Resolution

### Updating the record
1. Open DNS Manager on DC-1
2. Expand Forward Lookup Zones, navigate to the zone (mydomain.com)
3. Right-click the affected A-record, Properties
4. Update the IP address
5. Click OK and verify the new value in the zone

### Validating client resolution
Users will continue resolving the old IP until their local DNS cache expires or is flushed. To remediate at the client, run these commands in PowerShell:

ipconfig /displaydns | Select-String -Pattern "mainframe" -Context 0,6

ipconfig /flushdns

ping mainframe

nslookup mainframe

## Why This Matters
The user's report ("I cannot reach the new server after IT made a change") sounds like a connectivity or firewall issue. It is almost always a stale DNS cache. ipconfig /flushdns is the first action.

## Escalation
If users continue resolving the old IP after a cache flush, validate that the change has propagated on all DNS servers in the zone and that the user's machine is using the correct DNS server (ipconfig /all).
