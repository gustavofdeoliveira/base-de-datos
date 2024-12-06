# Taller 3

## Alumno
- Nombre: Gustavo Ferreira de Oliveira
- RUT: 400162816

## Requisitos previos

- Docker instalado en tu máquina.
- Java.

## Estructura del proyecto

```plaintext
.
├── docker-compose.yml       
├── src/                    
├── script.sql            
```

## Instrucciones para ejecutar

1. **Clonar o descargar el proyecto:**

   Si aún no tienes el proyecto en tu máquina, clónalo desde el repositorio o descárgalo.

   ```bash
   git clone https://github.com/gustavofdeoliveira/base-de-datos
   cd taller-3
   ```

2. **Construir y subir los contenedores Docker:**

   Asegúrate de estar en el directorio donde se encuentra el archivo `docker-compose.yml`. Luego, ejecuta el siguiente comando para construir y levantar el contenedor de PostgreSQL:

   ```bash
   docker-compose up -d
   ```

   Este comando descargará la imagen de PostgreSQL, creará el contenedor y lo iniciará en segundo plano.

3. **Verificar que el contenedor está corriendo:**

   Para asegurarte de que el contenedor se esté ejecutando correctamente, puedes usar el siguiente comando:

   ```bash
   docker ps
   ```

   Deberías ver algo similar a esto:

   ```plaintext
   CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                    NAMES
   taller-3         postgres:17       "docker-entrypoint.s…"   10 seconds ago   Up 9 seconds    0.0.0.0:5432->5432/tcp   postgres_container
   ```

4. **Acceder a la base de datos desde tu máquina local:**

   La base de datos se encuentra disponible en el puerto `5432`. Puedes conectarte a ella utilizando cualquier cliente SQL (como DBeaver, pgAdmin, o psql) con los siguientes parámetros:

    - **Host:** `localhost`
    - **Puerto:** `5432`
    - **Usuario:** `postgres`
    - **Contraseña:** `postgres123`
    - **Base de datos:** `postgres`

