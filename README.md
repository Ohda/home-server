# Home Server

A simple home server setup using Docker.

## Components

- **HashiCorp Vault**: A tool for securely managing secrets and protecting sensitive data.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Installation

1. **Clone the Repository and Navigate to the Directory:**

    ```bash
    git clone <REPO_URL>
    cd home-server
    cp .env.default .env
    ```

2. **Configure the `.env` File:**

    Edit the `.env` file to set the path to the directory that will contain the Vault data by updating the `HOME_SERVER_DATA_PATH` variable.

    **Example:**
    ```env
    HOME_SERVER_DATA_PATH=/path/to/data
    ```

    **⚠️ Important:** Ensure you plan for regular backups of this directory to prevent data loss.

3. **Start the Services with Docker Compose:**

    ```bash
    docker compose up -d
    ```

4. **Access the Vault Web Interface:**

    Open your browser and navigate to [http://localhost:8200](http://localhost:8200).
    On your first starup, generate your unseal key and root token from the UI. **Store Securely thoses informations**

    - **Unseal Key:** Used to unseal Vault.
    - **Root Token:** Grants full administrative access to Vault.

    **Each time you restart Docker Compose**, you need to **unseal Vault** using the unseal key.

   