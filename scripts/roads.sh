#!/usr/bin/env sh

set -e

outfile=$1

ogr2ogr -f 'ESRI Shapefile' -spat $XMIN $YMIN $XMAX $YMAX -clipsrc spat_extent -overwrite $outfile $2
ogr2ogr -f 'ESRI Shapefile' -spat $XMIN $YMIN $XMAX $YMAX -clipsrc spat_extent -addfields $outfile $3
ogr2ogr -f 'ESRI Shapefile' -spat $XMIN $YMIN $XMAX $YMAX -clipsrc spat_extent -addfields $outfile $4
