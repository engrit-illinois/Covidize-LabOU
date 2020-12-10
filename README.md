Takes the OU of a computer lab and adds sub-OUs and links existing GPOs to refactor for standardized remote desktop access, and COVID social distancing protocols.

This script is only for Instructional use. Full documentation is at https://wiki.illinois.edu/wiki/display/engritprivate/EWS+remote+access+to+Windows+labs

# Instructions
1. Download `Covidize-LabOU.psm1`
2. Import the script as a module: `Import-Module "c:\path\to\Covidize-LabOU.psm1"`
3. Run it: e.g. `Covidize-LabOU "OU=ECEB9999,OU=EWS,OU=Instructional,OU=Desktops,OU=Engineering,OU=Urbana,DC=ad,DC=uillinois,DC=edu"`

By default the script waits 30 seconds between creating an OU and linking GPOs to it, to allow time for the changes to sync to the domain controllers. If this delay isn't long enough, you can change it using the `-Delay` parameter: e.g. `Covidize-LabOU -Delay 45 -LabOUDN "OU=ECEB9999,OU=EWS,OU=Instructional,OU=Desktops,OU=Engineering,OU=Urbana,DC=ad,DC=uillinois,DC=edu"`

# Notes
- Must be run as your SU account.
- By mseng3