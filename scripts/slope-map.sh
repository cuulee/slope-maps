#!/usr/bin/env sh

set -ex

ps=$1
blue='#377eb8'

grdimage build/slope/$NAME.nc -Cbuild/cpt/slope.cpt -Ibuild/gradient/$NAME.nc -Ba -B+t"$DISPLAY_NAME" -JM$SIZE -Rbuild/dem/$NAME.tif -K > $ps
grdcontour build/dem/$NAME.tif -C20 -A100 -J -R -K -O >> $ps
psxy build/flowline/$NAME.gmt -W0.6p,$blue -J -R -K -O >> $ps
psxy build/waterbody/$NAME.gmt -G$blue -J -R -K -O >> $ps
psxy build/roads/$NAME.gmt -W1p,'#f781bf' -J -R -K -O >> $ps
psbasemap -Lx5.2i/-0.7i+c$YMIN+w1k -J -R -K -O >> $ps
psscale -D0i/-0.7i+w3i/0.2i+h -Cbuild/cpt/slope.cpt -G0/60 -By+l"Slope angle" -I -O >> $ps
