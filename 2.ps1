$global:logLocation="C:\Users\louis\logs"


function Write-Log($type, $message) {
    $filename ="MonLog-$(Get-Date -Format 'yyyyMMdd').log"
    $log = "$(Get-Date -Format 'yyyyMMdd-HH:mm:ss')>$type>$message"
    $log | Out-File -FilePath $global:logLocation"\"$filename -Append
}

function Set-RegKey($location, $key, $value) {
    
    New-ItemProperty -Path $location -Name $key -Value $value
    Write-Log "Regkey" "Creation path $location name $key value $value"
    
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
    $choiceArray = @("1","2","3")
  
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
        1 {$phrase = Read-Host "entrez une phrase à inverser"; Write-Log"info" "inversion";reverse($phrase)}
        2 {Write-Host "Bientôt disponible"}
        3 {Write-Log "info" "script exit";Exit 0}
    }

}
Write-Log("info","démarrage")
Set-RegKey "HKLM:\SOFTWARE" "Test-Version" "fr"


Write-Log("info","fin")

