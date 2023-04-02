# Domino deployments – Examples
Use the following examplas as an inspiration for creationg your own values files, for deploying Domino server according to your needs.

You will probably need to combine multiple examples to create the final file - for example: using persistent volume + enabling Ingress for HTTP + opening port for NRPC + reusing existing IDs


* Importatnt *
The examples shares the same deployment name, sometime also host name or ports.
Before you try an example, uninstall the previous example with this command:
```
helm uninstall alpha --namespace domino
```




## Default – For testing the basics
**Start here.** \
Just the Helm chart default values. \
Creates new Domino server in a new Domino domain. \
Web access (via Ingress) is enabled.

**Usecase:** Primary for testing the environment. The server has no persistent volume attached, so the Domino data directory is lost when a pod is recreated. Once you deploy a Domino server witht he defautl values, you can continue with more complex configurations.

**Filename:** `none`

**Command:**

```
helm upgrade alpha pkunc/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --set image.imageCredentials.registry=registry.company.com \
  --atomic
```

Check that you deployed the Domino pod correctly:
```
kubectl logs -n domino alpha-domino-0
```

Since we did not specify a correct hostname, nor expose any ports, you cannot connect to Domino yet. \
Try the following examples that allows you to parametrize your Domino to allow access from web browser or a Notes client.


## Organization, server and domain names
Creates a new Domino server in a new Domino domain, with custom organazation name, server name and administrator name.


**Usecase:** You will use these parameters in almost all server deployments.

**Filename:** `name-org-server-admin.yaml`

**Command:**

```
helm upgrade alpha pkunc/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/name-org-server-admin.yaml \
  --atomic
```



## Persistent volume
Creates a Persistent Volume Claim and assigns it to the Domino pod. You need to specify a StorageClass, provided by your Kubernetes provider.

**Add these setings to all servers where you want to keep Domino data directory.**

**Usecase:** You need to add Persistent Volume to all your Domino servers in production.

**Filename:** `persistent-volume.yaml`

**Command:**

```
helm upgrade alpha pkunc/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/persistent-volume.yaml \
  --atomic
```

## Web access – Ingress with Let's Encrypt 


## NRPC access


## Nomad Web access


## Reinstalling server with existing IDs (cert, server, admin)
Creates a Domino server with existing identities. \
Uses existing cert.id, server.id and admin.id. \

**Usecase:** Good for dev / testing / education servers, where you want to reuse existing server identity. \
Also an example of config values thta you can reuse in more complex server configurations.

**Filename:** `existing-ids.yaml`

**Command:**
```
helm upgrade alpha pkunc/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/existing-ids.yaml \
  --set-file files.certID=examples/ids/Space/cert.id \
  --set-file files.serverID=examples/ids/Space/server-alpha.id \
  --set-file files.adminID=examples/ids/Space/admin.id \
  --atomic
```



## New server with existing IDs (cert, admin)    TODO
Creates new Domino server, in a new Domino domain. \
Uses existing cert.id and admin.id. \

**Usecase:** Good for dev / testing / education servers, where you want to reuse existing admin ID.

**Filename:** `reuse-admin.yaml`

**Command:**
```
helm upgrade alpha pkunc/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/reuse-admin.yaml \
  --set-file files.certID=examples/ids/cert.id \
  --set-file files.adminID=examples/ids/admin.id \
  --atomic
```

## New server with existing IDs (cert, admin, server)
Similar as the previous usecase, but this time also server.id is used.

**Usecase:** Good for dev / testing / education servers, where you want to reuse existing admin and server IDs.

**Filename:** `reuse-admin-server.yaml`

**Command:**
```
helm upgrade alpha pkunc/domino \
  --install \
  --namespace domino \
  --create-namespace \
  --values examples/reuse-admin.yaml \
  --set-file files.certID=examples/ids/cert.id \
  --set-file files.serverID=examples/ids/server.id \
  --set-file files.adminID=examples/ids/admin.id \
  --atomic
```

