#!/bin/bash

set -euo pipefail

NAMESPACE="coroot"

echo "🗑️  Uninstalling Coroot Community Edition..."
helm uninstall -n "$NAMESPACE" coroot || echo "Coroot CE not found."

echo "🗑️  Uninstalling Coroot Operator..."
helm uninstall -n "$NAMESPACE" coroot-operator || echo "Coroot Operator not found."

# Optional: Delete Coroot CRDs
# echo "🧹 Deleting Coroot CRDs..."
# kubectl delete crd coroots.coroot.com || echo "CRD coroots.coroot.com not found."

# Optional: Delete the namespace (only if empty or unused)
echo "🏷️  Deleting namespace '$NAMESPACE'..."
kubectl delete namespace "$NAMESPACE" || echo "Namespace $NAMESPACE not found or already deleted."

echo "✅ Coroot has been completely removed."
