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

Edit your script in startup-script.sh as desired

#### As a Docker Daemon

```
docker build -t [IMAGE_TAG] .

docker run -it -d -v [TARGET_FOLDER]:/home/openmsi/data:z --env-file openmsi.env --name [CONTAINER_ID] [IMAGE_ID]
```

#### As a script in bash shell 

- Uncomment the ENTRYPOINT line in the Dockerfile <br>

After building and running the image with the instructions in the section directly above: <br>

```
docker exec -it [CONTAINER_ID] bash
. ./startup-script.sh
```

### 4) Pros and Cons

Both approaches require maintaining a local configuration and running Docker locally, whether interactively or non-interactively. Both will have filesystem permission issues (see below).

- default image
  - :heavy_plus_sign: simpler image management
  - :heavy_minus_sign: more complex command line

- custom image
  - :heavy_plus_sign: simpler configuration management?
  - :heavy_plus_sign: beginner-friendly with trackable commands in files
  - :heavy_minus_sign: complex image management
    - :heavy_minus_sign: images and containers must be built and deleted **manually** after end of use (see ```docker ps``` to track). If not, the images and containers will continue to reside in memory 
    - :heavy_minus_sign: in case a user wants to build an official image on Docker Hub, there will be significant management efforts as images must be rebuilt, tested, and pushed with each new version

#### Permission issues

Permissions on the TARGET_FOLDER: <br>
These will be inherited FROM the local system on which you're building TO the Docker image (see more details in this [article](https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf)). <br>
OpenMSIStream requires read, write and execute permissions, hence, the permissions on the TARGET_FOLDER must be set using your local kernel PRIOR to running the docker image for the openmsistream module to run properly. 

Permissions on the mounted files such as config.config, etc: <br>
A pro of the custom image mode is that it handles the permissions of those files (see --chown/chmod Dockerfile). <br> 
However, with the default image mode, the permissions must also be configured in your local system PRIOR to running the docker image. 

An alternative to manage the issues is to run docker as particular UID/GID.

```docker run -it --user "$(id -u ${USER}):$(id -g ${USER})" [REST OF THE COMMAND CALL]```



#### Con of running in bash shell mode (independent of official or custom image)

Killing the shell means Killing the module! the openmsistream module will run as long as the shell is alive. 

### 5) Tracker