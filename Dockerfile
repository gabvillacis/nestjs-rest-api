# Etapa 1: Build
FROM node:18-alpine AS builder

# Establece el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copia solo los archivos necesarios para instalar dependencias y compilar el proyecto
COPY package*.json ./
COPY tsconfig*.json ./
COPY nest-cli.json ./

# Instala las dependencias de producción y desarrollo necesarias para la compilación
RUN npm install

# Copia el código fuente necesario para la compilación
COPY src ./src

# Compila el proyecto
RUN npm run build

# Etapa 2: Producción
FROM node:18-alpine AS production

# Establece el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copia solo las dependencias de producción desde la etapa anterior
COPY package*.json ./
RUN npm install --production

# Copia los archivos compilados de la etapa de build
COPY --from=builder /usr/src/app/dist ./dist

# Expone el puerto que utilizará NestJS
EXPOSE 3000

# Comando para iniciar la aplicación en producción
CMD ["npm", "run", "start:prod"]
