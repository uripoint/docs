#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing Video Watermarking..."

# Check if watermark image exists
if [ ! -f "${INPUT_DIR}/watermark.png" ]; then
    echo "❌ Watermark image not found at ${INPUT_DIR}/watermark.png"
    exit 1
fi

# Execute FFmpeg command
ffmpeg -i ${INPUT_DIR}/input.mp4 -i ${INPUT_DIR}/watermark.png \
    -filter_complex "overlay=main_w-overlay_w-10:main_h-overlay_h-10" \
    ${OUTPUT_DIR}/watermarked.mp4

# Check if FFmpeg command was successful
if [ $? -ne 0 ]; then
    echo "❌ Video watermarking failed"
    exit 1
fi

# Verify output
if [ -f "${OUTPUT_DIR}/watermarked.mp4" ]; then
    # Get video streams information
    VIDEO_INFO=$(ffprobe -v error -show_entries stream=codec_type -of default=noprint_wrappers=1 ${OUTPUT_DIR}/watermarked.mp4)
    
    # Compare dimensions of input and output to ensure they match
    INPUT_DIMS=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 ${INPUT_DIR}/input.mp4)
    OUTPUT_DIMS=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 ${OUTPUT_DIR}/watermarked.mp4)
    
    if [[ $VIDEO_INFO == *"codec_type=video"* ]] && [ "$INPUT_DIMS" = "$OUTPUT_DIMS" ]; then
        echo "✅ Video watermarking successful"
        echo "Video information:"
        echo "- Dimensions: $OUTPUT_DIMS"
        echo "- Streams found:"
        echo "$VIDEO_INFO"
        
        # Get video duration to ensure it matches input
        INPUT_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nk=1 ${INPUT_DIR}/input.mp4)
        OUTPUT_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nk=1 ${OUTPUT_DIR}/watermarked.mp4)
        
        echo "- Input duration: ${INPUT_DUR}s"
        echo "- Output duration: ${OUTPUT_DUR}s"
    else
        echo "❌ Output file verification failed"
        echo "Expected dimensions: $INPUT_DIMS"
        echo "Got dimensions: $OUTPUT_DIMS"
        exit 1
    fi
else
    echo "❌ Watermarked file not found"
    exit 1
fi
