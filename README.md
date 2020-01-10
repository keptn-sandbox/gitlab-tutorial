# dynatrace-pipeline

This is a demo project how to integrate dynatrace within your CI/CD pipeline

Branches:

- master: This is the Pipeline for your application
- keptn_infra: Infrastructure provisioning
  - EKS Cluster
  - Installation of Dynatrace Oneangent
  - Configuration of Dynatrace Tenant with tagging rules
  - Setup Cluster Monitoring in Dynatrace
  - Setup keptn with quality gates
  - Configure route53 domain for keptn
  - Installation of Helm
  - Setup AWS ALB Controller
