#!/usr/bin/env sh

set -ex

outfile=$1

ogr2ogr -f 'ESRI Shapefile' -spat $XMIN $YMIN $XMAX $YMAX -clipsrc spat_extent $outfile $2
ogr2ogr -f 'ESRI Shapefile' -spat $XMIN $YMIN $XMAX $YMAX -clipsrc spat_extent -addfields $outfile $3
ogr2ogr -f 'ESRI Shapefile' -spat $XMIN $YMIN $XMAX $YMAX -clipsrc spat_extent -addfields $outfile $4
