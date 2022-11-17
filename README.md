# DEPRECATED
This script is deprecated. Please use the following replacement instead: https://github.com/engrit-illinois/LabCheckProvision-LabOu.

# Summary
Takes the OU of a computer lab and adds sub-OUs and links existing GPOs to refactor for standardized remote desktop access, and COVID social distancing protocols.  
Full documentation is at https://wiki.illinois.edu/wiki/display/engritprivate/EWS+remote+access+to+Windows+labs  

# Usage
1. Download `Covidize-LabOU.psm1` to the appropriate subdirectory of your PowerShell [modules directory](https://github.com/engrit-illinois/how-to-install-a-custom-powershell-module).
    - The module is now already available for use with your regular account, however it needs to modify AD objects which you may only have access to do with your SU account. Make the module available as your SU account: see [here](https://github.com/engrit-illinois/how-to-run-custom-powershell-modules-as-another-user).
2. Run it: e.g. `Covidize-LabOU "OU=ECEB9999,OU=EWS,OU=Instructional,OU=Desktops,OU=Engineering,OU=Urbana,DC=ad,DC=uillinois,DC=edu"`

# Parameters

### -LabOUDN
Required string.  
The distinguished name of the OU to "Covidize".  

### -Uncovidize
Optional switch.  
Performs the reverse operations to the given lab OU as would be done by the script if `-Uncovidize` was not specified.  
All computers in sub-OUs are moved to the root lab OU.  

### -Delay
Optional integer.  
Number of seconds that the script waits between creating an OU and linking GPOs to it.  
This allows time for the changes to sync to the domain controllers, so that the script doesn't end up trying to link a GPO to an OU that doesn't exist.  
Default is `30`.  

# Notes
- Must be run as your SU account.
- By mseng3. See my other projects here: https://github.com/mmseng/code-compendium.
