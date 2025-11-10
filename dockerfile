# ===== Etapa: deps (instalar dependencias) =====
FROM node:18 AS deps
WORKDIR /app

# Copiamos solo manifests para cache
COPY package*.json ./

# Instala dependencias (usa npm ci si hay lockfile)
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi


# ===== Etapa: test =====
FROM deps AS test

# Copiamos todo el código de la aplicación
COPY . .

# Ejecutamos los tests (no falla si no hay script "test")
RUN npm run -s test --if-present
