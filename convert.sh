#!/bin/bash

bar() { # bar percent
  local p=$1 total=50 filled=$((p*total/100))
  printf "["
  for ((i=0;i<filled;i++)); do printf "#"; done
  for ((i=filled;i<total;i++)); do printf "-"; done
  printf "] %3d%%" "$p"
}

progress_ffmpeg() { # progress_ffmpeg infile outfile label
  local infile="$1" outfile="$2" label="$3"
  local duration cur percent
  duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$infile")
  duration=${duration%.*}

  ffmpeg -y -loglevel error -i "$infile" -map 0:v:0 -map 0:a:1 -c copy -progress pipe:1 "$outfile" 2>/dev/null |
  while IFS='=' read -r key val; do
    case "$key" in
      out_time_ms)
        cur=$((val/1000000))
        percent=$((100*cur/duration))
        printf "\r%-60s " "$label"
        bar $percent
        ;;
      progress) [ "$val" = "end" ] && printf "\r%-60s " "$label" && bar 100 && echo ;;
    esac
  done
}

echo "=== input → language ==="
for f in input/*; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  progress_ffmpeg "$f" "language/$name" "$name"
done

echo "=== language → output ==="
for f in language/*; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  progress_ffmpeg "$f" "output/$name" "$name"
done

echo "Done."
