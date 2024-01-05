# Git Guardian

## Description
"Git Guardian" est un script Bash conçu pour encourager de bonnes pratiques de versionnement avec Git. Il surveille activement l'état des modifications dans un dépôt Git et alerte l'utilisateur lorsque certaines limites prédéfinies sont dépassées.

## Fonctionnalités
- Vérification de la présence de Git sur le système.
- Comptabilisation des fichiers modifiés, des lignes modifiées et des fichiers non suivis.
- Alertes visuelles et compte à rebours pour inciter à la réalisation de commits.
- Réinitialisation automatique des modifications si elles ne sont pas commitées dans le délai imparti.

## Seuils Configurables
- Nombre maximum de fichiers modifiés ou non suivis : 10
- Nombre maximum de lignes modifiées : 100

## Utilisation
Pour utiliser "Git Guardian", suivez ces étapes :

1. **Configuration** :
   - Ouvrez le script `git-guardian.sh`.
   - Modifiez les variables `MAX_FILES_MODIFIED_OR_UNTRACKED` et `MAX_LINES_MODIFIED` selon les besoins de votre projet.

2. **Lancement du Script** :
   - Ouvrez un terminal.
   - Naviguez jusqu'au répertoire de votre dépôt Git.
   - Exécutez le script en saisissant la commande suivante :
     ```bash
     bash /chemin/vers/git-guardian.sh
     ```
     Remplacez `/chemin/vers/` par le chemin d'accès complet où se trouve le script `git-guardian.sh`.

3. **Surveillance en Action** :
   - Le script vérifie l'état de votre dépôt Git toutes les 30 secondes.
   - Si les seuils sont dépassés, une alerte visuelle apparaîtra avec un compte à rebours de 30 secondes.

## Précautions
- "Git Guardian" réinitialisera les modifications non commitées après un délai de 30 secondes si les seuils sont dépassés. 
- Utilisez ce script avec précaution pour éviter la perte de modifications importantes.

## Licence
[MIT License](LICENSE)