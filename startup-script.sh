#/bin/bash
export MODULE=DataFileDownloadDirectory
export TARGET_FOLDER=indentation
export CONFIG_FILE=config.config
export TOPIC_NAME=ucsb_indentation_data

$MODULE $TARGET_FOLDER --config $CONFIG_FILE --topic_name $TOPIC_NAME