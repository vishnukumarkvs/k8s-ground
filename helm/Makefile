.PHONY: envars hd ha hde

hd:
	. ./helm-values-secrets.sh && helmfile diff

ha:
	. ./helm-values-secrets.sh && helmfile apply

hde:
	. ./helm-values-secrets.sh && helmfile destroy

hs:
	. ./helm-values-secrets.sh && helmfile sync
