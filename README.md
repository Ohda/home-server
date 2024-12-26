# Home Server

A simple home server setup using Docker.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Components
- **HashiCorp Vault**: A tool for securely managing secrets and protecting sensitive data.

## Installation

Clone the repository and start the containers:

```bash
git clone <REPO_URL>
cd home-server
docker-compose up -d
firefox http://localhost:8200
```
