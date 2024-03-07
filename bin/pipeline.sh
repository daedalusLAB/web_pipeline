#!/bin/bash

# $1: path to zip file
# $2: name of the video
# $3: id of the video
# $4: hpc user
# $5: hpc host
# $6: hpc key
# $7 folder to copy the zip file and results


zip_file="$1"
filename=$(basename "$zip_file")
result_zip_file="$2"
video_id="$3"
hpc_user="$4"
hpc_host="$5"
hpc_key="$6"
folder="$7"

# create a remote folder with the id of the video
#ssh -i "$hpc_key" "$hpc_user"@"$hpc_host" "mkdir -p $folder/$video_id"
echo "ssh -i $hpc_key $hpc_user@$hpc_host mkdir -p $folder/$video_id"
# copy zip file to hpc server
#scp -i "$hpc_key" "$zip_file" "$hpc_user"@"$hpc_host":"$folder/$video_id/$filename"
echo "scp -i $hpc_key $zip_file $hpc_user@$hpc_host:$folder/$video_id/$filename"
# run the pipeline in the hpc server
echo "ssh -i $hpc_key $hpc_user@$hpc_host bash pipeline.sh $folder/$video_id/$filename $result_zip_file"
#ssh -i "$hpc_key" "$hpc_user"@"$hpc_host" "bash pipeline.sh $folder/$video_id/$filename $result_zip_file"

sleep 20