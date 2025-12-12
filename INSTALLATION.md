# Guía de Instalación para Entorno de Producción - Directorio de Revistas

Esta guía detalla los pasos para desplegar la plataforma **Directorio de Revistas** en un servidor con **Debian 12**. La instalación incluye PostgreSQL 17, Node.js 20, Nginx y la configuración de los componentes `auth`, `back` y `front`.

## Índice

1.  [Requisitos Previos](#1-requisitos-previos)
2.  [Actualización del Sistema](#2-actualización-del-sistema)
3.  [Instalación de PostgreSQL 17](#3-instalación-de-postgresql-17)
4.  [Instalación de Node.js 20](#4-instalación-de-nodejs-20)
5.  [Instalación de PM2](#5-instalación-de-pm2)
6.  [Instalación de Nginx](#6-instalación-de-nginx)
7.  [Configuración del Proyecto](#7-configuración-del-proyecto)
    *   [Clonar Repositorio](#clonar-repositorio)
    *   [Preparación de la Base de Datos](#preparación-de-la-base-de-datos)
    *   [Backend de Autenticación (`auth`)](#backend-de-autenticación-auth)
    *   [Backend Público (`back`)](#backend-público-back)
    *   [Frontend (`front`)](#frontend-front)
8.  [Configuración de Nginx](#8-configuración-de-nginx)
9.  [Verificación Final](#9-verificación-final)

---

## 1. Requisitos Previos

*   Servidor con **Debian 12**.
*   Acceso **root** o usuario con privilegios `sudo`.
*   Dominio o subdominios apuntando a la IP del servidor (ej. `directorio.minaamp.gob.ve`), o bien usar `localhost` para pruebas locales.

## 2. Actualización del Sistema

Actualiza la lista de paquetes y el sistema operativo:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git wget gnupg2 lsb-release ca-certificates
```

## 3. Instalación de PostgreSQL 17

Agrega el repositorio oficial de PostgreSQL e instálalo:

```bash
# Agregar repositorio de PostgreSQL
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Importar clave de firma
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

# Instalar PostgreSQL 17
sudo apt update
sudo apt install -y postgresql-17 postgresql-client-17

# Habilitar e iniciar el servicio
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

## 4. Instalación de Node.js 20

Usa el repositorio de NodeSource para instalar la versión LTS (v20):

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verificar versiones
node -v
npm -v
```

## 5. Instalación de PM2

PM2 se utiliza para gestionar los procesos de Node.js en producción.

```bash
sudo npm install -g pm2
```

## 6. Instalación de Nginx

```bash
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

## 7. Configuración del Proyecto

### Clonar Repositorio

Asumiendo que estás en `/var/www` (o tu directorio de preferencia):

```bash
cd /var/www
# Clona tu repositorio (reemplaza <URL_REPO> con la URL real)
git clone <URL_REPO> directorio
cd directorio
```

### Preparación de la Base de Datos

1.  **Crear Usuario y Base de Datos**:

    ```bash
    sudo -u postgres psql
    ```

    Dentro de la consola `psql`:

    ```sql
    -- Reemplaza 'tu_password_seguro' por una contraseña real
    CREATE USER directorio_user WITH ENCRYPTED PASSWORD 'tu_password_seguro';
    CREATE DATABASE directorio_db OWNER directorio_user;

    -- Opcional: Si necesitas compatibilidad con el código hardcodeado actual del backend 'back':
    -- CREATE USER postgres WITH PASSWORD 'postgres'; -- (Ya existe usualmente)
    -- CREATE DATABASE _api_revistas OWNER postgres;

    \q
    ```

    **Recomendación**: Usa el siguiente comando para importar el esquema proporcionado. Busca el archivo SQL más reciente en `bd/` (ej. `bd/20250419_api-revistas.sql` o el que esté disponible).

    ```bash
    # Ejemplo importando revistas.sql de la raíz o bd/ (verifica el nombre exacto en la carpeta bd/)
    sudo -u postgres psql -d directorio_db -f bd/20251212_apis_revistas_desarrollo.sql
    ```

    Después de importar, asegúrate de que el usuario de la aplicación tenga permisos sobre las tablas:

    ```bash
    sudo -u postgres psql -d directorio_db -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO directorio_user;"
    sudo -u postgres psql -d directorio_db -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO directorio_user;"
    ```

### Backend de Autenticación (`auth`)

1.  Instalar dependencias:

    ```bash
    cd auth
    npm install
    ```

2.  Configurar variables de entorno:

    Crea el archivo `.env`:

    ```bash
    cp .env.example .env  # Si existe, si no:
    nano .env
    ```

    Contenido sugerido para `.env`:

    ```env
    PORT=4001
    DB_USER=directorio_user
    DB_HOST=localhost
    DB_NAME=directorio_db
    DB_PASSWORD=tu_password_seguro
    DB_PORT=5432
    JWT_SECRET=cambia_esto_por_un_secreto_largo
    PORTADAS_PATH=/var/www/directorio/back/public/portadas

    # URLs para el frontend/correos si aplica
    VITE_IMAGE_BASE_URL=https://directorio.minaamp.gob.ve/api/portadas/
    ```

    *Asegúrate de que la ruta `PORTADAS_PATH` exista y sea escribible.*

3.  Iniciar con PM2:

    ```bash
    pm2 start src/index.js --name "directorio-auth"
    ```

### Backend Público (`back`)

1.  Instalar dependencias:

    ```bash
    cd ../back
    npm install
    ```

2.  Configurar variables de entorno:

    Crea el archivo `.env`:

    ```env
    PORT=4000
    DB_USER=directorio_user
    DB_HOST=localhost
    DB_NAME=directorio_db
    DB_PASSWORD=tu_password_seguro
    DB_PORT=5432
    ```

4.  Crear directorio de portadas:

    ```bash
    mkdir -p public/portadas
    ```

5.  Iniciar con PM2:

    ```bash
    pm2 start index.js --name "directorio-back"
    ```

### Frontend (`front`)

1.  Instalar dependencias globales de Quasar (opcional si usas npx, pero recomendado):

    ```bash
    npm install -g @quasar/cli
    ```

2.  Instalar dependencias del proyecto:

    ```bash
    cd ../front
    npm install
    ```

3.  Configurar entorno de producción:

    Edita `front/.env.production`. Asegúrate de que las URLs apunten a tu dominio y que Nginx manejará los proxies `/api/` y `/auth/`.

    ```env
    VITE_API_URL=https://directorio.minaamp.gob.ve/api/
    VITE_REVISTA_URL=https://directorio.minaamp.gob.ve/auth/revistas/
    VITE_IMAGE_BASE_URL=https://directorio.minaamp.gob.ve/api/portadas/
    # ... resto de variables apuntando al dominio principal
    ```

4.  Compilar para producción:

    ```bash
    quasar build
    # Esto generará la carpeta dist/spa
    ```

## 8. Configuración de Nginx

Crea un archivo de configuración para el sitio:

```bash
sudo nano /etc/nginx/sites-available/directorio
```

Pega el siguiente contenido (ajusta `server_name` y rutas según tu caso):

```nginx
server {
    listen 80;
    server_name directorio.minaamp.gob.ve;

    # Directorio donde se construyó el frontend
    root /var/www/directorio/front/dist/spa;
    index index.html;

    # Configuración para SPA (Single Page Application)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy para el Backend Público (/api/)
    location /api/ {
        # La barra al final es importante para quitar /api/ de la ruta
        proxy_pass http://127.0.0.1:4000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Proxy para el Backend de Autenticación (/auth/)
    location /auth/ {
        proxy_pass http://127.0.0.1:4001/auth/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Proxy para WebSockets (/ws)
    location /ws {
        proxy_pass http://127.0.0.1:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }

    # Logs
    access_log /var/log/nginx/directorio_access.log;
    error_log /var/log/nginx/directorio_error.log;
}
```

Activa el sitio y prueba la configuración:

```bash
sudo ln -s /etc/nginx/sites-available/directorio /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### SSL (HTTPS)

Para producción, es indispensable usar HTTPS. Puedes usar Certbot:

```bash
sudo apt install python3-certbot-nginx
sudo certbot --nginx -d directorio.minaamp.gob.ve
```

## 9. Verificación Final

1.  **Persistencia de PM2**: Guarda la lista de procesos para que inicien automáticamente tras un reinicio.

    ```bash
    pm2 save
    pm2 startup
    # Ejecuta el comando que pm2 startup te indique
    ```

2.  Accede a `http://directorio.minaamp.gob.ve` (o tu dominio).
3.  Verifica que cargue el frontend.
4.  Verifica que las llamadas a la API (login, listados) funcionen correctamente (inspeccionando la red en el navegador).

---
**Nota sobre permisos**: Asegúrate de que el usuario que ejecuta Node.js (probablemente tu usuario actual o `www-data` si lo configuras así) tenga permisos de escritura en `back/public/portadas` para la carga de imágenes.
