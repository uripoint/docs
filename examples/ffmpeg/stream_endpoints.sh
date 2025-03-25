#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Source environment variables
source .env

echo -e "${BOLD}Setting up streaming endpoints...${NC}"

# Check if input file exists
if [ ! -f "${INPUT_DIR}/input.mp4" ]; then
    echo -e "${RED}Error: ${INPUT_DIR}/input.mp4 not found${NC}"
    exit 1
fi

# Function to check if a port is listening
check_port() {
    if netstat -tuln | grep -q ":$1 "; then
        return 0
    else
        return 1
    fi
}

# Check if streaming servers are running
if ! check_port 1935; then
    echo -e "${RED}RTMP server not running (port 1935)${NC}"
    echo "Please run ./setup.sh first"
    exit 1
fi

if ! check_port 8554; then
    echo -e "${RED}RTSP server not running (port 8554)${NC}"
    echo "Please run ./setup.sh first"
    exit 1
fi

# Function to stream to RTMP
stream_rtmp() {
    echo "Starting RTMP stream..."
    ffmpeg -re -i "${INPUT_DIR}/input.mp4" \
        -c:v libx264 -preset ultrafast -tune zerolatency \
        -c:a aac -ar 44100 -b:a 128k \
        -f flv "${RTMP_URL}" &
    RTMP_PID=$!
    echo "RTMP stream started (PID: $RTMP_PID)"
}

# Function to stream to RTSP
stream_rtsp() {
    echo "Starting RTSP stream..."
    ffmpeg -re -i "${INPUT_DIR}/input.mp4" \
        -c:v libx264 -preset ultrafast -tune zerolatency \
        -c:a aac -ar 44100 -b:a 128k \
        -f rtsp -rtsp_transport tcp "${RTSP_URL}" &
    RTSP_PID=$!
    echo "RTSP stream started (PID: $RTSP_PID)"
}

# Function to check stream status
check_stream() {
    local name=$1
    local pid=$2
    if ps -p $pid > /dev/null; then
        echo -e "${GREEN}✓ $name stream is running (PID: $pid)${NC}"
        return 0
    else
        echo -e "${RED}✗ $name stream has stopped${NC}"
        return 1
    fi
}

# Start streams
stream_rtmp
stream_rtsp

# Wait a moment for streams to initialize
sleep 2

# Print stream URLs
echo -e "\n${BOLD}Stream URLs:${NC}"
echo "RTMP: ${RTMP_URL}"
echo "RTSP: ${RTSP_URL}"
echo "HLS:  ${HLS_URL}"

# Monitor streams
echo -e "\n${BOLD}Stream Status:${NC}"
while true; do
    echo -e "\nChecking stream status..."
    check_stream "RTMP" $RTMP_PID
    check_stream "RTSP" $RTSP_PID
    
    # If either stream fails, restart it
    if ! check_stream "RTMP" $RTMP_PID; then
        echo "Restarting RTMP stream..."
        stream_rtmp
    fi
    
    if ! check_stream "RTSP" $RTSP_PID; then
        echo "Restarting RTSP stream..."
        stream_rtsp
    fi
    
    sleep 5
done

# Cleanup function
cleanup() {
    echo -e "\n${BOLD}Stopping streams...${NC}"
    kill $RTMP_PID 2>/dev/null
    kill $RTSP_PID 2>/dev/null
    wait $RTMP_PID 2>/dev/null
    wait $RTSP_PID 2>/dev/null
    echo "Streams stopped"
    exit 0
}

# Register cleanup function
trap cleanup SIGINT SIGTERM EXIT
