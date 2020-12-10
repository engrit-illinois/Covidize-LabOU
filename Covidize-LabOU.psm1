# Documentation home: https://github.com/engrit-illinois/Covidize-LabOU
# By mseng3

function Covidize-LabOU {

	param(
		[string]$LabOUDN,
		[int]$Delay=30
	)
	
	function log($msg) {
		Write-Host $msg
	}
	
	function Delay {
		log "    Waiting $Delay seconds for DC sync..."
		Start-Sleep -Seconds $Delay
	}
	
	function Make($name, $parent) {
		$ou = "OU=$name,$parent"
		#log "    Making ou: `"$ou`"..."
		
		if(Test-OUExists $parent) {
			log "    Parent OU exists."
			
			if(Test-OUExists $ou) {
				"    OU already exists."
			}
			else {
				New-ADOrganizationalUnit -Name $name -Path $parent | Out-Null
				log "    Done."
				Delay
			}
		}
		else {
			log "    Parent OU doesn't exist: `"$parent`"!"
		}
	}
	
	function Link($name, $ou) {
		if(Test-GPOLinked $name $ou) {
			log "    GPO already linked."
		}
		else {
			New-GPLink -Name $name -Target $ou | Out-Null
			log "    Done."
			#Delay
		}
	}
	
	function Test-OUExists($ou) {
		#log "Testing if ou exists: `"$ou`"..."
		try {
			Get-ADOrganizationalUnit -Identity $ou | Out-Null
			#log "    OU exists."
			$ouExists = $true
		}
		catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
			#log "    OU does not exist."
			$ouExists = $false
		}
		$ouExists
	}
	
	function Test-GPOLinked($gpo, $ou) {
		# https://community.spiceworks.com/topic/2197327-powershell-script-to-get-gpo-linked-to-ou-and-its-child-ou
		$links = Get-ADOrganizationalUnit $ou | Select -ExpandProperty LinkedGroupPolicyObjects
		$guids = $links | ForEach-Object { $_.Substring(4,36) }
		$names = ($guids | ForEach-Object { Get-GPO -Guid $_ | Select DisplayName }).DisplayName
		$result = $names -contains $gpo
		$result
	}
	
	if(Test-OUExists $LabOUDN) {
		
		$labOuParts = $LabOUDN.Split(",")
		$lab = $labOuParts[0].Split("=")[1]
		log "Lab OU name determined to be `"$lab`"."
		
		
		
		# Root lab OU
		log "Linking background GPO to root lab OU..."
		Link "ENGR EWS COVID Local-Only Desktop-Lockscreen Background" $LabOUDN
		
		log "Linking login message GPO to root lab OU..."
		Link "ENGR EWS COVID Local-Only Login Message" $LabOUDN
		
		
		
		# RemoteEnabled sub-OU
		$remoteEnabled = "RemoteEnabled"
		$remoteEnabledOu = "OU=$remoteEnabled,$LabOUDN"
		
		log "Creating $remoteEnabled OU..."
		Make $remoteEnabled $LabOUDN
		
		log "Linking access GPO to $remoteEnabled OU..."
		Link "ENGR EWS $lab RDU" $remoteEnabledOu
		
		log "Linking background GPO to $remoteEnabled OU..."
		Link "ENGR EWS General Lab Desktop-Lockscreen Background" $remoteEnabledOu
		
		log "Linking login message GPO to $remoteEnabled OU..."
		Link "ENGR EWS COVID Remote-Enabled (i.e. no) Login Message" $remoteEnabledOu
		
		
		
		# LocalLoginDisabled (i.e. Remote-Only) sub-OU
		$localDisabled = "LocalLoginDisabled"
		$localDisabledOu = "OU=$localDisabled,$remoteEnabledOu"
		
		log "Creating $localDisabled OU..."
		Make $localDisabled $remoteEnabledOu
		
		log "Linking access GPO to $localDisabled OU..."
		Link "ENGR EWS Restrict local login to admins" $localDisabledOu
		
		log "Linking background GPO to $localDisabled OU..."
		Link "ENGR EWS COVID Remote-Only Desktop-Lockscreen Background" $localDisabledOu
		
		log "Linking login message GPO to $localDisabled OU..."
		Link "ENGR EWS COVID Remote-Only Login Message" $localDisabledOu
	}
	
	log "EOF"
}