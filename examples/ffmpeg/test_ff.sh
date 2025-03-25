#!/bin/bash


kill $(lsof -t -i:8081)
kill $(lsof -t -i:8082)
kill $(lsof -t -i:8083)
kill $(lsof -t -i:8084)
sleep 4


# Create output directory
rm -rf output/stream_0/*
mkdir -p output/stream_0

# Check if input video has audio stream
ffprobe -i input/input.mp4 -show_streams -select_streams a -loglevel error

# Start Python HTTP server and Firefox in background
python3 -m http.server 8081
firefox localhost:8081/stream_player.html
curl http://localhost:8081/output/stream_0/stream.m3u8
ffplay http://localhost:8081/output/stream_0/stream.m3u8
# Start FFmpeg streaming
ffmpeg -re -i input/input.mp4 \
       -c:v libx264 -c:a aac \
       -b:v 1M -b:a 128k \
       -hls_time 4 \
       -hls_list_size 3 \
       -hls_flags delete_segments \
       -hls_segment_filename "output/stream_0/segment_%03d.ts" \
       output/stream_0/stream.m3u8

# Cleanup function
cleanup() {
    echo "Stopping processes..."
    pkill -f "python3 -m http.server 8081"
    pkill -f "ffplay"
#    pkill -f "firefox"
    exit 0
}

sleep 15
# Register cleanup function
trap cleanup SIGINT SIGTERM EXIT
