ARG ROOT=/home/openmsi

FROM openmsi/openmsistream:latest

WORKDIR ${ROOT}
# ADD --chown=openmsi:openmsi --chmod=777 credentials.sh credentials.sh
ADD --chown=openmsi:openmsi --chmod=777 config.config config.config
ADD --chown=openmsi:openmsi --chmod=777 startup-script.sh startup-script.sh

# CMD . ./credentials.sh

ENTRYPOINT . ./startup-script.sh