PS:=$(patsubst locations/%.env,build/%.ps,$(wildcard locations/*.env))
PNG:=$(patsubst %.ps,%.png,$(PS))

default: $(PNG)
.PHONY: default

%.png: %.ps
	psconvert -TG -A -P $<

build/%.ps: locations/%.env scripts/slope-map.sh build/slope/%.nc build/gradient/%.nc build/dem/%.tif build/flowline/%.gmt build/waterbody/%.gmt build/roads/%.gmt build/cpt/slope.cpt | build
	$< $(word 2,$^) $@

build/slope/%.nc: build/dem/%.flt | build/slope
	grdgradient $< -S$@ -D

build/gradient/%.nc: build/dem/%.flt | build/gradient
	grdgradient $< -G$@ -A-45 -Nt0.5

build/dem/%.tif: locations/%.env scripts/dem.sh $(wildcard dem/*.img) | build/dem
	$< $(word 2,$^) $@ $(wordlist 3,$(words $^),$^)

build/flowline/%.gmt: locations/%.env scripts/flowline.sh water/NHDFlowline.shp | build/flowline
	$< $(word 2,$^) $@

build/waterbody/%.gmt: locations/%.env scripts/waterbody.sh water/NHDWaterbody.shp build/waterbody
	$< $(word 2,$^) $@

build/roads/%.shp: locations/%.env scripts/roads.sh roads/Trans_RoadSegment.shp roads/Trans_RoadSegment2.shp roads/Trans_RoadSegment3.shp | build/roads
	$< $(word 2,$^) $@

build/roads/%.gmt: build/roads/%.shp
	ogr2ogr -F GMT $@ $<

build/cpt/slope.cpt: | build/cpt
	makecpt -C'#d1e9ad','#ffeda0','#feb24c','#f03b20','#feb24c','#ffeda0',gray -T0,25,30,35,40,45,50,90 -N > $@

build build/slope build/gradient build/dem build/flowline build/waterbody build/roads build/cpt:
	mkdir -p $@
