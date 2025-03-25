#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing Video Thumbnail Generation..."

# Execute FFmpeg command
ffmpeg -i ${INPUT_DIR}/input.mp4 -vf fps=1/${SEGMENT_TIME} ${OUTPUT_DIR}/thumb_%03d.jpg

# Check if FFmpeg command was successful
if [ $? -ne 0 ]; then
    echo "❌ Thumbnail generation failed"
    exit 1
fi

# Verify output
THUMB_COUNT=$(find ${OUTPUT_DIR} -name "thumb_*.jpg" | wc -l)

if [ $THUMB_COUNT -gt 0 ]; then
    # Check if thumbnails are valid JPEG files
    INVALID_COUNT=0
    for thumb in ${OUTPUT_DIR}/thumb_*.jpg; do
        if ! file "$thumb" | grep -q "JPEG image data"; then
            INVALID_COUNT=$((INVALID_COUNT + 1))
        fi
    done

    if [ $INVALID_COUNT -eq 0 ]; then
        echo "✅ Thumbnail generation successful"
        echo "Generated $THUMB_COUNT thumbnails"
        
        # Display thumbnail dimensions for the first image
        FIRST_THUMB=$(find ${OUTPUT_DIR} -name "thumb_*.jpg" | head -n 1)
        if [ -n "$FIRST_THUMB" ]; then
            DIMENSIONS=$(identify -format "Dimensions: %wx%h" "$FIRST_THUMB" 2>/dev/null || echo "ImageMagick not installed")
            echo "Sample thumbnail $DIMENSIONS"
        fi
    else
        echo "❌ Generated files are not valid JPEG images"
        exit 1
    fi
else
    echo "❌ No thumbnails were generated"
    exit 1
fi
