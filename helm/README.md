# Helmfile deployments

At present , I have deployed LMA stack using helmfile. Going through all deployments below.

# Cortex

Cortex is a long term solution for storing prometheus time series data.

Features
- Multi tenant
- Cloud Storage
- Higly available
- Horizaontal scalable

# Kube Prometheus Stack (Prometheus, Grafana , KSM, ALertmangaer)

- Prometheus is an open source metrics and monitoring system. It instruments, collects metrics data from all applications which are queryable for analysis.
- Grafana is a visulaization tool which provides dashboards to view metrics and other data. We can connect prometheus as a data source and use grafana for dashboards and querying.
- KSM is kube-state-metrics which is used for collecting additional metrics related to kube deployment.
- Alertmanger handles alerts sent by clients like prometheus server. It does deduplicating, grouping of alerts and send them to configured receivers such as slack.

Features
- Open source
- metric collection

### helm chart

- We are using kube-promemtheus-stack helm chart which downloads all essential components such as grafana, alertmanager etc  mentioned above
- We can also try to install individual components but it is tiresome.

# Minio

Minio is an S3 compatible object storage solution for onprem deployments. I have used this as a backend storage solution for cortex instead of S3.

# Vector

Vector (by datadog) is a lightweeight ultra fast tool for building observability pipelines. Here, we are using vector as a pipeline to push k8s logs to loki.

# Coroot

Coroot is a CNCF incubating project which gives observability on netweorking stack. It uses eBPF technology

# Grafana Beyla

Its a grafana projected which used eBPF tech to provide RED metrics. It also provides exemplars which are comnination of metrics and logs on time based foramt

# Grafana Foundation SDK

The Grafana Foundation SDK allows you to define Grafana resources using common programming languages like Go, TypeScript, and Python. This has several advantages over using Jsonnet:

*   **Familiar Programming Languages**: Developers can use their existing skills and tools without needing to learn the domain-specific language, Jsonnet.
*   **Strong Typing and Compile-Time Error Checking**: The SDK provides strongly-typed builders for creating dashboards and other resources. This allows you to catch errors during compilation, leading to more reliable and robust configurations.
*   **Enhanced Developer Workflow and Tooling**: By using a general-purpose programming language, you can integrate dashboard generation seamlessly into your existing development workflows. This includes better support for IDEs, debuggers, and other standard development tools.
*   **Official Support and Maintenance**: The Grafana Foundation SDK is generated from OpenAPI documents in the Grafana repository, ensuring that it stays up-to-date with new Grafana features.
*   **Extensibility**: The SDK is designed to be extensible, allowing you to define custom types for panels and data sources, which is useful for third-party or private plugins.


