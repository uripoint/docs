#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing Video Compression..."

# Execute FFmpeg command
ffmpeg -i ${INPUT_DIR}/input.mp4 -c:v libx264 -crf 23 -c:a copy ${OUTPUT_DIR}/compressed.mp4

# Check if FFmpeg command was successful
if [ $? -ne 0 ]; then
    echo "❌ Video compression failed"
    exit 1
fi

# Verify output
if [ -f "${OUTPUT_DIR}/compressed.mp4" ]; then
    # Get original and compressed file sizes
    ORIGINAL_SIZE=$(stat -f%z "${INPUT_DIR}/input.mp4" 2>/dev/null || stat -c%s "${INPUT_DIR}/input.mp4")
    COMPRESSED_SIZE=$(stat -f%z "${OUTPUT_DIR}/compressed.mp4" 2>/dev/null || stat -c%s "${OUTPUT_DIR}/compressed.mp4")
    
    # Convert to MB for readable output
    ORIGINAL_MB=$(echo "scale=2; $ORIGINAL_SIZE/1048576" | bc)
    COMPRESSED_MB=$(echo "scale=2; $COMPRESSED_SIZE/1048576" | bc)
    
    # Calculate compression ratio
    RATIO=$(echo "scale=2; $ORIGINAL_SIZE/$COMPRESSED_SIZE" | bc)
    
    # Get video quality information
    VIDEO_INFO=$(ffprobe -v error -show_entries stream=codec_name,width,height,bit_rate \
        -show_entries format=duration,size \
        -of default=noprint_wrappers=1 ${OUTPUT_DIR}/compressed.mp4)
    
    if [[ $VIDEO_INFO == *"codec_name=h264"* ]]; then
        echo "✅ Video compression successful"
        echo "Original size: ${ORIGINAL_MB}MB"
        echo "Compressed size: ${COMPRESSED_MB}MB"
        echo "Compression ratio: ${RATIO}:1"
        echo "Video information:"
        echo "$VIDEO_INFO"
    else
        echo "❌ Compressed file is not a valid video"
        exit 1
    fi
else
    echo "❌ Compressed file not found"
    exit 1
fi
