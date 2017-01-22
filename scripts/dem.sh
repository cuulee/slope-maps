#!/usr/bin/env sh

set -ex

outfile=$1
shift

# gdal_merge.py -o $outfile -ul_lr $XMIN $YMAX $XMAX $YMIN $@
gdal_merge.py $@ -o $outfile
