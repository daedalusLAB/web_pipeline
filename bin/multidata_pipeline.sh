#!/bin/bash

# $1: path to zip file
# $2: name of the video

# Create a folder in same directory than zip file called as the name of the video. Inside it, create 3 folders: all_videos, people, no_people
# take care about spaces in the name of the video
mkdir -p "$(dirname "$1")/$(basename "$2")/all_videos"
mkdir -p "$(dirname "$1")/$(basename "$2")/people"
mkdir -p "$(dirname "$1")/$(basename "$2")/no_people"

# Unzip the file in the folder all_videos
unzip "$1" -d "$(dirname "$1")/$(basename "$2")/all_videos"

# # check files in all_videos folder ends with .mp4 and don't have extrange characters
# # if not, move the file to no_people folder
# for f in "$(dirname "$1")/$(basename "$2")/all_videos"/*; do
#     if [[ $f == *.mp4 ]]; then
#         echo "File $f is a mp4 file"
#     else
#         echo "File $f is not a mp4 file"
#         mv "$f" "$(dirname "$1")/$(basename "$2")/no_people"
#     fi
# done

# # check also no ;, spaces and other no regular characters in the name of the file
# for f in "$(dirname "$1")/$(basename "$2")/all_videos"/*; do
#     if [[ $f == *[';'@#\$%^\&*()+]* ]]; then
#         echo "File $f has extrange characters"
#         mv "$f" "$(dirname "$1")/$(basename "$2")/no_people"
#     else
#         echo "File $f has not extrange characters"
#     fi
# done

# Run the python script to detect people in the videos
# is_there_a_person_in_the_video --videos all_videos/ --discarded_videos nopeople/ --matched_videos people/
is_there_a_person_in_the_video.py --videos "$(dirname "$1")/$(basename "$2")/all_videos/" --discarded_videos "$(dirname "$1")/$(basename "$2")/no_people/" --matched_videos "$(dirname "$1")/$(basename "$2")/people/"

# delete all_videos folder
rm -rf "$(dirname "$1")/$(basename "$2")/all_videos"

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
#source /home/raul/conda/etc/profile.d/conda.sh 
#conda activate web_pipeline_01

# for all the videos in the folder people, run whisper
for f in "$(dirname "$1")/$(basename "$2")/people"/*.mp4; do
    # remove the extension for output_dir
    output_dir="${f%.*}"
    people_dir="$(dirname "$1")/$(basename "$2")/people"
    #ffmpeg -y -hide_banner -loglevel error -i " + os.path.join(args.input_folder, video) + " -c:v copy -af loudnorm=I=-23:LRA=7:TP=-2.0:measured_I=-17.31:measured_LRA=5.71:measured_TP=-1.35 "  + os.path.join(video_folder, video.split('.')[0] + ".mp3")
    ffmpeg -y -hide_banner -loglevel error -i "$f" -c:v copy -af loudnorm=I=-23:LRA=7:TP=-2.0:measured_I=-17.31:measured_LRA=5.71:measured_TP=-1.35 "$output_dir/words_alignment/$(basename "$f" .mp4).mp3"
    whisperx --model large --output_format all --output_dir "$output_dir/words_alignment"  "$output_dir/words_alignment/$(basename "$f" .mp4).mp3"

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


## RUN OPENPOSE
# save current directory
currentDir="$(pwd)"

for f in "$(dirname "$1")/$(basename "$2")/people"/*.mp4; do
    # remove the extension for output_dir
    output_dir="${f%.*}"
    # get absolute path of the video file
    # get absolute path of the output_dir
    output_dir="$(realpath "$output_dir")"
    echo "*******************"
    echo "$f"
    f="$(realpath "$f")"
    echo "$f"
    echo "*******************"
    # get absolute path of $f
    f="$(realpath "$f")"
    cd /opt/openpose
    ./build/examples/openpose/openpose.bin --video "$f" --face --hand  --write_json "$output_dir/rawData" --display 0  --render_pose 0
    ./build/examples/openpose/openpose.bin --video "$f" --write_video "$output_dir/skeleton/skeleton.avi" --display 0 --face 
    cd "$currentDir"
done

cd "$currentDir"

echo "--------------------------------------------------------------------------"
 
for f in "$(dirname "$1")/$(basename "$2")/people"/*.mp4; do
    output_dir="${f%.*}"
    echo "Rscript run_dfMaker.R $output_dir/rawData $output_dir/dfMaker"
    mkdir -p "$output_dir/dfMaker"
    Rscript /usr/local/bin/run_dfMaker.R "$output_dir/rawData" "$output_dir/dfMaker"

done

echo "--------------------------------------------------------------------------"


# zip the file again in the original folder with the name of the video
# take care about spaces in the name of the video but dont include all the path, only the video name folder
cd "$(dirname "$1")"
zip -r "$(basename "$2").zip" "$(basename "$2")"


