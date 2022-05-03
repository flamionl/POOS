$global:logLocation="C:\Users\Administrateur\logs"
$ErrorActionPreference = "stop"
function Read-Reg($location) {
    $choice =  Read-Host "Do you want to output the result to a file (y/n)"
    while($choice -notin @("y","Y","n","N")) {
             $choice = Read-Host "Do you want to output the result to a file (y/n)"
    }
    try 
    {
        If(($choice -eq "y") -or ($choice -eq "Y")) 
        {
            Get-ItemProperty "$location" | Select * -Exclude PS* | Out-File -FilePath "C:\Users\Administrateur\logs\regkey" -Append
        }else 
        {
            Get-ItemProperty "$location" | Select * -Exclude PS*
        }
    }
    catch
    {
        Write-Host "Wrong reg path"

    }



}
function addActiveDirectory()
{
    $name = Read-Host "Name"
    $givenName = Read-Host "First Name"
    $surname = Read-Host "Surname"
    $samAccount = Read-Host "SamAccountName"
    $userPrincipaleName = Read-Host "Username"
    $password = Read-Host -AsSecureString "Password"
    
    New-ADUser -Name "$name" -GivenName "$givenName" -SurName "$surname" -SamAccountName "$samAccount" -UserPrincipalName "$userPrincipalName" -AccountPassword $password -Enabled 1




}

function Write-Log($type, $message) {
    $filename ="MonLog-$(Get-Date -Format 'yyyyMMdd').log"
    $log = "$(Get-Date -Format 'yyyyMMdd-HH:mm:ss')>$type>$message"
    $log | Out-File -FilePath $global:logLocation"\"$filename -Append
}

function Set-RegKey($location, $key, $value) {
    try 
    {
        New-ItemProperty -Path $location -Name $key -Value $value
        Write-Log "Regkey" "Creation path $location name $key value $value"

    }
    catch 
    {
        Write-Host "Key already exist"
        $choice = Read-Host "Do you want to edit the key (y/n)"
        while($choice -notin @("y","Y","n","N")) {
             $choice = Read-Host "Do you want to edit the key (y/n)"
        }
        If(($choice -eq "y") -or ($choice -eq "Y")) 
        {
            $value = Read-Host "Value : "
            Set-ItemProperty -path "$location" -name "$key" -value "$value" 
        }
    }
    finally
    {
        menu

    }
    
}



function reverse ($phrase){
    $charArray = $phrase.Split(" ")
    $reversedPhrase = ""
    foreach($element in $charArray)
    {
        $reversedArray=$element.ToCharArray()
        [array]::Reverse($reversedArray)
        $reversedPhrase += -join($reversedArray)
        $reversedPhrase += " "
        
    }
    Write-Host($reversedPhrase) -ForegroundColor green
}
function menu {
    $choice = Read-Host "Quelle action souhaitez-vous faire"
    $choiceArray = @("1","2","3","4","5")
  
    while($choice -notin $choiceArray) {
        
        $choice = Read-Host "Quelle action souhaitez-vous faire"
        Write-Host @"
        1. Inverser une phrase
        2. Ajouter des clés de registre
        3. Fermer le programme
"@

    }
    $choice = [int]$choice
    switch ($choice) {
        1 {$phrase = Read-Host "entrez une phrase à inverser"; Write-Log "info" "inversion"; reverse($phrase)}
        2 {$key = Read-Host "Entrez une clé"; $value = Read-Host "Entrez une valeur";Set-RegKey "HKLM:\SOFTWARE" "$key" "$value"}
        3 {Write-Log "info" "script exit";Exit 0}
        4 {$location = Read-Host "Enter regkey location"; Read-Reg $location}
        5 {addActiveDirectory}
    }

}
Write-Log "info" "démarrage"
menu 

#Set-RegKey "HKLM:\SOFTWARE" "Test-Version" "fr"


Write-Log "info" "fin"

