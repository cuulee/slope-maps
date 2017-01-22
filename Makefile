PS:=$(patsubst locations/%.env,build/%.ps,$(wildcard locations/*.env))
PNG:=$(patsubst %.ps,%.png,$(PS))

default: $(PNG)
.PHONY: default

clean:
	rm -rf build

%.png: %.ps
	psconvert -TG -A -P $<

build/%.ps: locations/%.env scripts/slope-map.sh build/slope/%.nc build/gradient/%.nc build/dem/%.tif build/flowline/%.gmt build/waterbody/%.gmt build/roads/%.gmt build/cpt/slope.cpt | build
	$< $(word 2,$^) $@

build/slope/%.nc: build/dem/%.tif | build/slope
	grdgradient -fg $< -S$@ -D
	grdmath $@ ATAN PI DIV 180 MUL = $@

build/gradient/%.nc: build/dem/%.tif | build/gradient
	grdgradient -fg $< -G$@ -A-45 -Nt0.5

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

build/cpt/slope.cpt: | build/cpt
	makecpt -C'#d1e9ad','#ffeda0','#feb24c','#f03b20','#feb24c','#ffeda0',gray -T0,25,30,35,40,45,50,90 -N > $@

build build/slope build/gradient build/dem build/flowline build/waterbody build/roads build/cpt:
	mkdir -p $@
