#!/bin/bash

# Variables d'environnement pour les seuils
MAX_FILES_MODIFIED_OR_UNTRACKED=10
MAX_LINES_MODIFIED=100

# Fonction pour formater le message en fonction du nombre
format_message() {
    local count=$1
    local singular=$2
    local plural=$3

    if [ "$count" -eq 1 ]; then
        echo -e "\e[34m$count $singular\e[0m"
    else
        echo -e "\e[34m$count $plural\e[0m"
    fi
}

# Fonction pour vérifier le statut des fichiers
check_files() {
    files_modified=$(git diff --name-only | wc -l)
    lines_modified=$(git diff | grep "^+" | wc -l)
    untracked_files=$(git ls-files -o | wc -l)
    files_modified_or_untracked=$(($files_modified + $untracked_files))

    format_message $files_modified_or_untracked "Fichier modifié ou non suivi" "Fichiers modifiés ou non suivis"
    format_message $lines_modified "Ligne modifiée" "Lignes modifiées"

    if [ "$files_modified_or_untracked" -ge $MAX_FILES_MODIFIED_OR_UNTRACKED ] || [ "$lines_modified" -ge $MAX_LINES_MODIFIED ]; then
        echo -e "\e[31mAttention : Il est temps de versionner vos modifications !\e[0m"
        echo -e "\e[31mVoici une aide pour vous guider :\e[0m"
        git status -s
        return 1
    else
        echo -e "\e[32mTrès bien, continuez votre travail.\e[0m"
    fi

    return 0
}

# Vérification de l'installation de Git
if ! command -v git &> /dev/null; then
    echo -e "\e[31mGit n'est pas installé... Veuillez l'installer avant de continuer.\e[0m"
    exit 1
fi

while true; do
    check_files
    if [ $? -eq 1 ]; then
        echo -e "\e[33m\e[5m⚠️ URGENT : Versionnez maintenant ! Vous avez 30 secondes... ⚠️\e[0m"
        for i in {30..1}; do
            echo -ne "\r\e[5m\e[41m\e[97mTemps restant : $i secondes\e[0m\e[25m"
            sleep 1
        done
        echo -e "\e[0m"

        check_files
        if [ $? -eq 1 ]; then
            echo -e "\e[31mTrop tard ! Réinitialisation des modifications...\e[0m"
            git reset --hard
            git clean -fd
        fi
    fi
    sleep 30 # Vérification toutes les 30 secondes
done