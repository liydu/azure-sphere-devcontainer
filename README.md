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
$ source ./scripts/azsphere-docker-aliases-set
```

From this point onwards, when invoking the build tools, those will all refer to the Azure Sphere SDK Docker Container. You can always check which aliases are currently set in the Host with the alias command:

```bash
$ alias
```

To unset the aliases:

```bash
# Unset the standard bxarm-docker aliases 
$ source bxarm-docker/scripts/azsphere-docker-aliases-unset
```