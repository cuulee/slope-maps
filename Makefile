PS:=$(patsubst locations/%.env,build/map/%.ps,$(wildcard locations/*.env))
PNG:=$(patsubst %.ps,%.png,$(PS))
TRACKS:=$(patsubst tracks/%.kml,build/tracks/%.gmt,$(shell find tracks -type f -name '*.kml')) 

default: $(PNG)
.PHONY: default

clean:
	rm -rf build

%.png: %.ps
	psconvert -TG -A -P $<

build/map/%.ps: locations/%.env scripts/slope-map.sh build/slope/%.nc build/gradient/%.nc build/dem/%.tif build/flowline/%.gmt build/waterbody/%.gmt build/roads/%.gmt build/cpt/slope.cpt $(TRACKS) | build/map
	$< $(word 2,$^) $@

build/slope/%.nc: build/dem/%.tif | build/slope
	grdgradient -fg $< -S$@ -D
	grdmath $@ ATAN PI DIV 180 MUL = $@

build/gradient/%.nc: build/dem/%.tif | build/gradient
	grdgradient -fg $< -G$@ -A-45 -Nt0.6

build/dem/%.vrt: locations/%.env scripts/dem.sh $(wildcard dem/*.flt) | build/dem
	$< $(word 2,$^) $@ $(wordlist 3,$(words $^),$^)

%.tif: %.vrt
	gdal_translate -of GTiff $< $@

build/flowline/%.gmt: locations/%.env scripts/ogrcrop.sh water/NHDFlowline.shp | build/flowline
	$< $(word 2,$^) $@ $(wordlist 3,$(words $^),$^)

build/waterbody/%.gmt: locations/%.env scripts/ogrcrop.sh water/NHDWaterbody.shp | build/waterbody
	$< $(word 2,$^) $@ $(wordlist 3,$(words $^),$^)

build/roads/%.shp: locations/%.env scripts/roads.sh roads/Trans_RoadSegment.shp roads/Trans_RoadSegment2.shp roads/Trans_RoadSegment3.shp | build/roads
	$< $(word 2,$^) $@ $(wordlist 3,$(words $^),$^)
.PRECIOUS: build/roads/%.shp

build/roads/%.gmt: build/roads/%.shp
	ogr2ogr -F GMT $@ $<

build/cpt/slope.cpt: Makefile | build/cpt
	makecpt -Cwhite,'#ffff33','#ff7f00','#e41a1c','#984ea3','#377eb8','#777777' -T0,25,30,35,40,45,50,90 -N > $@

build/tracks/%.gmt: tracks/%.kml
	mkdir -p $(dir $@)
	ogr2ogr -F GMT $@ $< Paths

build/map build/slope build/gradient build/dem build/flowline build/waterbody build/roads build/cpt:
	mkdir -p $@
