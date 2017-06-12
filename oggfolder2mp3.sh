#!/bin/bash
#
#  oggfolder2mp3.sh - Script to convert Ogg folders to Mp3
#
#   Requires: avconv, id3lib
#
#   Sumit Khanna - http://penguindreams.org
#
#   Free for noncomercial use
#
#

usage() {
  echo -e "\n $0 - recursively converts a folder of oggs to mp3s"
  echo -e "\n\t $0 <ogg folder to convert> <destination> [<mp3 bitrate in kbps>]"
  echo -e "\n\t The name of the source folder and its directory structure"
  echo -e "\n\t are recreated in the destination"
  echo -e "\n sudo apt-get install vorbis-tools easytag libid3-tools libavcodec-extra-53"
  exit 1
}

# -Copies tags from an ogg to an mp3
#  $1 - Ogg file to read tags from
#  $2 - mp3 file to copy tags to
copyTags() {

  while read line; do
    value=${line#*=}
    key=${line%=*}
    a="tag_${key,,}"
    read $a <<< $value;
  done < <(vorbiscomment -l "$1")

  id3tag "--artist=$tag_artist" "--album=$tag_album" "--song=$tag_title" \
         "--year=$tag_date" "--track=$tag_tracknumber" \
         "--comment=$tag_comment" "--genre=$tag_genre" "$2"
}

# -Converts ogg to mp3 using avconf
#  $1 - source ogg
#  $2 - destination mp3
#  $3 - bitrate in k/bps (e.g. 128, 256, etc)
convert() {
  #convert k/bps to bps for avconf
  if [ "$3" -gt 0 2> /dev/null ]
    then
      bitrate=$(($3 * 1000));
      avconv -y -i "$1" -c:a libmp3lame -b:a "$bitrate" "$2"
    else
      avconv -y -i "$1" -c:a libmp3lame "$2"
  fi
}

# -Recursively scans a directory, replicates the
#  structure and converts all oggs to mp3s
#  $1 - Full path of current directory to scan
#  $2 - Construction of new mp3 absolute path
#  $3 - Basename of current directory (for path construction)
#  $4 - bitrate in kbps
scanDir() {
  mkdir "$2/$3";
  for a in "$1"/*; do
    if [ -d "$a" ]; then
      scanDir "$a" "$2/$3" "$(basename "$a")" "$4"
    else
        case ${a##*.} in ogg|OGG)
         newfile="$(basename "$a")"
         newfile="${newfile%.*}.mp3"
         echo "converting $(basename "$a")"
         ogg="$a"
         mp3="$2/$3/$newfile"
         convert "$ogg" "$mp3" "$4"
         copyTags "$ogg" "$mp3"
        esac
    fi
  done
}

# -Entry Point
echo $1 $2 $3
if [[ -d "$1" && -d "$2" ]]; then
  base=$(basename "$1")
  scanDir "$1" "$2" "$base" "$3"
else
  usage
fi

