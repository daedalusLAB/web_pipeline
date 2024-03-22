#!/bin/bash

# $1: path to zip file
# $2: name of the video
# $3: id of the video
# $4: hpc user
# $5: hpc host
# $6: hpc key


zip_file="$1"
filename=$(basename "$zip_file")
result_zip_file="$2"
video_id="$3"
hpc_user="$4"
hpc_host="$5"
hpc_key="$6"

# create a remote folder with the id of the video
ssh -o "StrictHostKeyChecking no" -i $hpc_key $hpc_user@$hpc_host mkdir -p MULTIDATA/$video_id
# copy zip file to hpc server
scp -o "StrictHostKeyChecking no" -i $hpc_key $zip_file $hpc_user@$hpc_host:MULTIDATA/$video_id/
# run the pipeline in the hpc server
ssh -o "StrictHostKeyChecking no" -i $hpc_key $hpc_user@$hpc_host bash MULTIDATA/pipeline.sh MULTIDATA/$video_id/$filename $result_zip_file