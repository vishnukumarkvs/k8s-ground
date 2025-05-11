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
