# Migrating ETL Pipeline with Medallion Architecture & Star Schema to dbt (Dockerized Postgres, Jupyter Notebook, and dbt).

<img src = "img/project_02-elt-medallion_dbt.png">

## Table of Contents

- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Environment Variables](#environment-variables)
  - [Build and Run](#build-and-run)
- [Services](#services)
- [dbt](#dbt)
- [Migration Process](#migration-process)

## Project Structure

- **name_of_your_project_repo (project-root)/**
    - **.devcontainer/**
      - devcontainer.json
    - **external_ingestion**
      - **data**
        - your_CSV_files.csv
      - create_schemas.sql (script to create the raw schema in PostgreSQL)
      - ingestion_in_raw.ipynb (notebook where the ingestion against PostgreSQL is executed)
    - **.dbt**
      - profiles.yml (connection details for our database environments)
    - **analyses**
    - **logs** (ignored in git)
      - dbt.log
    - **macros**
      - **tests**
        - date_format.sql (macro to ensure date columns have date format)
      - generate_schema_name.sql (this macro makes sure your database schemas' names are respected)
    - **models**
      - sources.yml
      - **bronze**
        - bronze_dbt_model_1.sql
        - schema.sql
      - **silver**
        - silver_dbt_model_1.sql
        - schema.sql
      - **gold**
        - gold_dbt_model_1.sql
        - schema.sql
    - **seeds**
    - **snapshots**
    - **target** (ignored in git)
    - **tests**
    - **.env**
    - **.gitignore**
    - **.python-version**
    - **dbt_project.yml**  (the main file: this is how dbt knows a directory is a dbt project)
    - **packages.yml**     (where dbt packages should be configured)
    - **package-lock.yml** (created by dbt when the 'dbt deps' is executed against the packages.yml)
    - **Dockerfile**
    - **docker-compose.yml**
    - **requirements.txt**
    - **README.md**

## Setup Instructions

### Prerequisites

Make sure you have the following installed on your local development environment:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [VSCode](https://code.visualstudio.com/) with the [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

Make sure to inclue a .gitignore file with the following information:

*.pyc          (to ignore python bytecode files)
.env           (to ignore sensitive information, such as database credentials)
target/        (to ignore compiled SQL files and other build artifacts that are generated when dbt runs)
dbt_packages/  (to ignore where dbt installs packages, which are specific to your local environment)
logs/          (to ignore logs)
data/          (to ignore CSV files)

### Environment Variables
The .gitignore file, ignores the ´.env´ file for security reasons. However, since this is just for educational purposes, follow the step below to include it in your project. If you do not include it, the docker will not work.

Create a `.env` file in the project root with the following content:

- POSTGRES_USER=your_postgres_user
- POSTGRES_PASSWORD=your_postgres_password
- POSTGRES_DB=your_postgres_db
- POSTGRES_HOST=postgres
- POSTGRES_PORT=5432
- JUPYTER_TOKEN=123

### Build and Run

1. **Clone the repository:**

   ```bash
   git clone https://github.com/caiocvelasco/end-to-end-data-science-project.git
   cd end-to-end-data-science-project

2. **Build and start the containers:**

  When you open VSCode, it will automatically ask if you want to reopen the repo folder in a container and it will build for you.

**Note**: I have included the command `"postCreateCommand": "docker image prune -f"` in the **.devcontainer.json** file. Therefore, whenever the docker containeirs are rebuilt this command will make sure to delete the `unused (dangling)` images. The -f argument ensures you don't need to confirm if you want to perform this action.

### Services

* **Postgres**: 
  * A PostgreSQL database instance.
  * Docker exposes port 5432 of the PostgreSQL container to port 5432 on your host machine. This makes service is accessible via `localhost:5432` on your local machine for visualization tools such as PowerBI and Tableau. However, within the docker container environment, the other services will use the postgres _hostname_ as specified in the `.env` file (`POSTGRES_HOST`).
  * To test the database from within the container's terminal: `psql -h $POSTGRES_HOST -p 5432 -U $POSTGRES_USER -d $POSTGRES_DB`
* **DBT**: The Data Build Tool (dbt) for transforming data in the data warehouse.
* **Jupyter Notebook**: A Jupyter Notebook instance for interactive data analysis and for checking the models materialized by dbt.

### dbt

dbt (Data Build Tool) is a development environment that enables data analysts and engineers to transform data in their warehouse more effectively. To use dbt in this project, follow these steps:

1. **Install dbt**: The Dockerfile and Docker Compose file will do this for you.
2. **Configure database connection**: The `profiles.yml` was created inside a `.dbt` folder in the same level as the `docker-compose.yml`. It defines connections to your data warehouse. It also uses environment variables to specify sensitive information like database credentials (which in this case is making reference to the `.env` file that is being ignored by `.gitignore`, so you should have one in the same level as the `docker-compose.yml` - as shown in the folder structure above.)
3. **Install dbt packages**: Never forget to run `dbt deps` so that dbt can install the packages within the `packages.yml` file.
4. **Run DBT**: Once dbt is installed and configured, you can use it to build your dbt models. Use the `dbt run` command to run the models against your database and apply transformations.

### Migration Process

**Steps Summary**
The step-by-step migration will be done for one table in Bronze. Then, we need to replicate for all the other tables.

1) Ensure your environment is ready.
  * The Dockerfile and Docker Compose file will do this for you. You just need to open the repo with VSCode (make sure to have the prerequisites, as mentioned in the `Prerequisites` section above).
  * Check if the docker's bash terminal in VSCode can retrieve the environment variables: `env | grep POSTGRES`
  * Make sure to add the CSV files to `external_ingestion/data`. This folder was create to mimic the EL (Extract + Load) work done in the EL part of the ELT paradigm followed by dbt.
  * Make sure the database connection is working by doing `dbt debug` in the Docker bash terminal.
2) Run the `ingestion_in_raw.ipynb` file to mimic an external ingestion procedure into PostgreSQL (in the RAW schema).
3) Configure your `profiles.yml`.
  * `profiles.yml` is located under the `~/.dbt` folder and not in the dbt project folder.
  * Make sure your profiles.yml file is correctly set up.
  * This repo container the necessary information in `profiles.yml`.
4) Organize your dbt project directory.
  * `dbt_project.yml` file:
    * Under the `models > my_dbt_project` section, include all the layers (bronze, silver, gold) and the respective materialization. Recall that within the dbt models (sql files within the `models/` folder) you can override the materialization if you want.
  * `packages.yml` file:
    * It was created by me and not by dbt.
    * This file will specify the dependencies your project needs.
    * Make sure that the `dbt-utils` package is compatible with your `dbt-core` version (https://hub.getdbt.com/dbt-labs/dbt_utils/latest/)
    * Install dbt Packages: 
      * `dbt clean` (to clean dependencies),
      * then `dbt deps` (this will look for the `packages.yml` file that should be in the same level as `dbt_project.yml`.)
  * `models/` folder: 
    * Contains the dbt models (i.e., SQL scripts or *.sql files) for each layer (bronze, silver, gold) as separate subdirectories.
    * For each layer (e.g.: `models/bronze`) there is a `properties.yml` file. This file is where you specify data columns, tests, and any other property you want to ensure at each table in the schema. 
    * `models/sources.yml`: Sources make it possible to name and describe the data loaded into your warehouse by your Extract-Load tool, i.e., the data from the CSV that was ingested into the RAW schema in PostgreSQL. When referencing these "source" tables in the dbt models, make sure to use the `{{ source('source_name','table_name') }}` jinja. 
  * `macro/` folder:
    * Here you create macros to use in your project.
    * An example is the `macro/tests/date_format.sql`. I created this macro in a `test/` folder to ensure that the date columns have a date format.
    * To apply this test, you need to put it in the `date_tests:` section of the `properties.yml` for the respective schema. 
4) Migrate SQL scripts to dbt models.
  * Here, we initiated the dbt model migration from the legacy project (the medallion where E-T-L was done with python) to a dbt project where dbt does all the work **after** the data is already ingested into our Data Warehouse. In this case, we are not using a DW, but rather PostgreSQL to mimic the idea. 
    * Example: Bronze schema
      * Create a dbt model for each bronze table -> Example: `models/bronze/customers.sql`
    * Do the same for Silver and Gold.
6) Run and test your dbt models.
  * Make sure you are under the Docker's workspace where `.dbt` is located: `cd /workspace`
  * Run dbt models in all schemas: `dbt run`
  * Check the Database with Dbeaver or any other tool.