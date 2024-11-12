# restaurant01

## Ejecución de Contenedor SQL Server

Para levantar y configurar el contenedor de SQL Server, sigue los siguientes pasos:

### Primera vez

1. Construye y levanta el contenedor:
   ```bash
   docker-compose up --build

2. Ejecuta el script de creación de la base de datos manualmente en una nueva terminal:
    ```bash
    docker exec -it sql_server_db /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P 'Password123' -i /scripts/create_db.sql -N -C

### Ejecuciones posteriores

Para iniciar el contenedor en las ejecuciones posteriores, simplemente usa:
```bash
docker-compose up

## Conexión a SQL Server desde VSCode

Para conectarte al servidor SQL Server usando la extensión de SQL Server en VSCode, configura la conexión con las siguientes credenciales:

- **Server name**: `localhost,1433`
- **Authentication type**: `SQL Login`
- **Username**: `SA`
- **Password**: `Password123`



