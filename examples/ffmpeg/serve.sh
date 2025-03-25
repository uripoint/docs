# 1. Basic HLS stream from video file
ffmpeg -re -i input.mp4 \
       -c:v libx264 -c:a aac \
       -b:v 1M -b:a 128k \
       -hls_time 4 \
       -hls_list_size 3 \
       -hls_flags delete_segments \
       -hls_segment_filename "output/stream_0/segment_%03d.ts" \
       output/stream_0/stream.m3u8

# 2. Multi-bitrate HLS stream
ffmpeg -re -i input.mp4 \
       -filter_complex \
       "[v:0]split=3[v1][v2][v3]; \
        [v1]copy[v1out]; \
        [v2]scale=w=1280:h=720[v2out]; \
        [v3]scale=w=854:h=480[v3out]" \
       -map "[v1out]" -map a:0 -c:v:0 libx264 -b:v:0 2M -maxrate:v:0 2M -bufsize:v:0 4M \
       -map "[v2out]" -map a:0 -c:v:1 libx264 -b:v:1 1M -maxrate:v:1 1M -bufsize:v:1 2M \
       -map "[v3out]" -map a:0 -c:v:2 libx264 -b:v:2 500k -maxrate:v:2 500k -bufsize:v:2 1M \
       -c:a aac -b:a 128k \
       -var_stream_map "v:0,a:0 v:1,a:1 v:2,a:2" \
       -f hls \
       -hls_time 4 \
       -hls_list_size 3 \
       -hls_flags delete_segments+independent_segments \
       -hls_segment_type mpegts \
       -master_pl_name master.m3u8 \
       -hls_segment_filename "output/stream_%v/segment_%03d.ts" \
       output/stream_%v/stream.m3u8

# 3. Using Python's HTTP server to serve the files
python3 -m http.server 8081

# 4. Using Node.js HTTP server
npm install -g http-server
http-server ./ -p 8081 --cors

# 5. Full example with directory setup and server
mkdir -p output/stream_0
mkdir -p output/stream_1
mkdir -p output/stream_2

# Start FFmpeg streaming
ffmpeg -re -i input.mp4 \
       -map 0:v:0 -map 0:a:0 \
       -c:v libx264 -c:a aac \
       -b:v 1M -b:a 128k \
       -hls_time 4 \
       -hls_list_size 3 \
       -hls_flags delete_segments+independent_segments \
       -hls_segment_filename "output/stream_0/segment_%03d.ts" \
       -f hls output/stream_0/stream.m3u8 &

# Start Python HTTP server in background
python3 -m http.server 8081 &

# Verification commands
# Test stream accessibility
curl http://localhost:8081/output/stream_0/stream.m3u8

# Play stream with ffplay
ffplay http://localhost:8081/output/stream_0/stream.m3u8

# Monitor segments
watch -n 1 "ls -l output/stream_0/"

# Check stream with ffprobe
ffprobe -v error -show_entries format=format_name:stream=codec_name,codec_type \
        http://localhost:8081/output/stream_0/stream.m3u8

# One-line command for quick setup
mkdir -p output/stream_0 && \
ffmpeg -re -i input.mp4 \
       -c:v libx264 -c:a aac \
       -b:v 1M -b:a 128k \
       -hls_time 4 \
       -hls_list_size 3 \
       -hls_flags delete_segments \
       -hls_segment_filename "output/stream_0/segment_%03d.ts" \
       output/stream_0/stream.m3u8 & \
python3 -m http.server 8081