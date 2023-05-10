ARG ROOT=/home/openmsi
# ARG CONFLUENT_BOOTSTRAP_SERVERS
# ARG CONFLUENT_USERNAME
# ARG CONFLUENT_PASSWORD

FROM openmsi/openmsistream:latest

# ENV CONFLUENT_BOOTSTRAP_SERVERS=$CONFLUENT_BOOTSTRAP_SERVERS
# ENV CONFLUENT_USERNAME=$CONFLUENT_USERNAME
# ENV CONFLUENT_PASSWORD=$CONFLUENT_PASSWORD

WORKDIR ${ROOT}
# ADD --chown=openmsi:openmsi --chmod=777 credentials.sh credentials.sh
ADD --chown=openmsi:openmsi --chmod=777 config.config config.config
ADD --chown=openmsi:openmsi --chmod=777 startup-script.sh startup-script.sh

# CMD . ./credentials.sh

ENTRYPOINT . ./startup-script.sh