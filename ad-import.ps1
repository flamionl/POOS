$adcred = Get-Credential -UserName "LOUIS\Administrateur" -Message "Credentials required to join the pc to a domain"



Add-Computer -DomainName "louis.local" -Credential $cred -Restart 





New-ADOrganizationalUnit -Name "Professeurs" -Credential $cred -Path "DC=louis,DC=local"

New-ADOrganizationalUnit -Name "Etudiants" -Credential $cred -Path "DC=louis,DC=local"

New-ADOrganizationalUnit -Name "Administration" -Credential $cred -Path "DC=louis,DC=local"

 

$location = "C:\Users\vagrant\PowerShellSecure.csv"





$ADUsers = Import-Csv $location -Delimiter ";"



foreach ($User in $ADUsers) {

    $firstname = $User.firstname

    $lastname = $User.lastname

    $username = $User.username

    $departement = $User.departement

    $ou = $User.ou

    $cred = Get-Credential -UserName $username -Message "password for this user"

    $password = $cred.Password



    New-ADUser -Name $username -Enable true -GivenName $firstname -Surname $lastname -Department $departement -Path $ou -AccountPassword $password -Credential $adcred



}
