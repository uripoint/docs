#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing Video Resolution Scaling..."

# Execute FFmpeg command
ffmpeg -i ${INPUT_DIR}/input.mp4 -vf scale=-1:720 -c:v libx264 -c:a copy ${OUTPUT_DIR}/720p.mp4

# Check if FFmpeg command was successful
if [ $? -ne 0 ]; then
    echo "❌ Video scaling failed"
    exit 1
fi

# Verify output
if [ -f "${OUTPUT_DIR}/720p.mp4" ]; then
    # Get video resolution information
    HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nk=1 ${OUTPUT_DIR}/720p.mp4)
    WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nk=1 ${OUTPUT_DIR}/720p.mp4)
    
    # Get additional video information
    VIDEO_INFO=$(ffprobe -v error -show_entries \
        stream=codec_name,bit_rate,avg_frame_rate \
        -show_entries format=duration \
        -of default=noprint_wrappers=1 ${OUTPUT_DIR}/720p.mp4)
    
    if [ "$HEIGHT" = "720" ]; then
        echo "✅ Video scaling successful"
        echo "Resolution: ${WIDTH}x${HEIGHT}"
        echo "Video information:"
        echo "$VIDEO_INFO"
        
        # Calculate and display aspect ratio
        RATIO=$(echo "scale=3; $WIDTH/$HEIGHT" | bc)
        echo "Aspect ratio: $RATIO"
        
        # Compare duration with input to ensure it matches
        INPUT_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nk=1 ${INPUT_DIR}/input.mp4)
        OUTPUT_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nk=1 ${OUTPUT_DIR}/720p.mp4)
        
        echo "Duration check:"
        echo "- Input: ${INPUT_DUR}s"
        echo "- Output: ${OUTPUT_DUR}s"
    else
        echo "❌ Output video height is not 720p (got ${HEIGHT}p)"
        exit 1
    fi
else
    echo "❌ Scaled video file not found"
    exit 1
fi
