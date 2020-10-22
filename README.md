# azure-sphere-devcontainer
Azure Sphere uses Dev Container

## Build a Azure Sphere SDK Docker image

```bash
# Builds the Azure Sphere SDK Docker image tagged as liydu/azsphere-docker-devcontainer
$ docker build -t liydu/azsphere-docker-devcontainer \
   --rm=true --force-rm=true .
```

## Setup Host environment

The azsphere-docker standard aliases are set with the azsphere-docker-aliases-set script:

```bash
# Set the standard azsphere-docker aliases 
$ source azure-sphere-devcontainer/scripts/azsphere-docker-aliases-set.sh
```

From this point onwards, when invoking the build tools, those will all refer to the Azure Sphere SDK Docker Container. You can always check which aliases are currently set in the Host with the alias command:

```bash
$ alias | grep 'azsphere*'
```

To unset the aliases:

```bash
# Unset the standard azure-sphere-devcontainer aliases 
$ source azure-sphere-devcontainer/scripts/azsphere-docker-aliases-unset.sh
```