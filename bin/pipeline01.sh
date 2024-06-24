#!/bin/bash

# $1: path to zip file
# $2: name of the video
# $3: id of the video
# $4: hpc user
# $5: hpc host
# $6: hpc key
# $7: hpc command


zip_file="$1"
filename=$(basename "$zip_file")
result_zip_file="$2"
video_id="$3"
hpc_user="$4"
hpc_host="$5"
hpc_key="$6"
hpc_command="$7"

echo "**** CREATE FOLDER ****"
ssh -o "StrictHostKeyChecking no" -i $hpc_key $hpc_user@$hpc_host $hpc_command '{"command":"mkdir","params":["'$video_id'"]}'

echo "**** COPY ZIP FILE ****"
scp -O -o "StrictHostKeyChecking no" -i $hpc_key $zip_file $hpc_user@$hpc_host:MULTIDATA/$video_id/

echo "**** NEW JOB ****"
ssh -o "StrictHostKeyChecking no" -i $hpc_key $hpc_user@$hpc_host $hpc_command '{"command":"new_job","params":["'$video_id'", "'$filename'", "'$result_zip_file'"]}'