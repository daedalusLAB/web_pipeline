#!/bin/bash

# pipeline.sh /export/home/raul/miscosas/repos/web_pipeline/public/uploads/video/zip/12/approach.zip "Prueba de pepito"

# $1: path to zip file
# $2: name of the video

# Create a folder in same directory than zip file called as the name of the video. Inside it, create 3 folders: all_videos, people, no_people
# take care about spaces in the name of the video
mkdir -p "$(dirname "$1")/$(basename "$2")/all_videos"
mkdir -p "$(dirname "$1")/$(basename "$2")/people"
mkdir -p "$(dirname "$1")/$(basename "$2")/no_people"

# Unzip the file in the folder all_videos
unzip "$1" -d "$(dirname "$1")/$(basename "$2")/all_videos"

# Run the python script to detect people in the videos
# is_there_a_person_in_the_video --videos all_videos/ --discarded_videos nopeople/ --matched_videos people/
is_there_a_person_in_the_video --videos "$(dirname "$1")/$(basename "$2")/all_videos/" --discarded_videos "$(dirname "$1")/$(basename "$2")/no_people/" --matched_videos "$(dirname "$1")/$(basename "$2")/people/"

# zip the file again in the original folder with the name of the video
# take care about spaces in the name of the video but dont include all the path, only the video name folder
cd "$(dirname "$1")"
zip -r "$(basename "$2").zip" "$(basename "$2")"