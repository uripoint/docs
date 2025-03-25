#!/bin/bash

# 1. Basic color bars test video (10 seconds)
ffmpeg -f lavfi -i smptebars=duration=10:size=1920x1080:rate=30 \
       -c:v libx264 -preset medium -crf 23 \
       -movflags +faststart \
       ./input/input.mp4

# 2. Test animation with text and timecode (30 seconds)
ffmpeg -f lavfi -i testsrc=duration=30:size=1920x1080:rate=30 \
       -vf "drawtext=text='%{pts\:hms}':x=(w-tw)/2:y=h-(2*lh):fontsize=72:fontcolor=white:box=1:boxcolor=black@0.5" \
       -c:v libx264 -preset medium -crf 23 \
       test_animation.mp4

# 3. Color gradient with moving ball (20 seconds)
ffmpeg -f lavfi -i "gradients=duration=20:size=1920x1080:rate=30" \
       -vf "circlewave=size=100:rate=0.5" \
       -c:v libx264 -preset medium -crf 23 \
       test_gradient_ball.mp4

# 4. Test video with audio tone (15 seconds)
ffmpeg -f lavfi -i smptebars=duration=15:size=1920x1080:rate=30 \
       -f lavfi -i "sine=frequency=1000:duration=15" \
       -c:v libx264 -c:a aac -b:a 128k \
       test_with_audio.mp4

# 5. High quality test pattern (10 seconds)
ffmpeg -f lavfi -i testsrc2=duration=10:size=3840x2160:rate=60 \
       -c:v libx264 -preset slow -crf 18 \
       -movflags +faststart \
       test_4k_pattern.mp4

# 6. Multiple test patterns in sequence (30 seconds)
ffmpeg -f lavfi -i "sine=frequency=440:duration=30" \
       -f lavfi -i "smptebars=duration=10:size=1920x1080:rate=30[v1];\
                    testsrc=duration=10:size=1920x1080:rate=30[v2];\
                    rgbtestsrc=duration=10:size=1920x1080:rate=30[v3];\
                    [v1][v2][v3]concat=n=3:v=1:a=0" \
       -c:v libx264 -c:a aac \
       test_sequence.mp4

# 7. Test video with scrolling text (20 seconds)
ffmpeg -f lavfi -i color=c=black:size=1920x1080:duration=20:rate=30 \
       -vf "drawtext=text='This is a test video':fontsize=72:fontcolor=white:x=w-(mod(n\,w+tw)):y=(h-th)/2" \
       -c:v libx264 -preset medium -crf 23 \
       test_scrolling_text.mp4

# 8. Test video with different segments (quality test)
ffmpeg -f lavfi -i "smptebars=duration=30:size=1920x1080:rate=30" \
       -c:v libx264 \
       -x264-params "keyint=60:min-keyint=60:scenecut=0:force-cfr=1" \
       -b:v 5M -maxrate 5M -bufsize 10M \
       -movflags +faststart \
       test_quality.mp4

# Verification commands for generated videos
# Check video properties
ffprobe -v error -select_streams v:0 -show_entries \
        stream=width,height,r_frame_rate,codec_name \
        -of default=noprint_wrappers=1 test_colorbars.mp4

# Check video duration
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 test_animation.mp4

# Check video and audio streams
ffprobe -v error -show_streams test_with_audio.mp4

# Play video
ffplay test_colorbars.mp4

# Extract thumbnail
ffmpeg -i test_animation.mp4 -ss 00:00:01 -vframes 1 thumbnail.jpg