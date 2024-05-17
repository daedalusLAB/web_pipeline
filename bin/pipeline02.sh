#!/bin/bash

zip_file="$1"
filename=$(basename "$zip_file")
result_zip_file="$2"
video_id="$3"
hpc_user="$4"
hpc_host="$5"
hpc_key="$6"
hpc_command="$7"
destination_path="$8"

echo "**** COPY BACK RESULT ****"
scp -O -o "StrictHostKeyChecking no" -i $hpc_key $hpc_user@$hpc_host:MULTIDATA/$video_id/$result_zip_file'.zip' $destination_path 

echo "**** DELETE FOLDER ****"
ssh -o "StrictHostKeyChecking no" -i $hpc_key $hpc_user@$hpc_host $hpc_command '{"command":"delete","params":["'$video_id'"]}'
