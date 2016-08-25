#!/bin/bash
# uskee.org


# check args
[ $# -lt 1 ] && printf "[INFO] usage: $0 file uri1 [uri2 ..]\n\n" && exit 1

# check input file
file="$1" && shift
[ ! -f "$file" ] && printf "[ERROR] <$file> is not exist!\n\n" && exit 1

# check rtmp url
[ $# -lt 1 ] && printf "[INFO] usage: $0 file uri1 [uri2 ..]\n\n" && exit 1
for url in $*; do
    [ "${url:0:7}" != "rtmp://" ] && printf "[ERROR] invalid rtmp: $url\n\n" && exit 1
done



#
# for capture in windows
# -f dshow -i video="Integrated Camera" -f dshow -i audio="麦克风 (3- Realtek High Definition"
#

opts=""
#opts="$opts -loglevel verbose"
opts="$opts -i $file"
opts="$opts -pix_fmt yuv420p -c:v libx264 -vprofile baseline"
opts="$opts -s 640x480 -filter:v fps=15 -b:v 512k -intra-refresh auto"
opts="$opts -maxrate 640k -minrate 128k -bf 0 -b_strategy 0"
opts="$opts -g 15 -keyint_min 15 -sc_threshold 0"
opts="$opts -c:a aac -ar 44100 -ac 2 -b:a 64k -strict -2"
#opts="$opts -c copy"

for url in $*; do
    opts="$opts -f flv $url"
done

trap "{ echo 'recv signal'; exit 255; }" HUP INT QUIT TSTP

#
# run ffmpeg to output stream
while :
do
    [ ! -f $file ] && echo "[WARN] no file <$file>" && break

    printf "\n\n\n\n\n"
    echo "[INFO] options: $opts" && echo

    ffmpeg -re $opts 
    sleep 2
    pid=$(pgrep -l -f "$file" | grep ffmpeg | awk '{print $1}')
    [ "$pid" != "" ] && kill -9 $pid
    printf "\n\n"

    echo "[WARN] end this time" && echo
    sleep 3
done

exit 0
