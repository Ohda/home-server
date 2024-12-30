# Home Server

Une configuration simple de serveur domestique utilisant Docker.

## Composants

- **HashiCorp Vault** : Un outil pour gérer sécuritairement les secrets et protéger les données sensibles.
- **Traefik** : Un proxy inverse moderne et équilibreur de charge pour gérer votre trafic web.
- **Langflow** : Un outil low-code pour créer des applications RAG et multi-agents IA. Basé sur Python, il est agnostique à tout modèle, API ou base de données.

## Prérequis

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Installation

### 1. Configurer le Redirection des Ports sur Votre Routeur

Accédez aux paramètres de votre routeur domestique (généralement accessible via `http://192.168.1.1`) et configurez les redirections de ports suivantes :

- Redirigez le port **80** (HTTP) vers votre serveur local.
- Redirigez le port **443** (HTTPS) vers votre serveur local.

### 2. Configurer un DNS Gratuit avec DuckDNS

- Rendez-vous sur [DuckDNS](https://duckdns.org) et créez un compte gratuit.
- Associez votre adresse IP publique à un sous-domaine DuckDNS de votre choix.

### 3. Cloner le Dépôt et Préparer l'Environnement

```bash
git clone <REPO_URL>
cd home-server
touch acme.json
chmod 600 acme.json
cp .env.default .env
```

### 4. Configurer le Fichier `.env`

Mettez à jour le fichier `.env` avec les valeurs de configuration nécessaires. Voici un tableau expliquant chaque variable :

| Nom de la Variable       | Description                                                               | Exemple                        |
|--------------------------|---------------------------------------------------------------------------|--------------------------------|
| `HOME_SERVER_DATA_PATH`  | Chemin vers le répertoire contenant les données de Vault.                | `/path/to/data`                |
| `DUCKDNS_EMAIL`          | Adresse email associée à votre compte DuckDNS.                        | `your-email@example.com`       |
| `VAULT_DNS`              | Sous-domaine DuckDNS pour accéder à Vault.                             | `your-subdomain.duckdns.org`   |
| `DUCKDNS_TOKEN`          | Jeton DuckDNS, obtenable depuis la page de votre compte DuckDNS.         | `abcdef1234567890abcdef123456` |

**⚠ï Important :**
- Sauvegardez régulièrement le répertoire spécifié dans `HOME_SERVER_DATA_PATH` pour éviter toute perte de données.
- Stockez votre `DUCKDNS_TOKEN` en lieu sûr.

### 5. Lancer les Services avec Docker Compose

```bash
docker compose up -d
```

### 6. Accéder au Tableau de Bord de Traefik

Ouvrez votre navigateur et accédez à [http://localhost:8080](http://localhost:8080) pour afficher le tableau de bord de Traefik.

### 7. Configurer HashiCorp Vault

#### Accès Initial

1. Ouvrez votre navigateur et accédez à [http://localhost:8200](http://localhost:8200).
2. Lors du premier démarrage, générez une **Clé de Déverrouillage (Unseal Key)** et un **Jeton Root (Root Token)**.
   - **Clé de Déverrouillage :** Utilisée pour déverrouiller Vault.
   - **Jeton Root :** Accès administratif complet.

**⚠ï Important :** Stockez ces informations en lieu sûr.

#### Configuration Simple

1. **Activer un moteur de secrets :**

    ```bash
    vault secrets enable -path=my kv
    ```

2. **Définir une politique :**

    Créez une politique appelée `my` :

    ```yaml
    path "my/*" {
      capabilities = ["create", "read", "update", "delete", "list"]
    }
    path "my/metadata/*" {
      capabilities = ["list", "read"]
    }
    ```

3. **Ajouter une méthode d'authentification utilisateur :**

    - Activer le mécanisme d'authentification par mot de passe :

      ```bash
      vault auth enable userpass
      ```

    - Ajouter un utilisateur avec la politique `my` :

      ```bash
      vault write auth/userpass/users/<USERNAME> password=<PASSWORD> policies=my
      ```

4. **Configurer une authentification Google OIDC :**

    Suivez le tutoriel officiel [Google Workspace OAuth](https://developer.hashicorp.com/vault/tutorials/auth-methods/google-workspace-oauth).

    Exemple de configuration :

    ```yaml
    vault write auth/oidc/config \
      oidc_discovery_url="https://accounts.google.com" \
      oidc_client_id="<OAUTH_CLIENT_ID>" \
      oidc_client_secret="<OAUTH_CLIENT_SECRET>" \
      default_role="gmail"

    vault write auth/oidc/role/gmail -<<EOF
    {
        "user_claim": "email",
        "bound_claims": { "email": ["<YOUR_EMAIL_ADDRESS>"] },
        "bound_audiences": "<OAUTH_CLIENT_ID>",
        "oidc_scopes": "openid email profile",
        "allowed_redirect_uris": "https://your-subdomain.duckdns.org/ui/vault/auth/oidc/oidc/callback",
        "role_type": "oidc",
        "policies": "my",
        "ttl": "1h"
    }
    EOF
    ```

### 8. Accéder à Vault depuis Internet

Essayez de vous connecter à votre `VAULT_DNS` (par ex. `https://your-subdomain.duckdns.org`) depuis un navigateur externe. Vault devrait être accessible en HTTPS.

### 9. Accéder à LangFlow

Ouvrez votre navigateur et accédez à [http://localhost:7860](http://localhost:7860).

## Recommandations Supplémentaires

- **Sécurité :** Mettez à jour régulièrement vos images Docker et dépendances pour corriger les vulnérabilités.
- **Sauvegardes :** Implémentez une stratégie de sauvegarde robuste pour vos données Vault et fichiers de configuration.
- **Surveillance :** Configurez une surveillance et des journaux pour suivre les performances et la sécurité de votre serveur.

## Dépannage

- **Problèmes de Redirection de Ports :** Vérifiez que votre routeur redirige correctement les ports 80 et 443 vers l'adresse IP locale de votre serveur.
- **Configuration DNS :** Assurez-vous que votre sous-domaine DuckDNS pointe correctement vers votre adresse IP publique.
- **Paramètres de Pare-feu :** Vérifiez que le pare-feu de votre serveur autorise le trafic sur les ports 80, 443, 8080 et 8200.

Pour plus d'assistance, consultez la documentation officielle de [HashiCorp Vault](https://www.vaultproject.io/docs) et [Traefik](https://doc.traefik.io/traefik/).

