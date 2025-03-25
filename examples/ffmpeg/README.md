# FFmpeg Test Suite

A comprehensive test suite for FFmpeg operations, including video transcoding, streaming, compression, and more.

## Prerequisites

- FFmpeg with libx264 and AAC support
- Docker and Docker Compose (for streaming endpoints)
- ImageMagick (optional, for enhanced GIF testing)
- Bash shell
- Standard Unix tools (file, stat, etc.)
- Modern web browser for stream playback

## Quick Start

1. Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

This will:
- Create necessary directories
- Set appropriate permissions
- Make test scripts executable
- Start streaming servers (RTMP and RTSP)
- Verify environment setup

2. Add test files:
- Copy a test video to `input/input.mp4`
- Copy a watermark image to `input/watermark.png` (if testing watermarking)

3. Start streaming:
```bash
chmod +x stream_endpoints.sh
./stream_endpoints.sh
```

4. View streams:
```bash
# Open the stream player in your browser
firefox stream_player.html  # or any other browser
```

## Streaming Features

### Available Endpoints

1. RTMP Stream:
   - URL: rtmp://localhost:1935/live/stream
   - Port: 1935
   - Protocol: RTMP

2. RTSP Stream:
   - URL: rtsp://localhost:8554/stream
   - Port: 8554
   - Protocol: RTSP

3. HLS Stream:
   - URL: http://localhost:8081/output/stream_0/stream.m3u8
   - Port: 8080
   - Protocol: HTTP/HLS

### Streaming Scripts

1. `stream_endpoints.sh`:
   - Streams input video to RTMP and RTSP endpoints
   - Automatically restarts failed streams
   - Monitors stream health
   - Provides status updates

2. `stream_player.html`:
   - Web-based stream player
   - Supports HLS playback
   - Shows stream status
   - Displays all available endpoints

### Stream Management

Start streaming:
```bash
./stream_endpoints.sh
```

Stop streaming:
```bash
# Press Ctrl+C in the terminal running stream_endpoints.sh
```

Monitor streams:
```bash
# The script automatically monitors and reports stream status
# Check the terminal output for health updates
```

[Previous content about tests and other features remains unchanged...]

## Directory Structure

```
ffmpeg/
├── input/              # Input files directory
│   ├── input.mp4      # Test video file
│   └── watermark.png  # Watermark image
├── output/            # Output files directory
│   └── stream_*      # HLS stream variants
├── .env              # Environment variables
├── setup.sh          # Setup script
├── stream_endpoints.sh # Streaming script
├── stream_player.html # Web-based stream player
├── run_tests.sh      # Main test runner
└── test_*.sh         # Individual test scripts
```

## Environment Variables

The test suite uses environment variables defined in `.env`:

- `INPUT_DIR`: Directory containing input files
- `OUTPUT_DIR`: Directory for output files
- `RTMP_URL`: RTMP streaming endpoint
- `RTSP_URL`: RTSP streaming endpoint
- `HLS_URL`: HLS streaming endpoint
- `QUALITY_HIGH`: High quality bitrate (default: 4000k)
- `QUALITY_MED`: Medium quality bitrate (default: 2000k)
- `QUALITY_LOW`: Low quality bitrate (default: 1000k)
- `AUDIO_BITRATE`: Audio encoding bitrate (default: 128k)
- `SEGMENT_TIME`: Segment duration for HLS (default: 10)

## Troubleshooting

### Common Issues

1. **Permission Denied**
   - Run `./setup.sh` to set correct permissions
   - Ensure you have write access to input/output directories

2. **Missing Input Files**
   - Check that `input/input.mp4` exists
   - For watermark tests, ensure `input/watermark.png` exists

3. **FFmpeg Errors**
   - Verify FFmpeg installation: `ffmpeg -version`
   - Check codec support: `ffmpeg -codecs | grep 264`

4. **Streaming Issues**
   - Verify Docker is running: `docker ps`
   - Check if ports are available (1935, 8080, 8554)
   - Review stream status in terminal
   - Check browser console for player errors
   - Try restarting streaming servers: `docker-compose restart`

5. **Player Issues**
   - Ensure browser supports HLS playback
   - Check browser console for errors
   - Verify stream URLs are accessible
   - Try clearing browser cache

### Debug Mode

Add `set -x` at the start of any script for verbose output:
```bash
#!/bin/bash
set -x  # Add this line for debug output
```

## Notes

- Streams automatically restart if they fail
- Web player supports HLS playback
- RTMP/RTSP streams can be viewed with VLC or similar players
- All streaming endpoints run locally
- Docker containers handle stream server functionality

[Rest of content remains unchanged...]
