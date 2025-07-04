# Cortex

# Configuration
- /etc/cortex/cortex.yaml

## Cache

## **Key Differences Between the Caches**

| **Cache Type**      | **Purpose**                                                  | **What it Improves**                      | **What is Cached**                                       |
|----------------------|-------------------------------------------------------------|--------------------------------------------|---------------------------------------------------------|
| **Index Cache**      | Caches block metadata pointers to locate chunks efficiently. | Query lookup speed; avoids reloading large index files. | Large index files (label sets, metric mappings).        |
| **Chunks Cache**     | Caches the raw time series data for queried metrics.         | Query latency; avoids backend fetches for raw data.     | Raw time series chunks (values and timestamps).         |
| **Metadata Cache**   | Caches high-level descriptions and metadata about blocks and series. | Query efficiency during block-level aggregation steps. | Block ranges, structure metadata, series metadata, etc. |

## Practical Example (Query: "Sum CPU usage for last 6 hours")

### Flow
- Frontend/Querier splits the query into smaller intervals (if split_queries_by_interval: 24h is configured).
- Cortex checks Index Cache to fetch block index files needed for the query range.
- Block index maps the query to relevant labels (cpu_usage container="app" region="us-west") and time ranges.
- Using the index, Cortex accesses the Chunks Cache to fetch the raw metric data (timestamps, values).
- The Metadata Cache fetches high-level metadata about blocks (e.g., time ranges covered, block sizes, etc.).
- Cortex processes queries using cached chunks and metadata to compute the sum (sum(cpu_usage)).

The final result is returned.

### What Happens During Cache Misses?

- Cache misses lead to backend storage (e.g., S3, GCS) accesses
- Block index files fetched directly from S3 -> slower query lookup.
- Chunks retrieved and decompressed -> slower data fetch.
- Metadata loaded from storage -> slower organizational steps.

This can significantly increase query latency depending on the backend's responsiveness.

### Optimizing Cache Usage
- Ensure Index Cache is optimized to improve lookup speed.
- Leverage Chunks Cache for frequently queried or recent data.
- Use Metadata Cache for queries hitting large time ranges or multiple blocks.
- Configure backends like Memcached or Redis to scale caches efficiently.




Technically:

If you're migrating from Consul to Memberlist, the prefix can safely be omitted in the configuration.
Memberlist doesn’t recognize or need the prefix field because it doesn’t use a centralized key-value store.


  memberlist:
    bind_port: 7946
    join_members:
      - cortex-distributor-headless
      - cortex-ingester-headless
      - cortex-query-frontend-headless
      - cortex-store-gateway-headless


memcache issue
https://github.com/cortexproject/cortex-helm-chart/issues/346


comapction_strategy vs sharding_strategy

sharding_strategy:
- run compactions on multiple compactor instances. Just scaling to 2 compactors wont work as both will try to comapct same block if in default mode
- shuffle sharding deduplicaates so only one compactor insttance will compcat particular block at at time

compaction_strategy:
- default jsut compacts based  on time range which is 2h , 6h, 12h etc
- partition strategy uses compaction by labels instead of just time range

https://cortexmetrics.io/docs/proposals/timeseries-partitioning-in-compactor/#partitioning-strategy


# Data

## Ingester

k exec -it cortex-ingester-0 -- du -sh /data/tsdb/fake/wal

### T1
- 90K - 500Mb wal size
- wal replay : total_replay_duration=1.669341042s
- approx 3 mins for ingester shutdown
- uptime is around 50s

### T2 (with snappy and flush)
- 90K - 380Mb wal size - slight improvement
-  total_replay_duration=777.037093ms
- 4 mins to deletye ingester
- uptime 40s


# Multi tenant
- In cortex config, `auth_enabled: true`
- In prometheus remote_write , `X-Scope-OrgID` gives tenantID
```
    remoteWrite:
      - url: http://cortex-distributor.cortex.svc.cluster.local:8080/api/v1/push
        headers:
          X-Scope-OrgID: kind-local
```

To verify

- `sum(cortex_ingester_active_series) by (user)`
- Not all metrics support user label
- You can also berify in S3


Every tenant has a subfolder in s3. every tenant has its own bucket_index


# Helm

### Release

```
  - name: cortex
    namespace: cortex
    createNamespace: true
    chart: cortex-helm/cortex
    values:
      - values/cortex.yaml
    set:
      # Requires you to export below envs locally
      - name: config.blocks_storage.s3.access_key_id
        value: {{ requiredEnv "AWS_ACCESS_KEY_ID" }}
      - name: config.blocks_storage.s3.secret_access_key
        value: {{ requiredEnv "AWS_SECRET_ACCESS_KEY" }}
```

### Value

```
    s3:
      endpoint: "s3.us-east-1.amazonaws.com"
      bucket_name: "cortex-kvs-1"
      secret_access_key: ""
      access_key_id: ""
```