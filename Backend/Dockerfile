# Étape de construction
FROM elixir:1.17.3-alpine AS builder

# Installer les dépendances de build
RUN apk add --no-cache build-base git

# Définir le répertoire de travail
WORKDIR /app

# Installer Hex et Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copier les fichiers de configuration et les dépendances
COPY mix.exs mix.lock ./
COPY config config

# Installer les dépendances
RUN mix deps.get --only prod

# Copier le reste du code
COPY . .

# Compiler le code
RUN MIX_ENV=prod mix compile

# Construire le release
RUN MIX_ENV=prod mix release

# Étape d'exécution
FROM alpine:latest

# Installer les dépendances runtime
RUN apk add --no-cache libstdc++ openssl ncurses-libs

# Définir le répertoire de travail
WORKDIR /app

# Copier le release depuis l'étape de build
COPY --from=builder /app/_build/prod/rel/backend ./

# Exposer le port de l'application
EXPOSE 4000

# Démarrer l'application
CMD ["./bin/backend", "start"]
