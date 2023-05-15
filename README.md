# EZ_openMSIStream

Welcome to EZ_openMSIStream, an easy way to deploy ANY OpenMSIStream module (i.e., DataFileUploadDirectory) in a Docker image, built on the official OpenMSIStream image. <br>

### 1) Universal Steps

- Install Docker
- Pull official OpenMSIstream image (https://hub.docker.com/r/openmsi/openmsistream)

```
docker pull openmsi/openmsistream
```
- Extract code base from this repository via Git commands, or downloading the repo as a zip
- Create openmsi.env with the necessary 3 credentials, and additional environnment variables that you might need:

```
CONFLUENT_BOOTSTRAP_SERVERS=
CONFLUENT_USERNAME=
CONFLUENT_PASSWORD=
```

- edit config.config to set up the streaming pipeline and parameters (i.e., client.id)


### 2) Use OpenMSIStream with the default image

With this option, all the user needs is to run a few commands from the Command Line Interface (CLI).

#### As a Docker Daemon

```
docker run -d -v [TARGET_FOLDER]:/home/openmsi/data -v local.config:/local.config --env-file openmsi.env openmsi/image [OPENMSISTREAM COMMAND]
```

#### As a script in bash cell

```
docker run -it -v [TARGET_FOLDER]:/home/openmsi/data -v local.config/local.config --env-file openmsi.env --entrypoint /bin/bash openmsi/openmsistream
```

### 3) Use OpenMSIStream with a custom image

This method allows you to create a custom Docker image that runs your OpenMSIStream command in a bash script.

#### Step 1

Edit your script in startup-script.sh 

#### As a Docker Daemon

```
docker build -t [IMAGE_TAG] .

docker run -it -d -v [TARGET_FOLDER]:/home/openmsi/data:z --env-file openmsi.env --name [CONTAINER_NAME] [IMAGE_ID]
```

#### As a script in bash cell

- Uncomment the ENTRYPOINT line in the Dockerfile <br>

After building and running the image with the instructions in 2) a): <br>

```
docker exec -it [CONTAINER_ID] bash
. ./startup-script.sh
```

#### Notes

Note: the permissions on the TARGET_FOLDER will be inherited FROM the local kernel/system on which you're building/running TO the Docker image/container (see more details: https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf). <br>
OpenMSIStream requires read, write and execute permissions, hence, the permissions on the TARGET_FOLDER must be set using your local kernel PRIOR to running the docker image for the openmsistream module to run properly. Otherwise, your image won't run correctly, and one will get PermissionError  (```[Errno 13] Permission denied:```) or others. such as:

```
PermissionError: [Errno 13] Permission denied: '/home/openmsi/data/DataFileDownloadDirectory.log'
```

Note: **Killing the shell means Killing the module.** the openmsistream module will run as long as the shell is alive. 