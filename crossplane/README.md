
# Helm isntall

````
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm search repo crossplane
helm install crossplane --namespace crossplane-system --create-namespace --version 1.20.0 crossplane-stable/crossplane
````

# Crossplane marketplace

- For example, top install providers
- https://marketplace.upbound.io/
- recently, crossp;ane has split its providers to make it fast, now we have seperate provider for each service

# AWS Access for crossplane using IAM role

```
kubectl create secret generic aws-secret \
-n crossplane-system \
--from-file=creds=/Users/kvsvishnukumar/VishnuKvs/Workspace/keys/awscreds-crossplane.txt
```

Keys format in file
```
[default]
aws_access_key_id =
aws_secret_access_key =
````

# To view resources (Examples)
- k get buckets
- k delete bucket <name> : This will actually delete bucket and not create it again by crossplane

## S3
- bucket versioning: creates new versions for every modifications, allows recovery of deleted objects
- obejct locking: objects cannot be deleted when enabled until the retention period, not even root users can delete. Mainly used for fips compliance

## VPC
- vpc resides in ec2 provider in crossplane
- enableDnsHostnames: true -> required for vpc for efs drivers etc
