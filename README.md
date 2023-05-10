# EZ_openmsistream

### as a Docker Daemon

```
docker build -t [IMAGE_TAG] .

sudo docker run -it -d -v [TARGET_FOLDER]:/home/openmsi/data:z --env-file  --name [CONTAINER_NAME] [IMAGE_ID]
```


### as a script in bash cell

- Uncomment the ENTRYPOINT line in the Dockerfile <br>
After building and running the image with the above instructions: <br>
```
docker exec -it [CONTAINER_ID] bash
. ./startup-script.sh
```
