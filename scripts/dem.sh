#!/usr/bin/env sh

set -ex

outfile=$1
shift

gdalbuildvrt -te $XMIN $YMIN $XMAX $YMAX $outfile $@
