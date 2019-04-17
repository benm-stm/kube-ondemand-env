# envOnDemand
This is an example of spawning ondemand envs.
The solution is splitted into 3 parts:
1- **deployment** chart which will spawn ondemand envs on an isolated cluster called dev in the project on a separate namespace below a sample command wich can be launched via the CI:
```
helm upgrade --install --namespace=on-demand-env ${CI_COMMIT_REF_NAME}-fake-service fake-service -f fake-service/sandbox.yaml --set onDemandEnv.enabled=true --set onDemandEnv.prefix=${CI_COMMIT_REF_NAME}
```
2- **dockerfile_cleanup** to build the deployment cleanup image(**dockerfile**) and a chart **helm** to deploy it one time when bootstrapping the development cluster

*PS: i made the choice to deploy system related deployments like the ingress controller, the external-dns ... in the default namespace and the on demand env on a name space called on-deman-env to ease the cleanup of the old deployments*