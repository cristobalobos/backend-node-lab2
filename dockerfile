# ===== Etapa: deps (instalar dependencias) =====
FROM node:18 AS deps
WORKDIR /app

COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi


# ===== Etapa: test =====
FROM deps AS test
COPY . .
RUN npm run -s test --if-present


# ===== Etapa: build =====
FROM test AS build
RUN npm run -s build --if-present


# ===== Etapa: prod-deps (solo dependencias de producción) =====
FROM node:18-alpine AS prod-deps
WORKDIR /app
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi


# ===== Etapa: runtime (imagen final liviana) =====
FROM node:18-alpine AS runtime
WORKDIR /app

# Copiamos node_modules desde prod-deps
COPY --from=prod-deps /app/node_modules /app/node_modules

# Copiamos los artefactos de build (si existen)
COPY --from=build /app /app

# Exponemos el puerto que usa la app
EXPOSE 3000

# Comando de ejecución (ajusta si tu app usa otro entrypoint)
CMD ["npm", "start"]
