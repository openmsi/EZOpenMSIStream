# EZ_openMSIStream

Welcome to EZ_openMSIStream, an easy way to deploy ANY OpenMSIStream module (i.e., DataFileUploadDirectory) in a Docker image, built on the official OpenMSIStream image (https://hub.docker.com/r/openmsi/openmsistream) <br>

The main functionality resides in startup-script.sh, which allows you to write the openmsistream module and execution commands that you need. <br>
To build a docker image, the Dockerfile will first import the official openmsistream image. <br> 
Then, it will move the loal Kafka config file and startup-script.sh to the docker container. <br>
Then, one can then: 
- run the startup script in the background as a Docker Daemon. It is useful to run the openmsistream module in perpetuity.
- run the startup script inside a bash shell. It is useful to control the openmsistream module if you want to start/interrupt it as desired, change some of the code in live, interact with the module via CLI, etc. 


## 1) Steps

- Install Docker
- Pull official OpenMSIstream image

```
docker pull openmsi/openmsistream
```

- Create openmsi.env with the necessary 3 credentials, and more environnment variables based on your use case:

```
CONFLUENT_BOOTSTRAP_SERVERS=
CONFLUENT_USERNAME=
CONFLUENT_PASSWORD=
```

- edit config.config (i.e., client.id)


## 2) with the default image

### 2 a) as a Docker Daemon

```
docker run -d -v [TARGET_FOLDER]:/home/openmsi/data -v local.config:/local.config --env-file openmsi.env openmsi/image [OPENMSISTREAM COMMAND]
```

### 2) b) As a script in bash cell

```
docker run -it -v [TARGET_FOLDER]:/home/openmsi/data -v local.config/local.config --env-file openmsi.env --entrypoint /bin/bash openmsi/openmsistream
```

## 3) with a custom image

- edit your script in startup-script.sh 

### 3) a) As a Docker Daemon

```
docker build -t [IMAGE_TAG] .

docker run -it -d -v [TARGET_FOLDER]:/home/openmsi/data:z --env-file openmsi.env --name [CONTAINER_NAME] [IMAGE_ID]
```

### 3) b) As a script in bash cell

- Uncomment the ENTRYPOINT line in the Dockerfile <br>

After building and running the image with the instructions in 2) a): <br>

```
docker exec -it [CONTAINER_ID] bash
. ./startup-script.sh
```

### Notes

Note: the permissions on the TARGET_FOLDER will be inherited FROM the local kernel/system on which you're building/running TO the Docker image/container (see more details: https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf). <br>
OpenMSIStream requires read, write and execute permissions, hence, the permissions on the TARGET_FOLDER must be set using your local kernel PRIOR to running the docker image for the openmsistream module to run properly. Otherwise, your image won't run correctly, and one will get PermissionError  (```[Errno 13] Permission denied:```) or others. such as:

```
PermissionError: [Errno 13] Permission denied: '/home/openmsi/data/DataFileDownloadDirectory.log'
```

Note: **Killing the shell means Killing the module.** the openmsistream module will run as long as the shell is alive. 