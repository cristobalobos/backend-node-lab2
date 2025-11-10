# ===== Etapa: deps (instalar dependencias) =====
FROM node:18 AS deps
WORKDIR /app

# Copiamos solo manifests para que la cache sirva
COPY package*.json ./

# Instala dependencias (usa npm ci si hay lockfile)
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi