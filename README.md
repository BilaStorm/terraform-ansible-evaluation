# TP Évaluation — CI/CD + Docker + IaC (Terraform) + Automatisation (Ansible)

## Objectif
Industrialiser le déploiement d’une application web **locale** :
1) Conteneuriser l’app (Dockerfile)
2) Provisionner l’infra locale avec Terraform (provider Docker)
3) Automatiser le déploiement/config avec Ansible
4) Proposer une chaîne CI/CD (GitHub Actions ou simulation locale)

> ⚠️ Ce dépôt est un **starter**. Certaines parties sont volontairement incomplètes.

## Ce qui est fourni
- Une application Flask minimale dans `app/` (**sans Dockerfile**).
- Une structure d’infrastructure : `infra/terraform/`, `infra/ansible/`.
- Un squelette de workflow GitHub Actions (CI) qui doit devenir fonctionnel.

## Pré-requis
- Docker Desktop / Docker Engine
- Terraform >= 1.5
- Ansible >= 2.15 (Windows : WSL2 recommandé)
- Git

## Consignes de rendu
- Tout doit être versionné (commits réguliers).
- Aucune étape manuelle après lancement du déploiement automatisé.
- Fournir un README final expliquant :
  - build de l’image
  - déploiement Terraform
  - configuration/déploiement Ansible
  - vérification (healthcheck)
  - limites + améliorations


## Démarrage (app en local, sans Docker)
```bash
cd app
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
# puis: curl http://localhost:5000/health
```

## À faire (checklist)
### 1) Docker
- [ ] Créer `app/Dockerfile`
- [ ] Ajouter un `.dockerignore`
- [ ] Build + run :
  - `docker build -t tp-app:latest app/`
  - `docker run -p 8080:5000 tp-app:latest`
- [ ] Vérifier : `curl http://localhost:8080/health`

### 2) Terraform (local / Docker provider)
- [ ] Définir un réseau Docker
- [ ] Déployer un reverse proxy (Nginx) exposé sur `localhost:8080`
- [ ] Déployer le conteneur app sur le même réseau
- [ ] Outputs : url, noms de conteneurs, etc.

### 3) Ansible
- [ ] Automatiser le déploiement (idempotent)
- [ ] Variables d’environnement (APP_ENV, PORT)
- [ ] Vérification post-déploiement (commande ou task)

### 4) CI/CD (au choix)
- [ ] GitHub Actions : build image + vérif + (optionnel) déploiement
  ou
- [ ] Simulation locale documentée (script + README)

## Structure
```text
app/
infra/
  terraform/
  ansible/
.github/workflows/
docs/
```



# TP Évaluation — Documentation/Livrable

## Synthèse du Projet

Ce projet automatise le déploiement d'une application web Python (Flask) derrière un serveur web Nginx. L'objectif est de fournir une infrastructure reproductible, sécurisée et testée automatiquement, sans aucune intervention manuelle ni dépendance au Cloud public.



## Points clés de l'architecture :

### Infra as Code
Terraform gère le cycle de vie Docker (Réseau, Images, Conteneurs).

### Configuration Centralisée
Le fichier nginx.conf est situé dans app/ et monté dynamiquement. C'est la "Single Source of Truth".

### Idempotence
Le playbook Ansible peut être relancé à l'infini sans casser l'état.

### DevSecOps
Pipeline CI incluant Linter (Flake8) et Scan de vulnérabilités (Trivy).

## Nouvelle Structure
```text
.github/
  workflows/
    ci.yml/
app/
  app.py/
  Dockerfile/
  nginx.conf/
docs/
  evalutation/
infra/
  ansible/
    ansible.cfg/
    inventory.ini/
    playbook.yml/
    README.MD/
    site.yml/
  terraform/
    main.tf/
    outputs.tf/
    providers.tf/
    README.md/
    versions.tf/
```



## Pré-requis Logiciels
Avant de commencer, assurez-vous d'avoir installé :

- Docker Desktop (ou Engine)

- Terraform (v1.5+)

- Ansible (v2.9+)

- Git



## Installation & Récupération du Projet
Avant de lancer le déploiement, vous devez récupérer le code source sur votre machine.

### Méthode 1 : Via GitHub Desktop (Recommandé pour débutants)
Sur la page GitHub du projet, cliquez sur le bouton "Fork" (en haut à droite) pour créer une copie sur votre compte.
Ouvrez GitHub Desktop.
Allez dans File > Clone Repository.
Sélectionnez votre fork dans la liste et choisissez un dossier local (ex: Documents/TP-DevOps).
Cliquez sur Clone.

### Méthode 2 : Via le Terminal (Git Bash / CMD)
Forkez le projet sur GitHub.
Ouvrez votre terminal et lancez :
```text
# Remplacez VOTRE_USER par votre nom d'utilisateur GitHub
git clone https://github.com/VOTRE_USER/terraform-ansible-evaluation.git
cd terraform-ansible-evaluation
```



## Guide de Démarrage (Déploiement)
Le déploiement se fait en deux temps : Provisioning (Terraform) puis Configuration (Ansible).

### Étape 1) Terraform (Infrastructure)
Crée le réseau tp_network, construit l'image et lance les conteneurs.
```text
cd infra/terraform
terraform init
terraform apply -auto-approve
```

### Étape 2) Ansible (Configuration & Validation)
Applique la configuration finale et valide la bonne santé des services.
```text
cd ../ansible
ansible-playbook -i inventory.ini site.yml
```

### Étape 3) Vérification
L'application est accessible. La réponse JSON inclut le hostname (ID du conteneur).
```text
curl http://localhost:8080/health
# Réponse attendue : {"hostname": "a1b2c3d4...", "status": "healthy"}
```



## Nettoyage de l'environnement
Pour détruire proprement toute l'infrastructure (conteneurs, réseau) :
```text
cd infra/terraform
terraform destroy -auto-approve
```



## État des Réalisations (Checklist)
Toutes les tâches demandées dans le sujet initial ont été réalisées.

### 1) Docker 
- [X] Création app/Dockerfile optimisé.

- [X] Ajout .dockerignore.

- [x] Build & Run automatisés via Terraform.

### 2) Terraform 
- [X] Définition du réseau privé Docker.

- [X] Déploiement du Reverse Proxy (Nginx) sur le port 8080.

- [X] Déploiement de l'App Flask sur le port 5000 (interne).

- [X] Outputs configurés (URL d'accès).

### 3) Ansible 
- [X] Automatisation du déploiement (module docker_container).

- [X] Idempotence garantie (pas de redémarrage inutile).

- [X] Healthcheck intégré en fin de playbook (uri module).

### 4) CI/CD (GitHub Actions) 
- [X] Pipeline Multi-Stages mis en place.

- [X] Qualité : Linting Python avec Flake8.

- [X] Sécurité : Scan d'image avec Trivy (Détection CVE).

- [X] Test : Test E2E sur conteneur éphémère.