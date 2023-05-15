# EZOpenMSIStream

Welcome to EZOpenMSIStream, an easy way to deploy ANY OpenMSIStream module (i.e., DataFileUploadDirectory) in a Docker image, built on the official OpenMSIStream image. <br>

### 1) Universal Steps

- Install Docker (https://docs.docker.com/get-docker/)
- Pull official OpenMSIstream image (https://hub.docker.com/r/openmsi/openmsistream)

```
docker pull openmsi/openmsistream
```
- Create openmsi.env with the necessary 3 credentials, and additional environnment variables that you might need:

```
CONFLUENT_BOOTSTRAP_SERVERS=
CONFLUENT_USERNAME=
CONFLUENT_PASSWORD=
```

- edit config.config to set up the streaming pipeline and parameters (i.e., client.id)

**Note on vocabulary used below:** <br>
TARGET_FOLDER = folder where data is to be produced or consumed. Whatever name the original folder has, it will always be represent as 'data' in the docker image <br> 
OPENMSISTREAM_COMMAND = the command that you will run using the OpenMSIStream modules
- Example: DataFileDownloadDirectory data --config config.config --topic_name ucsb_indentation_data <br> 

IMAGE_TAG = Name of the image set during ```docker build``` with --tag / -t option <br> 
IMAGE_ID = ID of the image generated during ```docker build```. It is passed to ```docker run``` to instantiate the image in a container  <br> 
CONTAINER_ID = ID/Name of the container that is generated during ```docker run``` in which the image is running. 

### 2) Use OpenMSIStream with the default image

With this option, all the user needs is to run a few commands from the Command Line Interface (CLI).
**The custom_image folder won't be used**.

#### As a Docker Daemon

```
docker run -d -v [TARGET_FOLDER]:/home/openmsi/data -v local.config:/local.config --env-file openmsi.env openmsi/image [OPENMSISTREAM_COMMAND]
```

#### As a script in bash shell

```
docker run -it -v [TARGET_FOLDER]:/home/openmsi/data -v local.config/local.config --env-file openmsi.env --entrypoint /bin/bash openmsi/openmsistream
```

### 3) Use OpenMSIStream with a custom image

Inside custom_image/, this method allows you to create a custom Docker image (Dockerfile) that runs your OpenMSIStream command in a bash script (startup-script.sh).

#### Step 1

Edit your script in startup-script.sh 

#### As a Docker Daemon

```
docker build -t [IMAGE_TAG] .

docker run -it -d -v [TARGET_FOLDER]:/home/openmsi/data:z --env-file openmsi.env --name [CONTAINER_ID] [IMAGE_ID]
```

#### As a script in bash shell 

- Uncomment the ENTRYPOINT line in the Dockerfile <br>

After building and running the image with the instructions in 2) a): <br>

```
docker exec -it [CONTAINER_ID] bash
. ./startup-script.sh
```

### 4) Pros and Cons

Both approaches require maintaining a local configuration and running Docker locally, whether interactively or non-interactively. Both will have filesystem permission issues (see below).

- default image
  - :heavy_plus_sign: simpler image management
  - - more complex command line

- custom image
  - :heavy_plus_sign: simpler configuration management?
  - + beginneer-friendly with trackable commands in files
  - - complex image management
    - images and containers must be built and deleted after end of use (see ```docker ps```). If not, the images and containers will continue to reside in memory 
    - in case a user wants to build an official image on Docker Hub, there will be significant management efforts because images must be rebuilt, tested, and pushed with each new version

#### Permission issues

Note: the permissions on the TARGET_FOLDER will be inherited FROM the local kernel/system on which you're building/running TO the Docker image/container (see more details: https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf). <br>
OpenMSIStream requires read, write and execute permissions, hence, the permissions on the TARGET_FOLDER must be set using your local kernel PRIOR to running the docker image for the openmsistream module to run properly. Otherwise, your image won't run correctly, and one will get PermissionError  (```[Errno 13] Permission denied:```) or others. 

To run docker as particular UID/GID:

```docker run -it --user "$(id -u ${USER}):$(id -g ${USER})" [REST OF THE COMMAND CALL]```


#### Con of running in bash shell mode (independent of official or custom image)

**Killing the shell means Killing the module.** the openmsistream module will run as long as the shell is alive. 

### Tracker