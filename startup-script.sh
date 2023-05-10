#/bin/bash
export MODULE=DataFileDownloadDirectory
# export TARGET_FOLDER=data
# export CONFIG_FILE=config.config
export TOPIC_NAME=ucsb_indentation_data

$MODULE data --config config.config --topic_name $TOPIC_NAME