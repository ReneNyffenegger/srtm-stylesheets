#!/bin/bash

# This script is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

# where the HGT files are at
base="SRTM3"

# argument list of hgt files
files=""

continent=$1

if [ -z $continent ] ; then
  echo "Usage: $0 [SRTM3_Region]"
  exit 1
fi


# filename of output single merged file
merged=SRTM3_$continent.tiff

if [ -z $5 ] ; then
  echo "Usage: $0 [SRTM3_Continent] lon0 lon1 lat0 lat1"
  exit 1
else
  e0=$2
  e1=$3
  n0=$4
  n1=$5
fi

# count how mange files we are planning to merge
counter=0
for e in `seq $e0 $e1` ; do
  for n in `seq $n0 $n1` ; do
    # FIXME if negative then use W or S
    echo "${base}/S${n}E${e}.hgt"
    if [ -e "${base}/S${n}E${e}.hgt" ] ; then
      files="${files} ${base}/S${n}E${e}.hgt"
      counter=$(($counter + 1))
    fi
  done
done

echo "Planning to merge $counter files."

rm -rf $merged
nice gdal_merge.py -o $merged -co BIGTIFF=YES -co COMPRESS=DEFLATE -co ZLEVEL=9 $files
