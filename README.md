# EZ_openMSIStream

Welcome to EZ_openMSIStream, an easy way to deploy ANY OpenMSIStream module (i.e., DataFileUploadDirectory,DataFileStreamProcessor) in a Docker image, built on the official OpenMSIStream image: https://hub.docker.com/r/openmsi/openmsistream. <br>

The main functionality resides in startup-script.sh, which allows you to write the openmsistream module and command that you need. <br>
To build a docker image, The Dockerfile will move the necessary Kafka config file and startup-script.sh to the docker container. <br>
Then, one can then: 
- run the startup script in the background as a Docker Daemon. It is useful to run the openmsistream module in perpetuity.
- run the startup script inside a bash shell. It is useful to control the openmsistream module if you want to start/interrupt it as desired, change some of the code in live, interact with the module via CLI, etc. 


## Steps

- edit your environnment variable in openmsi.env
- edit your script in startup-script.sh 

### As a Docker Daemon

```
docker build -t [IMAGE_TAG] .

sudo docker run -it -d -v [TARGET_FOLDER]:/home/openmsi/data:z --env-file openmsi.env --name [CONTAINER_NAME] [IMAGE_ID]
```


### As a script in bash cell

- Uncomment the ENTRYPOINT line in the Dockerfile <br>

After building and running the image with the above instructions: <br>

```
docker exec -it [CONTAINER_ID] bash
. ./startup-script.sh
```

Note: the openmsistream module will run as long as the shell is alive. **Killing the shell means Killing the module.**