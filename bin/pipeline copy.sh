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

# for all the videos in the folder people, create a folder with the name of the video without the extension and inside it
# create a folder called words_alignment, other called speech_analysis
# take care about spaces in the name of the video
for f in "$(dirname "$1")/$(basename "$2")/people"/*; do
    # mkdir without the extension of the video
    f="${f%.*}"
    mkdir -p "$f/words_alignment"
    mkdir -p "$f/speech_analysis"
    mkdir -p "$f/rawData"
    mkdir -p "$f/skeleton"
done

# activate the virtual environment for python
#eval "$(conda shell.bash hook)"
source /home/raul/conda/etc/profile.d/conda.sh 
conda activate web_pipeline_01

# for all the videos in the folder people, run whisper_timestamped
# example whisper_timestamped 2016-02-26_2200_US_CNN_Situation_Room_5467.7-5472.67_the_following_year.mp4 --model large --accurate --output_dir . --output_format csv
# take care about spaces in the name of the video
for f in "$(dirname "$1")/$(basename "$2")/people"/*.mp4; do
    # remove the extension for output_dir
    output_dir="${f%.*}"
    people_dir="$(dirname "$1")/$(basename "$2")/people"

    whisperx --model large --output_format all --output_dir "$output_dir/words_alignment" "$f"

    # copy "$output_dir/words_alignment"filename.mp4.srt to $1 filename.srt removing .mp4  to have subtitles in same folder than the video
    echo "cp $output_dir/words_alignment/$(basename "$f" .mp4).srt" "$people_dir/$(basename "$f" .mp4).srt"
    cp "$output_dir/words_alignment/$(basename "$f" .mp4).srt" "$people_dir/$(basename "$f" .mp4).srt"
    
done

# for all the videos in the folder people, run speech_analysis
for f in "$(dirname "$1")/$(basename "$2")/people"/*.mp4; do
    # remove the extension for output_dir
    output_dir="${f%.*}"
    speech_analysis -v "$f" -c "$output_dir/speech_analysis/speech_analysis.csv"
done

conda deactivate

## RUN OPENPOSE
# save current directory
currentDir="$(pwd)"

cd /usr/local/openpose

for f in "$(dirname "$1")/$(basename "$2")/people"/*.mp4; do
    # remove the extension for output_dir
    output_dir="${f%.*}"
    # get absolute path of the video file
    f="$(realpath "$f")"
    # get absolute path of the output_dir
    output_dir="$(realpath "$output_dir")"
    ./build/examples/openpose/openpose.bin --video "$f" --face --hand  --write_json "$output_dir/rawData" --display 0  --render_pose 0
    ./build/examples/openpose/openpose.bin --video "$f" --write_video "$output_dir/skeleton/skeleton.avi" --display 0 --face 

done

cd "$currentDir"

cd bin

echo "--------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------"
ls 
for f in "$(dirname "$1")/$(basename "$2")/people"/*.mp4; do
    output_dir="${f%.*}"
    echo "Rscript run_dfMaker.R $output_dir/rawData $output_dir/dfMaker"
    mkdir -p "$output_dir/dfMaker"
    Rscript run_dfMaker.R "$output_dir/rawData" "$output_dir/dfMaker"

done

#echo Rscript dfMakerexecute.R  "$f/rawData" "$f/raw" "$f/tidy"
echo "--------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------"


cd ..


# zip the file again in the original folder with the name of the video
# take care about spaces in the name of the video but dont include all the path, only the video name folder
cd "$(dirname "$1")"
zip -r "$(basename "$2").zip" "$(basename "$2")"
