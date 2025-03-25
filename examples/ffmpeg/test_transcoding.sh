#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing Basic Video Transcoding..."

# Execute FFmpeg command
ffmpeg -i ${INPUT_DIR}/input.mp4 -c:v libx264 -c:a aac -b:v ${QUALITY_HIGH} -b:a ${AUDIO_BITRATE} ${OUTPUT_DIR}/output.mp4

# Check if FFmpeg command was successful
if [ $? -ne 0 ]; then
    echo "❌ FFmpeg transcoding failed"
    exit 1
fi

# Verify output
CODEC_INFO=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,bit_rate -of default=noprint_wrappers=1 ${OUTPUT_DIR}/output.mp4)

if [[ $CODEC_INFO == *"codec_name=h264"* ]]; then
    echo "✅ Video transcoding successful"
    echo "Codec information:"
    echo "$CODEC_INFO"
else
    echo "❌ Verification failed"
    exit 1
fi
