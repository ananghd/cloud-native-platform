# cloud-native-platform

My project that demonstrating end-to-end DevOps practices on AWS and Kubernetes. It covers infrastructure as code, CI/CD, GitOps delivery, observability, autoscaling, and security in one workflow.

## Architecture

```mermaid
flowchart LR
    Dev[Developer] -->|push / MR| Repo[Git Repository]
    Repo -->|CI pipeline| CI[GitHub Actions]
    CI -->|build and push| Registry[Container Registry]
    CI -->|terraform plan| TF[Terraform]
    TF -->|provision| AWS[AWS: VPC, EKS, RDS, IAM]
    Repo -->|sync| Argo[Argo CD]
    Argo -->|deploy| EKS[EKS Cluster]
    EKS -->|metrics| Prom[Prometheus]
    EKS -->|logs| Loki[Loki]
    Prom --> Graf[Grafana]
    Loki --> Graf
