# EZOpenMSIStream

Welcome to EZOpenMSIStream, an easy way to deploy ANY OpenMSIStream module (i.e., DataFileUploadDirectory) in ANY way (i.e., Linux/Windows Daemons, Docker image, Runnable) built on the official OpenMSIStream image. <br>

### 1) Get Started
### 1) a) Universal Steps

- Install Docker (https://docs.docker.com/get-docker/)
  - Optional: install github for future use (https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
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

### 1) b) What you need to use OpenMSIStream

**Vocabulary used below:** <br>
- TARGET_FOLDER = folder where data is to be produced or consumed. Whatever name the original folder has, it will always be represent as 'data' in the docker image <br> 
- OPENMSISTREAM_COMMAND = the command that you will run using the OpenMSIStream modules. This will be the command in your startup-script.sh if you're running a custom image. 
  - Example: DataFileDownloadDirectory data --config config.config --topic_name ucsb_indentation_data <br> 

- IMAGE_TAG = Name of the image set during ```docker build``` with --tag / -t option <br> 
- IMAGE_ID = ID of the image generated during ```docker build```. It is passed to ```docker run``` to instantiate the image in a container  <br> 
- CONTAINER_NAME = Name of the container that is generated during ```docker run``` in which the image is running. 
- CONTAINER_ID = ID of the container that is generated during ```docker run``` in which the image is running. 

If you need to move custom code to the docker image, which is almost always the case when using a dataFileStreamProcessor, mount additional folders with ```-v  [CUSTOM_FOLDER_PATH]:/home/openmsi/custom_folder```

### 2) Use OpenMSIStream as a Daemon

for Windows services: https://openmsistream.readthedocs.io/en/latest/user_info/services.html
 
for Linux services: https://baykara.medium.com/how-to-daemonize-a-process-or-service-with-systemd-c34501e646c9

### 3) Use OpenMSIStream with Docker
### 3) a) Use OpenMSIStream with the default Docker image

With this option, all the user needs is to run a few commands from the Command Line Interface (CLI).
**The custom_image folder won't be used**.

#### As a Docker Daemon

```
docker run -d -v [TARGET_FOLDER]:/home/openmsi/data -v $(pwd)/config.config:/home/openmsi/config.config  --env-file openmsi.env openmsi/image [OPENMSISTREAM_COMMAND]
```

#### As a script in bash shell

```
docker run -it -v [TARGET_FOLDER]:/home/openmsi/data -v $(pwd)/config.config:/home/openmsi/config.config  --env-file openmsi.env --entrypoint /bin/bash openmsi/openmsistream

```

### 3) b) Use OpenMSIStream with a custom Docker image

Inside custom_image/, this method allows you to create a custom Docker image (Dockerfile) that runs your OpenMSIStream command in a bash script (startup-script.sh).

#### As a Docker Daemon

```
docker build -t [IMAGE_TAG] Dockerfile

docker run -d -v [TARGET_FOLDER]:/home/openmsi/data:z --env-file ../openmsi.env --name [CONTAINER_NAME] [IMAGE_ID]
```

#### As a script in bash shell 

```
docker build -t [IMAGE_TAG] Dockerfile

docker run -it --entrypoint bash -d -v [TARGET_FOLDER]:/home/openmsi/data:z --env-file ../openmsi.env --name [CONTAINER_NAME] [IMAGE_ID]
```

After building and running the image, open a bash shell via which you can access the docker image: <br>

```
docker exec -it [CONTAINER_ID] bash
. ./startup-script.sh
```

### 3) c) Pros and Cons

Both approaches require maintaining a local configuration and running Docker locally, whether interactively or non-interactively. Both will have filesystem permission issues (see below).

- default image
  - :heavy_plus_sign: simpler image management
  - :heavy_minus_sign: more complex command line

- custom image
  - :heavy_plus_sign: simpler configuration management?
  - :heavy_plus_sign: beginner-friendly with trackable commands in files
  - :heavy_minus_sign: complex image management
    - images and containers must be built and deleted **manually** after end of use (see ```docker ps``` to track). If not, the images and containers will continue to reside in memory 
    - in case a user wants to build an official image on Docker Hub, there will be significant management efforts as images must be rebuilt, tested, and pushed with each new version

#### Permission issues

- Permissions on the TARGET_FOLDER: <br>
These will be inherited FROM the local system on which you're building TO the Docker image (see more details in this [article](https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf)). <br>
OpenMSIStream requires read, write and execute permissions, hence, the permissions on the TARGET_FOLDER must be set using your local kernel PRIOR to running the docker image for the openmsistream module to run properly. 

- Permissions on the mounted files such as config.config, etc: <br>
A pro of the custom image mode is that it handles the permissions of those files (see --chown/chmod Dockerfile). <br> 
However, with the default image mode, the permissions must also be configured in your local system PRIOR to running the docker image. 

An alternative to manage the issues is to run docker as particular UID/GID.

```docker run -it --user "$(id -u ${USER}):$(id -g ${USER})" [REST OF THE COMMAND CALL]```



#### Con of running in bash shell mode (independent of official or custom image)

Killing the shell means Killing the module! the openmsistream module will run as long as the shell is alive. 

### 3) d) Adding additional custom files or folders 

Uses of OpenMSIStream producers and consumers is largely unchanged. However, for OpenMSIStream tools like a file stream processor, a way of applying any function to files from the stream, the function changes on the use case. It can be an indentation or a spectral analysis; an SEM or XRD characterization; etc. <br>

To handle such case, one must mount additional folder(s) containing the file stream processor functions, as well as an extra folder to write the results of your functions if needed. 

### 4) Tracker

Use a tracker.json to document the process (see tracker.txt for info details)