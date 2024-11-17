helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add codecentric https://codecentric.github.io/helm-charts
helm install keycloak-db bitnami/postgresql --values ./keycloak-db-values.yaml
helm install keycloak codecentric/keycloakx --values ./keycloak-server-values.yaml