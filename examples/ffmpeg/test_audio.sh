#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing Audio Extraction..."

# Execute FFmpeg command
ffmpeg -i ${INPUT_DIR}/input.mp4 -vn -acodec libmp3lame -b:a ${AUDIO_BITRATE} ${OUTPUT_DIR}/audio.mp3

# Check if FFmpeg command was successful
if [ $? -ne 0 ]; then
    echo "❌ Audio extraction failed"
    exit 1
fi

# Verify output
if [ -f "${OUTPUT_DIR}/audio.mp3" ]; then
    # Get audio codec information
    AUDIO_INFO=$(ffprobe -v error -show_entries stream=codec_name -of default=noprint_wrappers=1 ${OUTPUT_DIR}/audio.mp3)
    
    if [[ $AUDIO_INFO == *"codec_name=mp3"* ]]; then
        echo "✅ Audio extraction successful"
        
        # Get detailed audio information
        AUDIO_DETAILS=$(ffprobe -v error -show_entries \
            format=duration,bit_rate \
            -show_entries stream=codec_name,channels,sample_rate \
            -of default=noprint_wrappers=1 \
            ${OUTPUT_DIR}/audio.mp3)
        
        echo "Audio file details:"
        echo "$AUDIO_DETAILS"
    else
        echo "❌ Output file is not a valid MP3"
        exit 1
    fi
else
    echo "❌ Audio file not found"
    exit 1
fi
