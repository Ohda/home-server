# Home Server

A simple home server setup using Docker.

## Components

- **HashiCorp Vault**: A tool for securely managing secrets and protecting sensitive data.
- **Traefik**: A modern reverse proxy and load balancer for managing your web traffic.
- **Langflow**: A low-code app builder for RAG and multi-agent AI applications. It’s Python-based and agnostic to any model, API, or database. 

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Installation

1. **Configure Port Forwarding on Your Router**

   Access your home router's settings (commonly at `http://192.168.1.1`) and set up port forwarding:

   - Forward port **80** (HTTP) to your local server.
   - Forward port **443** (HTTPS) to your local server.

2. **Set Up a Free DNS with DuckDNS**

   - Visit [DuckDNS](https://duckdns.org) and create a free DNS account.
   - Associate your public IP address with your chosen DuckDNS subdomain.

3. **Clone the Repository and Prepare the Environment**

    ```bash
    git clone <REPO_URL>
    cd home-server
    touch acme.json
    chmod 600 acme.json
    cp .env.default .env
    ```

4. **Configure the `.env` File**

    Update the `.env` file with the necessary configuration values. Below is a table outlining each variable, its description, and an example value:

    | Variable Name          | Description                                                                 | Example                         |
    |------------------------|-----------------------------------------------------------------------------|---------------------------------|
    | `HOME_SERVER_DATA_PATH`| Path to the directory that will contain the Vault data.                      | `/path/to/data`                 |
    | `DUCKDNS_EMAIL`        | Email address associated with your DuckDNS account.                         | `your-email@example.com`        |
    | `VAULT_DNS`            | Your chosen DuckDNS subdomain for accessing Vault.                          | `your-subdomain.duckdns.org`    |
    | `DUCKDNS_TOKEN`        | Your DuckDNS token, obtainable from your DuckDNS account page.               | `abcdef1234567890abcdef1234567890` |

    **⚠️ Important:** 
    - Ensure you regularly back up the directory specified in `HOME_SERVER_DATA_PATH` to prevent data loss.
    - Store your `DUCKDNS_TOKEN` securely, as it provides access to your DuckDNS account.

5. **Start the Services with Docker Compose**

    ```bash
    docker compose up -d
    ```

6. **Access Traefik Dashboard**

    Open your browser and navigate to [http://localhost:8080](http://localhost:8080) to access the Traefik dashboard.

7. **Access the Vault Web Interface**

    Open your browser and navigate to [http://localhost:8200](http://localhost:8200).

    - On your first startup, generate your **Unseal Key** and **Root Token** from the UI.
    - **⚠️ Important:** Store these credentials securely, as they are critical for accessing and managing Vault.

      - **Unseal Key:** Used to unseal Vault.
      - **Root Token:** Grants full administrative access to Vault.

    - **Note:** Each time you restart Docker Compose, you will need to **unseal Vault** using the unseal key.

8. **Access Vault from the Internet**

    Try connecting to your `VAULT_DNS` (e.g., `https://your-subdomain.duckdns.org`) from an external browser. It should be accessible over the internet using HTTPS.

9. **Access LangFlow**

    Open your browser and navigate to [http://localhost:7860](http://localhost:7860).


## Additional Recommendations

- **Security:** Regularly update your Docker images and dependencies to patch vulnerabilities.
- **Backups:** Implement a robust backup strategy for your Vault data and configuration files.
- **Monitoring:** Set up monitoring and logging to keep track of your server’s performance and security.

## Troubleshooting

- **Port Forwarding Issues:** Ensure that your router correctly forwards ports 80 and 443 to your server's local IP address.
- **DNS Configuration:** Verify that your DuckDNS subdomain correctly points to your public IP address.
- **Firewall Settings:** Ensure that your server’s firewall allows traffic on ports 80, 443, 8080, and 8200.

For further assistance, refer to the official documentation of [HashiCorp Vault](https://www.vaultproject.io/docs) and [Traefik](https://doc.traefik.io/traefik/).