#!/usr/bin/env sh

set -e

outfile=$1
shift

ogr2ogr -f GMT -spat $XMIN $YMIN $XMAX $YMAX -clipsrc spat_extent $outfile $@
