ARG ROOT=/home/openmsi
FROM openmsi/openmsistream:latest

ARG daemon_mode

WORKDIR ${ROOT}
ADD --chown=openmsi:openmsi --chmod=777 config.config config.config
ADD --chown=openmsi:openmsi --chmod=777 startup-script.sh startup-script.sh

ENTRYPOINT . ./startup-script.sh if [[-z "$daemon_mode"]]