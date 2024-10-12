# Étape de construction
FROM elixir:1.17.3-alpine AS builder

# Set build environment variables
ENV MIX_ENV=prod

# Install build dependencies
RUN apk add --no-cache build-base git

# Définir le répertoire de travail
WORKDIR /app

# Installer Hex et Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copier les fichiers de configuration et les dépendances
COPY mix.exs mix.lock ./

# Installer les dépendances
RUN mix deps.get

# Copier le reste du code
COPY . .

# Compiler le code
RUN mix compile

# (Optional) Compile assets if your app has them
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
# RUN mix phx.digest

# Build the release
RUN mix release

# Étape d'exécution
FROM alpine:latest

# Installer les dépendances runtime
RUN apk add --no-cache libstdc++ openssl ncurses-libs

# **Add postgresql-client to install pg_isready**
RUN apk add --no-cache postgresql-client

# Set environment variables
ENV MIX_ENV=prod
ENV REPLACE_OS_VARS=true
ENV APP_NAME=backend

# Définir le répertoire de travail
WORKDIR /app

# Copier le release depuis l'étape de build
COPY --from=builder /app/_build/prod/rel/backend ./

# Exposer le port de l'application
EXPOSE 4000

# Copy the entrypoint script
COPY entrypoint.sh .

# Make the entrypoint script executable
RUN chmod +x entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["./entrypoint.sh"]
