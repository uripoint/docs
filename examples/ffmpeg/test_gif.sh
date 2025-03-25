#!/bin/bash

# Source environment variables
source .env

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

echo "Testing GIF Creation..."

# Execute FFmpeg command
ffmpeg -i ${INPUT_DIR}/input.mp4 -vf "fps=10,scale=320:-1:flags=lanczos" -c:v gif ${OUTPUT_DIR}/output.gif

# Check if FFmpeg command was successful
if [ $? -ne 0 ]; then
    echo "❌ GIF creation failed"
    exit 1
fi

# Verify output
if [ -f "${OUTPUT_DIR}/output.gif" ]; then
    # Check if file is actually a GIF
    FILE_TYPE=$(file ${OUTPUT_DIR}/output.gif)
    
    if [[ $FILE_TYPE == *"GIF"* ]]; then
        echo "✅ GIF creation successful"
        
        # Get GIF information
        echo "GIF information:"
        echo "$FILE_TYPE"
        
        # Get dimensions using identify if available
        if command -v identify >/dev/null 2>&1; then
            DIMENSIONS=$(identify -format "Dimensions: %wx%h\nFrames: %n\nDelay: %T" ${OUTPUT_DIR}/output.gif 2>/dev/null)
            if [ $? -eq 0 ]; then
                echo "Animation details:"
                echo "$DIMENSIONS"
            fi
        fi
        
        # Get file size
        SIZE=$(stat -f%z "${OUTPUT_DIR}/output.gif" 2>/dev/null || stat -c%s "${OUTPUT_DIR}/output.gif")
        SIZE_MB=$(echo "scale=2; $SIZE/1048576" | bc)
        echo "File size: ${SIZE_MB}MB"
    else
        echo "❌ Output file is not a valid GIF"
        echo "File type: $FILE_TYPE"
        exit 1
    fi
else
    echo "❌ GIF file not found"
    exit 1
fi
