#!/usr/bin/env sh

set -ex

ps=$1

grdimage bulid/slope/$NAME.nc -Cbuild/cpt/slope.cpt -Ibuild/gradient/$NAME.nc -Baf -B+t"$DISPLAY_NAME" -JM6i -R$XMIN/$XMAX/$YMIN/$YMAX -K > $ps
grdcontour build/dem/$NAME.tif -C20 -A100 -J -R -K -O >> $ps
psxy build/flowline/$NAME.gmt -W0.6p,blue -J -R -K -O >> $ps
psxy build/waterbody/$NAME.gmt -Gblue -J -R -K -O >> $ps
psxy build/roads/$NAME.gmt -W0.6p,white -J -R -K -O >> $ps
psbasemap -Lx5.2i/-0.7i+c$YMIN+w1k -J -R -K -O >> $ps
psscale -D0i/-0.7i+w3i/0.2i+h -Cbuild/cpt/slope.cpt -G0/60 -By+l"Slope angle" -I -O >> $ps
