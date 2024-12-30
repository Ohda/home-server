.PHONY: vault

vault:
	@bash -c ' \
	# Prompt pour le Vault Token sans afficher la saisie \
	read -s -p "Veuillez entrer votre Vault Token : " TOKEN && \
	echo && \
	# Exécuter le conteneur avec le VAULT_TOKEN exporté \
	docker exec -it vault-secrets /bin/sh -c "export VAULT_TOKEN='\''$$TOKEN'\''; exec /bin/sh" \
	'