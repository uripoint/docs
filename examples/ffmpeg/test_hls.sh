#!/bin/bash

# Source environment variables
source .env

echo "Testing HLS Stream Generation..."

# Create all required directories first
for i in {0..2}; do
    mkdir -p "${OUTPUT_DIR}/stream_${i}"
done

# Check if input video has audio stream
HAS_AUDIO=$(ffprobe -i ${INPUT_DIR}/input.mp4 -show_streams -select_streams a -loglevel error)

# Create the first variant (high quality)
echo "Creating high quality variant..."
ffmpeg -i ${INPUT_DIR}/input.mp4 \
    -c:v libx264 -b:v ${QUALITY_HIGH} \
    -hls_time ${SEGMENT_TIME} \
    -hls_list_size 0 \
    -hls_segment_filename "${OUTPUT_DIR}/stream_0/segment_%03d.ts" \
    -hls_flags independent_segments \
    ${OUTPUT_DIR}/stream_0/playlist.m3u8

if [ $? -ne 0 ]; then
    echo "❌ Failed to create high quality variant"
    exit 1
fi

# Create the second variant (medium quality)
echo "Creating medium quality variant..."
ffmpeg -i ${INPUT_DIR}/input.mp4 \
    -c:v libx264 -b:v ${QUALITY_MED} \
    -hls_time ${SEGMENT_TIME} \
    -hls_list_size 0 \
    -hls_segment_filename "${OUTPUT_DIR}/stream_1/segment_%03d.ts" \
    -hls_flags independent_segments \
    ${OUTPUT_DIR}/stream_1/playlist.m3u8

if [ $? -ne 0 ]; then
    echo "❌ Failed to create medium quality variant"
    exit 1
fi

# Create the third variant (low quality)
echo "Creating low quality variant..."
ffmpeg -i ${INPUT_DIR}/input.mp4 \
    -c:v libx264 -b:v ${QUALITY_LOW} \
    -hls_time ${SEGMENT_TIME} \
    -hls_list_size 0 \
    -hls_segment_filename "${OUTPUT_DIR}/stream_2/segment_%03d.ts" \
    -hls_flags independent_segments \
    ${OUTPUT_DIR}/stream_2/playlist.m3u8

if [ $? -ne 0 ]; then
    echo "❌ Failed to create low quality variant"
    exit 1
fi

# Create master playlist
echo "Creating master playlist..."
cat > ${OUTPUT_DIR}/master.m3u8 << EOF
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=$(echo "${QUALITY_HIGH%k}" | awk '{print $1*1000}'),RESOLUTION=1920x1080
stream_0/playlist.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=$(echo "${QUALITY_MED%k}" | awk '{print $1*1000}'),RESOLUTION=1280x720
stream_1/playlist.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=$(echo "${QUALITY_LOW%k}" | awk '{print $1*1000}'),RESOLUTION=854x480
stream_2/playlist.m3u8
EOF

# Verify output
PLAYLIST_COUNT=$(find ${OUTPUT_DIR} -name "playlist.m3u8" | wc -l)
MASTER_EXISTS=$(test -f "${OUTPUT_DIR}/master.m3u8" && echo "yes" || echo "no")
SEGMENTS_EXIST=$(find ${OUTPUT_DIR} -name "segment_*.ts" | wc -l)

if [ "$PLAYLIST_COUNT" -eq 3 ] && [ "$MASTER_EXISTS" = "yes" ] && [ "$SEGMENTS_EXIST" -gt 0 ]; then
    echo "✅ HLS stream generation successful"
    echo "Created:"
    echo "- Master playlist"
    echo "- $PLAYLIST_COUNT quality variants"
    echo "- $SEGMENTS_EXIST segments"
    
    # Show bitrates of generated streams
    echo -e "\nStream information:"
    for i in {0..2}; do
        if [ -f "${OUTPUT_DIR}/stream_${i}/segment_000.ts" ]; then
            BITRATE=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nk=1 \
                ${OUTPUT_DIR}/stream_${i}/segment_000.ts)
            echo "Stream $i: $(echo "scale=2; $BITRATE/1000" | bc) kb/s"
        else
            echo "Stream $i: No segments found"
        fi
    done
else
    echo "❌ Verification failed"
    echo "Found:"
    echo "- Master playlist: $MASTER_EXISTS"
    echo "- Quality variants: $PLAYLIST_COUNT (expected 3)"
    echo "- Segments: $SEGMENTS_EXIST"
    exit 1
fi
