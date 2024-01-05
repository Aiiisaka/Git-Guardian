#!/bin/bash

# Fonction pour vérifier le statut des fichiers
check_files() {
    files_modified=$(git diff --name-only | wc -l)
    lines_modified=$(git diff | grep "^+" | wc -l)
    untracked_files=$(git status --porcelain | grep "^??" | wc -l)
    files_modified_or_untracked=$(($files_modified + $untracked_files))

    echo -e "\e[34mFichiers modifiés ou non suivis : $files_modified_or_untracked\e[0m"
    echo -e "\e[34mLignes modifiées : $lines_modified\e[0m"

    if [ "$files_modified_or_untracked" -ge $MAX_FILES_MODIFIED_OR_UNTRACKED ] || [ "$lines_modified" -ge $MAX_LINES_MODIFIED ]; then
        echo -e "\e[31mAttention : Il est temps de versionner vos modifications !\e[0m"
        return 1
    else
        echo -e "\e[32mTrès bien, continuez votre travail.\e[0m"
    fi

    return 0
}

# Variables d'environnement pour les seuils
MAX_FILES_MODIFIED_OR_UNTRACKED=10 # Nombre max de fichiers modifiés ou non suivis
MAX_LINES_MODIFIED=100 # Nombre max de lignes modifiées

# Vérification de l'installation de Git
if ! command -v git &> /dev/null; then
    echo -e "\e[31mGit n'est pas installé... Veuillez l'installer avant de continuer.\e[0m"
    exit 1
fi

while true; do
    check_files
    if [ $? -eq 1 ]; then
        echo -e "\e[33mVous avez 30 secondes pour commencer le versionnement...\e[0m"
        for i in {30..1}; do
            echo -ne "\r\e[33mTemps restant : $i secondes\e[0m"
            sleep 1
        done
        echo ""

        check_files
        if [ $? -eq 1 ]; then
            echo -e "\e[31mTrop tard ! Réinitialisation des modifications...\e[0m"
            git reset --hard
            git clean -f
        fi
    fi
    sleep 300 # Pause de 5 minutes
done