#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing Video Trimming..."

# Start and duration times for trimming
START_TIME="00:00:30"
DURATION="00:01:00"

# Execute FFmpeg command
ffmpeg -i ${INPUT_DIR}/input.mp4 -ss ${START_TIME} -t ${DURATION} -c copy ${OUTPUT_DIR}/trimmed.mp4

# Check if FFmpeg command was successful
if [ $? -ne 0 ]; then
    echo "❌ Video trimming failed"
    exit 1
fi

# Verify output
if [ -f "${OUTPUT_DIR}/trimmed.mp4" ]; then
    # Get duration of trimmed video
    DURATION_SEC=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nk=1 ${OUTPUT_DIR}/trimmed.mp4)
    
    # Round duration to nearest second for comparison
    DURATION_ROUNDED=$(printf "%.0f" "$DURATION_SEC")
    
    # Get video information
    VIDEO_INFO=$(ffprobe -v error \
        -show_entries stream=codec_name,width,height \
        -show_entries format=duration,bit_rate \
        -of default=noprint_wrappers=1 ${OUTPUT_DIR}/trimmed.mp4)
    
    # Expected duration in seconds (60 seconds in this case)
    EXPECTED_DURATION=60
    
    # Allow 1 second tolerance for duration comparison
    if [ $((DURATION_ROUNDED - EXPECTED_DURATION)) -ge -1 ] && [ $((DURATION_ROUNDED - EXPECTED_DURATION)) -le 1 ]; then
        echo "✅ Video trimming successful"
        echo "Duration: ${DURATION_SEC} seconds (expected ~${EXPECTED_DURATION} seconds)"
        echo "Video information:"
        echo "$VIDEO_INFO"
        
        # Compare codecs with input to ensure they match (should be identical with -c copy)
        INPUT_CODECS=$(ffprobe -v error -show_entries stream=codec_name -of default=noprint_wrappers=1 ${INPUT_DIR}/input.mp4)
        OUTPUT_CODECS=$(ffprobe -v error -show_entries stream=codec_name -of default=noprint_wrappers=1 ${OUTPUT_DIR}/trimmed.mp4)
        
        if [ "$INPUT_CODECS" = "$OUTPUT_CODECS" ]; then
            echo "Codec verification: ✅ Matches input video"
        else
            echo "Codec verification: ❌ Does not match input video"
            echo "Input codecs: $INPUT_CODECS"
            echo "Output codecs: $OUTPUT_CODECS"
        fi
    else
        echo "❌ Trimmed video duration is incorrect"
        echo "Expected ~${EXPECTED_DURATION} seconds, got ${DURATION_ROUNDED} seconds"
        exit 1
    fi
else
    echo "❌ Trimmed video file not found"
    exit 1
fi
