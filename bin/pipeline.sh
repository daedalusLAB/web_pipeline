#!/bin/bash -e

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

# for all the videos in the folder people, create a folder with the name of the video without the extension and inside it
# create a folder called words_alignment, other called speech_analysis
# take care about spaces in the name of the video
for f in "$(dirname "$1")/$(basename "$2")/people"/*; do
    # mkdir without the extension of the video
    f="${f%.*}"
    mkdir -p "$f/words_alignment"
    mkdir -p "$f/speech_analysis"
done

    

# activate the virtual environment for python
eval "$(conda shell.bash hook)"
conda activate whisper_timestamped

# for all the videos in the folder people, run whisper_timestamped
# example whisper_timestamped 2016-02-26_2200_US_CNN_Situation_Room_5467.7-5472.67_the_following_year.mp4 --model large --accurate --output_dir . --output_format csv
# take care about spaces in the name of the video
for f in "$(dirname "$1")/$(basename "$2")/people"/*.mp4; do
    # remove the extension for output_dir
    output_dir="${f%.*}"
    whisper_timestamped "$f" --model large --accurate --output_dir "$output_dir/words_alignment" --output_format csv --punctuations_with_words False
done

conda deactivate

# create a folder called words alignmen

# zip the file again in the original folder with the name of the video
# take care about spaces in the name of the video but dont include all the path, only the video name folder
cd "$(dirname "$1")"
zip -r "$(basename "$2").zip" "$(basename "$2")"