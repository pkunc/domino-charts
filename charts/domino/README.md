# domino

A Helm chart for HCL Domino server

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 12.02.0](https://img.shields.io/badge/AppVersion-12.02.0-informational?style=flat-square)

## Prerequisites

- Kubernetes cluster 1.22+
- Helm 3.0.0+
- [Persistent Volumes (PV)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) provisioner support in the underlying infrastructure.
- Domino container image, created with the [domino-container](https://github.com/HCL-TECH-SOFTWARE/domino-container) building script and uploaded to a private container registry.

## Installation

### Add Helm Repository

```
helm repo add pkunc https://pkunc.github.io/domino-charts/
helm repo update
```

### Configure the chart

- Create your config file with values. You can copy one of the demo files in the `examples` folder and update the values.
- (Optional) Copy ID files to the dedicated folder.

### Install the chart

Run the command:

```
helm upgrade <server_name> pkunc/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/<server_name>.yaml \
  --set-file files.certID=cert.id \
  --set-file files.serverID=server.id \
  --set-file files.adminID=admin.id

```

`<server_name>.yaml` is your config file with custom values.

**Example:**

```
helm upgrade castor pkunc/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/castor-lke.yaml \
  --set-file files.certID=examples/ids/cert.id \
  --set-file files.serverID=examples/ids/server-castor.id \
  --set-file files.adminID=examples/ids/admin.id
```

## Uninstallation

To uninstall/delete the `<server_name>` deployment:
```
helm uninstall <server_name> -n domino
```

**Example:**
```
helm uninstall castor -n domino
```

## Configuration

The following table lists the configurable parameters of the Domino chart and the default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certManager.createIssuer | bool | `true` | Should ClusterIssuer resource for Let's Encrypt be crearted? |
| certManager.leCertificate | string | `"staging"` | Type of Let's Encrypt certificate authority ("staging" or "prod") |
| certManager.leEmail | string | `"name@example.com"` | Email used when creating a profile for Let's Encrypt |
| domino.admin.firstName | string | `"Super"` | Administrator first name |
| domino.admin.idFileName | string | `"admin.id"` | Admin ID filename. Used when useExistingAdminID = true. |
| domino.admin.lastName | string | `"Admin"` | Administrator last name |
| domino.admin.password | string | `"password"` | Admin ID password |
| domino.admin.useExistingAdminID | bool | `false` | Set "true" if you want to use existing admin.id |
| domino.idVault.idPassword | string | `"password"` | ID Vault password |
| domino.network.hostName | string | `"domino.example.com"` | Server DNS host name |
| domino.org.certifierPassword | string | `"SecretPassw0rd"` | Cert ID password |
| domino.org.idFileName | string | `"cert.id"` | Cert ID filename. Used when useExistingCertifierID = true. |
| domino.org.orgName | string | `"DemoOrg"` | Organization name ("DemoOrg" in "Domino/DemoOrg @ DemoDomain") |
| domino.org.useExistingCertifierID | bool | `false` | Set "true" if you want to use existing certr.id |
| domino.server.domainName | string | `"DemoDomain"` | Domain name ("DemoDomain" in "Domino/DemoOrg @ DemoDomain") |
| domino.server.idFileName | string | `"server.id"` | Server ID filename. Used when useExistingServerID = true. |
| domino.server.name | string | `"Domino"` | Server common name ("Domino" in "Domino/DemoOrg @ DemoDomain") |
| domino.server.serverTitle | string | `"Demo Server"` | Server title (description) |
| domino.server.type | string | `"first"` | Server type ("first" or "additional" ) |
| domino.server.useExistingServerID | bool | `false` | Set "true" if you want to use existing server.id |
| image.imageCredentials.password | string | `"SecretPassw0rd"` | Password for a private container registry |
| image.imageCredentials.registry | string | `"registry.showcase.blue"` | Hostname of a private container registry |
| image.imageCredentials.username | string | `"dominolab"` | Username for a private container registry |
| image.name | string | `"hclcom/domino"` | Name of the Domino server container image |
| image.tag | string | `"latest"` | Tag of the Domino server container image (usually a version number or "latest") |
| ingress.class | string | `"traefik"` | Ingress class. Much match "kubectl get ingressclass". |
| ingress.enabled | bool | `true` | Should Domino HTTP traffic be exposed through Ingress Controller? |
| ingress.letsEncryptEnabled | bool | `true` | Should Ingress Rule ise Let's Encrypt as a Certificate Issuer? |
| ingress.tls | bool | `false` | Enable TLS in Ingress Rule? (If "true", Ingress wil provide handle TLS communication with the clients.) |
| install.idsDir | string | `"/tmp"` | Path where IDs are copied from mounted directory |
| install.idsMountedDir | string | `"/local/ids"` | Path where IDs are mounted during pod creation |
| install.mountIds | bool | `true` | Set "true" when you want to keep existing IDs mounted to the pod. Set "false" when you do not want mount existing IDs to the pod anymore. Tip: use "true" during the first setup, then change to "false". |
| logs.dominoStdOut | string | `"yes"` | Send Domino console log to the pod standard output (so it could be read using kubectl logs) |
| persistence.size | string | `"4Gi"` | Size of the data volume (/local/notesdata) |
| persistence.storageClass | string | `""` | Specify the StorageClass used to provision the volume. Must be one of the classes in "kubectl get storageclass". If not specified, a default StorageClass is used (if exists). |
| service.enabled | bool | `true` | Should some ports be exposed outside of the cluster? |
| service.externalIP | string | `"10.20.30.40"` | Used when service.type = ClusterIP. IP where the service should be exposed. |
| service.http.expose | bool | `false` | Should HTTP be exposed directly? |
| service.http.port | int | `3080` | Number of exposed HTTP port (probably NOT 80, because it is usually occupied by Ingress Controller service) |
| service.https.expose | bool | `false` | Should HTTPS be exposed directly? |
| service.https.port | int | `3443` | Number of exposed HTTP port (probably NOT 443, because it is usually occupied by Ingress Controller service) |
| service.nrpc.expose | bool | `true` | Should NRPC be exposed directly? |
| service.nrpc.port | int | `1352` | Number of exposed NRPC port (could be 1352) |
| service.type | string | `"LoadBalancer"` | Service type ("LoadBalancer" or "ClusterIP") |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Petr Kunc | <petr.kunc@gmail.com> | <http://petrkunc.net> |

## Credits

Inspired and based on a great work by [Daniel Nashed](https://github.com/Daniel-Nashed) and [Thomas Hampel](https://github.com/thampel).
