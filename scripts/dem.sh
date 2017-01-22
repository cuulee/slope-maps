#!/usr/bin/env sh

set -e

outfile=$1
shift

gdal_merge.py -o $outfile -ul_lr $XMIN $YMAX $XMAX $YMIN $@
