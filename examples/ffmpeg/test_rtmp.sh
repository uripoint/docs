#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing RTMP Stream Recording..."

# Set timeout for stream recording (30 seconds)
TIMEOUT=30

echo "Recording RTMP stream for ${TIMEOUT} seconds..."

# Execute FFmpeg command with timeout
timeout ${TIMEOUT} ffmpeg -i ${STREAM_URL} -c copy ${OUTPUT_DIR}/stream_record.mp4

# Check exit status (124 means timeout, which is expected)
STATUS=$?
if [ $STATUS -ne 124 ] && [ $STATUS -ne 0 ]; then
    echo "❌ RTMP stream recording failed"
    exit 1
fi

# Verify output
if [ -f "${OUTPUT_DIR}/stream_record.mp4" ]; then
    STREAM_INFO=$(ffprobe -v error -show_format -show_streams ${OUTPUT_DIR}/stream_record.mp4)
    
    if [[ $STREAM_INFO == *"codec_type=video"* ]]; then
        echo "✅ RTMP stream recording successful"
        echo "Stream information:"
        echo "$STREAM_INFO"
    else
        echo "❌ Recorded file doesn't contain valid video stream"
        exit 1
    fi
else
    echo "❌ Stream recording file not found"
    exit 1
fi
