#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo -e "${BOLD}Setting up FFmpeg test environment...${NC}"

# Create directories
echo "Creating directories..."
mkdir -p input output

# Set directory permissions
echo "Setting permissions..."
chmod 755 input output

# Make all test scripts executable
echo "Making test scripts executable..."
chmod +x test_*.sh run_tests.sh

# Function to check if a package is installed
check_package() {
    if command -v $1 >/dev/null 2>&1; then
        echo -e "${GREEN}✓ $1 is installed${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 is not installed${NC}"
        return 1
    fi
}

# Check required packages
echo "Checking required packages..."
check_package ffmpeg
check_package docker

# Setup streaming endpoints
echo "Setting up streaming endpoints..."

# Create docker-compose.yml for streaming servers
cat > docker-compose.yml << EOF
version: '3'
services:
  rtmp:
    image: tiangolo/nginx-rtmp
    ports:
      - "1935:1935"  # RTMP
      - "8080:80"    # HTTP
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro

  rtsp:
    image: aler9/rtsp-simple-server
    ports:
      - "8554:8554"  # RTSP
EOF

# Create nginx.conf for RTMP server
cat > nginx.conf << EOF
worker_processes auto;
rtmp_auto_push on;
events {}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;
        }

        application hls {
            live on;
            hls on;
            hls_path /tmp/hls;
            hls_fragment 3;
            hls_playlist_length 60;
        }
    }
}

http {
    server {
        listen 80;
        
        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /tmp;
            add_header Cache-Control no-cache;
            add_header Access-Control-Allow-Origin *;
        }
    }
}
EOF

# Start streaming servers
echo "Starting streaming servers..."
docker-compose up -d

# Wait for servers to start
echo "Waiting for servers to start..."
sleep 10

# Create .env file with streaming endpoints
cat > .env << EOF
# FFmpeg test environment variables
INPUT_DIR="./input"
OUTPUT_DIR="./output"
RTMP_URL="rtmp://localhost:1935/live/stream"
RTSP_URL="rtsp://localhost:8554/stream"
HLS_URL="http://localhost:8080/hls/stream.m3u8"
QUALITY_HIGH="4000k"
QUALITY_MED="2000k"
QUALITY_LOW="1000k"
AUDIO_BITRATE="128k"
SEGMENT_TIME="10"
EOF

# Check if input video exists
if [ ! -f "input/input.mp4" ]; then
    echo -e "${RED}Warning: input/input.mp4 not found${NC}"
    echo "Please add a test video file named 'input.mp4' to the input directory"
fi

# Check if watermark exists
if [ ! -f "input/watermark.png" ]; then
    echo -e "${RED}Warning: input/watermark.png not found${NC}"
    echo "Please add a watermark image named 'watermark.png' to the input directory if you plan to test watermarking"
fi

# Check FFmpeg installation
if command -v ffmpeg >/dev/null 2>&1; then
    echo -e "${GREEN}FFmpeg is installed${NC}"
    FFMPEG_VERSION=$(ffmpeg -version | head -n1)
    echo "Version: $FFMPEG_VERSION"
else
    echo -e "${RED}FFmpeg is not installed${NC}"
    echo "Please install FFmpeg before running the tests"
    exit 1
fi

# Check ImageMagick installation (optional)
if command -v identify >/dev/null 2>&1; then
    echo -e "${GREEN}ImageMagick is installed${NC}"
else
    echo -e "${RED}Warning: ImageMagick is not installed${NC}"
    echo "Some GIF testing features will be limited"
fi

# Function to check if a port is listening
check_port() {
    if netstat -tuln | grep -q ":$1 "; then
        return 0
    else
        return 1
    fi
}

# Verify streaming endpoints
echo "Verifying streaming endpoints..."

# Give servers more time to fully initialize
for i in {1..6}; do
    if check_port 1935 && check_port 8080; then
        echo -e "${GREEN}✓ RTMP/HLS server is running${NC}"
        break
    elif [ $i -eq 6 ]; then
        echo -e "${RED}✗ RTMP/HLS server is not responding${NC}"
    else
        sleep 5
    fi
done

for i in {1..6}; do
    if check_port 8554; then
        echo -e "${GREEN}✓ RTSP server is running${NC}"
        break
    elif [ $i -eq 6 ]; then
        echo -e "${RED}✗ RTSP server is not responding${NC}"
    else
        sleep 5
    fi
done

echo -e "\n${GREEN}Setup complete!${NC}"
echo "Streaming endpoints:"
echo "RTMP: rtmp://localhost:1935/live/stream"
echo "RTSP: rtsp://localhost:8554/stream"
echo "HLS:  http://localhost:8080/hls/stream.m3u8"
echo -e "\nYou can now run the tests using:"
echo "  ./run_tests.sh        # Run all tests"
echo "  ./test_<name>.sh      # Run individual test"
