#Trouver la commande de base dont les alias sont dir et ls
Get-Alias
#Créer une variable, et stocker dans cette variable le retour de la commande du point a
$a = Get-Alias
#Afficher le contenu de la variable du point b.
$a
#Récupérer le type de donnée stocké dans votre variable
$a.GetType()
#Si votre variable est de type System.Array, alors n'afficher que le premier element
$a[0]
#Récupérer l’ensemble des méthodes et propriétés associées à votre variable
$a | Get-Member
#Créer une variable et socker un chiffre et ensuite faire un Get-Member
$a = 54
$a | Get-Member
#Trouvez la commande qui permet de sortir le code dans un fichiers, le verb étant out
Get-Command -Verb out
$a | Out-File -FilePath .\out.txt

#Recherche de fichier

#Lister les éléments d'un dossier
ls 
Get-ChildItem
#Filtrer pour n'obtenir que les éléments avec l'extension .txt
Get-ChildItem -Filtrer '*.txt'
#Filtrer pour obtenir tous les fichiers commençant par Re et possédant l’extension .pdf
Get-ChildItem -Filter '*.pdf' | Where-Object {$_.Name -match '^Re'}

#Ordonner votre recherche par ordre de dernière modification croissante
Get-ChildItem -Filter '*.pdf' | Where-Object {$_.Name -match '^Re'}  | Sort-Object LastWriteTime

#Gestion des processus

#Ouvrez plusieurs applications NotePad
#Stockez dans une variable l'ensemble des processus NotePad
$my_var = Get-Process notepad
#Lister les propriétés et les méthodes disponibles pour votre variable
$my_var | Get-Member
#Afficher le nombre d'éléments dans votre variable
$my_var.Count
#Supprimer le premier processus stocké dans votre variable
$my_var[0].Kill
#Stopper l'ensemble des processus lancés
$my_var | ForEach-Object Kill
#Recherchez l'ensemble des propriétés affichables pour un processus
Get-Process | Get-Member | findstr 'Property'
#Afficher tous les processus commençant par la lettre c, sélectionner id, nom, utilisation CPU Heure de démarrage
Get-Process c* | select name, CPU, Id, StartTime
#Afficher le résultat sous forme de List, et ensuite sous forme de tableau
Get-Process c* | select name, CPU, Id, StartTime | Format-List
Get-Process c* | select name, CPU, Id, StartTime | Format-Table

#Sur base d'un fichier texte, vous devez créer, les répertoires.
$var = Get-Content .\file.txt
New-Item $var -Type Directory