#!/bin/sh

for f in SRTM3-XZ/*.hgt.xz ; do
    b=`basename $f .xz`
    echo "$b"
    xz --keep --decompress "$f" > "SRTM3/$b"
done
