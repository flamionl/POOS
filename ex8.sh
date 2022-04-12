#!/bin/bash
function verbose {
    if [[ $1 -eq 1 ]]; then
        if [[ $2 == "mkdir" ]] 
        then
            echo "Création du répertoire $local_path"

        elif [[ $2 == "ftp" ]] 
        then
            echo "Récupération du fichier $file sur le serveur FTP"
        
        elif [[ $2 == "owner" ]]
        then
            echo "Création de l'utilisateur : $owner"
        elif [[ $2 == "chown" ]]
        then
            echo "Changement de permission du fichier $file avec la permission $filemode"
        elif [[ $2 == "chmod" ]]
        then
            echo "Changement de propriétaire pour le fichier $file avec le propriétaire $owner"
        fi
    fi



}

#Gestion des arguments
while getopts ":H:v" option
do
    case $option in 
        H)
            host=${OPTARG}
            ;;
        v)
            flag=1
            ;;
        *)
            echo "Unknown args"
            exit 1
            ;;
    esac
done
#On repasse $1 qui vaut l'emplacement du fichier
shift $((OPTIND -1))
#On vérifie qu'un fichier a bien été spécifié et que il existe 
if [[ $host == "" ]]; then
    echo "No host provided"
    exit 1
fi

if [[ $1 == "" ]]; then
    echo "Missing file"
    exit 1
fi

if [[ ! -e $1 ]]; then
    echo "File doesn't exist"
    exit 1
elif [[ ! -r $1  ]]; then
    echo "No read permission on file"
    exit 1
fi



##Parsing du fichier création des répertoires locaux, téléchargements des fichiers, owner et filemode
IFS=":"
while read local_path remote_path owner filemode; do
    #Création du répertoire local
    verbose "$flag" "mkdir"
    mkdir -p "${local_path}"  >/dev/null 2>&1
    


    #FTP
    dir=$(cut -d '/' -f 1 <(echo "$remote_path"))
    file=$(cut -d '/' -f 2 <(echo "$remote_path"))
    

    verbose "$flag" "ftp"
    ftp -n -p "$host" <<EOT
    user anonymous
    cd "$dir"
    get "$file"
    bye
EOT
    #Vérification si l'utilisateur existe si pas on le craye
    
    id "$owner" >/dev/null 2>&1
    if [[ $? -eq 1 ]] ; then
        verbose "1" "owner"
        useradd "$owner"
    fi

    mv "$file" "$local_path"
    verbose "$flag" "chown"
    chown "$owner:$owner" "$local_path"
    verbose "$flag" "chmod"
    chmod +"$filemode" "$local_path"
done < <(cut -d ':' -f 1,2,3,4  $1)
