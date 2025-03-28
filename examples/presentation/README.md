# UriPoint Presentation Examples

This directory contains comprehensive examples demonstrating UriPoint's capabilities in streaming, security, and protocol handling.

## Directory Structure

```
presentation/
├── live_stream_demo.md     # Live streaming presentation guide
├── player.html             # Basic video player
├── encrypted_player.html   # Secure video player with encryption
├── run_demo.sh            # Basic demo runner
├── run_encrypted_demo.sh  # Encrypted streaming demo
├── run_security_demo.sh   # Security features demo
├── setup_video_endpoints.sh    # Video endpoint setup
├── setup_encrypted_video.sh    # Encrypted video setup
├── setup_security.sh          # Security features setup
├── test_stream.py            # Stream testing
├── test_video_endpoints.py   # Video endpoint testing
├── test_encrypted_video.py   # Encryption testing
└── test_security.py          # Security testing
```

## Quick Start

## Development Setup


nstall development dependencies:
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

2. Run tests:
```bash
python -m pytest
```

### Basic Video Streaming
```bash
# Start basic streaming demo
./run_demo.sh

# Access player
open http://localhost:8000/player.html
```

### Encrypted Streaming
```bash
# Start encrypted streaming demo
./run_encrypted_demo.sh

# Access encrypted player
open http://localhost:8000/encrypted_player.html
```

### Security Features
```bash
# Start security demo
./run_security_demo.sh

# Available endpoints:
- https://localhost:8000/auth/token
- https://localhost:8000/validate
- https://localhost:8000/security/monitor
```

## Example Features

### 1. Video Streaming
- Basic HTTP streaming
- HLS adaptive streaming
- DASH streaming
- RTSP camera support
- Quality selection
- Bandwidth monitoring

### 2. Encrypted Streaming
- HLS encryption
- DASH DRM
- Key rotation
- Stream security
- Encrypted playback
- Secure key delivery

### 3. Security Features
- Input validation
- JWT authentication
- Process sandboxing
- Network security
- TLS encryption
- Security monitoring

## Testing

Each feature set includes comprehensive tests:

```bash
# Test basic streaming
python3 test_stream.py

# Test video endpoints
python3 test_video_endpoints.py

# Test encryption
python3 test_encrypted_video.py

# Test security features
python3 test_security.py
```

## Example Usage

### Basic Streaming
```bash
# Create video endpoint
uripoint --uri http://localhost:8000/video/test --data '{
    "command": "ffmpeg -f lavfi -i testsrc -f mpegts pipe:1",
    "content_type": "video/MP2T"
}' --method GET

# Test stream
curl http://localhost:8000/video/test
```

### Encrypted Streaming
```bash
# Create encrypted endpoint
uripoint --uri https://localhost:8000/video/secure --data '{
    "command": "ffmpeg -i input.mp4 -c:v libx264 -hls_key_info_file key.info -f hls pipe:1",
    "content_type": "application/x-mpegURL"
}' --method GET

# Test encrypted stream
curl -k https://localhost:8000/video/secure
```

### Security Features
```bash
# Create secure endpoint
uripoint --uri https://localhost:8000/api/secure --data '{
    "validator": {"type": "jwt"},
    "rate_limit": {"requests": 10, "per_seconds": 60},
    "tls": {"min_version": "1.2"}
}' --method POST

# Test with authentication
curl -k -H "Authorization: Bearer $TOKEN" https://localhost:8000/api/secure
```

## Dependencies

- ffmpeg (for video processing)
- openssl (for encryption)
- python3 with packages:
  - requests
  - jwt
  - websockets
  - cryptography

## Configuration

Each demo script includes configuration options:

- `run_demo.sh`: Basic streaming settings
- `run_encrypted_demo.sh`: Encryption and key management
- `run_security_demo.sh`: Security features and TLS

## Monitoring

All demos include real-time monitoring:

```bash
# Monitor basic streaming
curl http://localhost:8000/status

# Monitor encrypted streaming
curl -k https://localhost:8000/security/monitor

# Monitor security
curl -k https://localhost:8000/security/monitor
```

## Troubleshooting

1. Port conflicts:
```bash
# Check ports
netstat -tuln | grep '8000\|8080'

# Kill existing processes
kill $(lsof -t -i:8000)
```

2. SSL/TLS issues:
```bash
# Regenerate certificates
./setup_security.sh --regen-certs

# Test TLS
openssl s_client -connect localhost:8000
```

3. Stream issues:
```bash
# Check ffmpeg
ffmpeg -version

# Test video generation
ffmpeg -f lavfi -i testsrc -t 10 test.mp4
```

## Additional Resources

- [Live Stream Demo Guide](live_stream_demo.md)
- [Security Implementation](setup_security.sh)
- [Encryption Setup](setup_encrypted_video.sh)
