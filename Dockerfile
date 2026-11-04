# ---------------------------------------------------------------
# Dockerfile À COMPLÉTER : TP3 (jour 3)
# ---------------------------------------------------------------

# TODO 1 : choisir une image de base Python légère
FROM python:3.12-slim

# TODO 2 : définir le dossier de travail
WORKDIR /app

# TODO 3 : copier requirements.txt AVANT le code (pour profiter du cache),
#          puis installer les dépendances avec pip (--no-cache-dir)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# TODO 4 : copier le code de l'application
COPY app/ app/

# TODO 5 : créer un utilisateur non-root et basculer dessus (USER)
RUN useradd --create-home --uid 10001 appuser
USER appuser

# TODO 6 : embarquer la version de l'application
#          ARG permet de recevoir une version lors de la construction
#          ENV rend cette version disponible dans le conteneur
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

# Exposer le port utilisé par l'application
EXPOSE 8000

# Vérifier automatiquement que l'application répond
HEALTHCHECK --interval=15s --timeout=3s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

# Lancer l'application avec Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.main:app"]