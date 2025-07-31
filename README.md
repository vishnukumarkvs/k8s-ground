# README


kind create cluster --name rough --config kind-config.yaml

grafana helm supports gnetId, not kps

SOPS
- see zshrc for sops path\
- see .sops.yaml for configuration
- used age for key gnereation
- backup in evmssd
- https://dev.to/hkhelil/secure-secret-management-with-sops-in-helm-1940
- helm plugin install https://github.com/jkroepke/helm-secrets
- sops -i -e > only for new secret
- sops -i > edit mode for encrypted file
- sops -d > decrypt
- helm secrets upgrade --install my-release ./my-chart
