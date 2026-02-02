# 1. Image de base : Dernière version stable en mode "slim" (léger)
FROM python:3.13-slim

# 2. Optimisations Python pour Docker
# PYTHONDONTWRITEBYTECODE=1 : Évite de créer des fichiers .pyc inutiles
# PYTHONUNBUFFERED=1 : Les logs s'affichent instantanément dans la console
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3. Définir le répertoire de travail
WORKDIR /app

# 4. Copie SEULEMENT les requirements d'abord (Optimisation du cache Docker)
# Si tu changes ton code mais pas tes libs, Docker sautera cette étape (build très rapide)
COPY requirements.txt .

# 5. Installation des dépendances sans cache pip (réduit la taille de l'image)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 6. Copie du reste du code source
COPY . .

# 7. Exposition du port
EXPOSE 5000

# 8. Commande de lancement
CMD ["python", "app.py"]