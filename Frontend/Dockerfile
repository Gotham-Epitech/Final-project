# Étape de construction
FROM node:16-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de configuration
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste du code
COPY . .

# Construire l'application
RUN npm run build

# Étape d'exécution
FROM nginx:alpine

# Copier les fichiers construits
COPY --from=builder /app/dist /usr/share/nginx/html

# Exposer le port HTTP
EXPOSE 80

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
