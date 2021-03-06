# Summary
Takes the OU of a computer lab and adds sub-OUs and links existing GPOs to refactor for standardized remote desktop access, and COVID social distancing protocols.  
Full documentation is at https://wiki.illinois.edu/wiki/display/engritprivate/EWS+remote+access+to+Windows+labs  

# Usage
1. Download `Covidize-LabOU.psm1`
2. Import the script as a module: `Import-Module "c:\path\to\Covidize-LabOU.psm1"`
3. Run it: e.g. `Covidize-LabOU "OU=ECEB9999,OU=EWS,OU=Instructional,OU=Desktops,OU=Engineering,OU=Urbana,DC=ad,DC=uillinois,DC=edu"`

# Parameters

### -LabOUDN
Required string.  
The distinguished name of the OU to "Covidize".  

### -Delay
Optional integer.  
Number of seconds that the script waits between creating an OU and linking GPOs to it.  
This allows time for the changes to sync to the domain controllers, so that the script doesn't end up trying to link a GPO to an OU that doesn't exist.  
Default is `30`.  

# Notes
- Must be run as your SU account.
- By mseng3. See my other projects here: https://github.com/mmseng/code-compendium.
