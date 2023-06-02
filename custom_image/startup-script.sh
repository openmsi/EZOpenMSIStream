#/bin/bash
# export MODULE=DataFileDownloadDirectory
export TOPIC_NAME=ucsb_indentation_data
# $MODULE data --config config.config --topic_name $TOPIC_NAME
# python -m custom_folder.containerized_alpss.alpss_stream_processor --topic_name $TOPIC_NAME --mode 'memory' --download_regex '^..-{2}\d{8}-{2}\d{5}.txt$' --config config.config --output_dir data --out_files_dir /custom_folder/containerized_alpss/out_files_dir/
python -m ALPSS.containerized_alpss.alpss_stream_processor --topic_name ucsb_indentation_data --mode 'memory' --download_regex '^..-{2}\d{8}-{2}\d{5}.txt$' --config /srv/hemi01-j01/EZOpenMSIStream/custom_image/config.config --output_dir /srv/hemi01-j01/dmref/laser_shock_lab/ALPSS/containerized_alpss/exp_data_dir --out_files_dir /srv/hemi01-j01/dmref/laser_shock_lab/ALPSS/containerized_alpss/out_files_dir/
