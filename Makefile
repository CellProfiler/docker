VERSION = v2.2.0
# Inputs from http://cellprofiler.org/examples/#HumanCells
EXAMPLE_CDN = http://d1zymp9ayga15t.cloudfront.net/content/Examplezips
# Public gold output files
S3_GOLD = https://s3-us-west-2.amazonaws.com/recursion-test-files/travis-cellprofiler-docker

.DEFAULT_GOAL: build
build:
	docker build -t cellprofiler:$(VERSION) .

.PHONY: input
input:
	mkdir -p $@

output:
	mkdir -m 777 -p $@

# The files to compare against after a run of CellProfiler
# Note that while Image.csv is also output, it is not compared against,
# because it contains hashes that change per-run.
output/gold:	output
	mkdir $@
AS_09125_050116030001_D03f00d0_Outline.png:	output/gold
	curl -o $</$@ ${S3_GOLD}/$@
Cells.csv:	output/gold
	curl -o $</$@ ${S3_GOLD}/$@
Nuclei.csv:	output/gold
	curl -o $</$@ ${S3_GOLD}/$@
Cytoplasm.csv: output/gold
	curl -o $</$@ ${S3_GOLD}/$@

ExampleHumanImages.zip:
	curl -O ${EXAMPLE_CDN}/$@

data: ExampleHumanImages.zip
	unzip $< -d input
	mv input/ExampleHumanImages/* input/
	rmdir input/ExampleHumanImages

input/filelist.txt: data
	echo 'file:///input/AS_09125_050116030001_D03f00d0.tif' >> $@
	echo 'file:///input/AS_09125_050116030001_D03f00d1.tif' >> $@
	echo 'file:///input/AS_09125_050116030001_D03f00d2.tif' >> $@

.PHONY: clean
clean:
	rm -r input
	rm -r output
	rm ExampleHumanImages.zip

.PHONY: test
test: input output output/gold data input/filelist.txt AS_09125_050116030001_D03f00d0_Outline.png Cells.csv Nuclei.csv Cytoplasm.csv
	docker run --volume=`pwd`/input:/input --volume=`pwd`/output:/output cellprofiler:$(VERSION) --image-directory=/input --output-directory=/output --pipeline=/input/ExampleHuman.cppipe --file-list=/input/filelist.txt
	# Compare gold files against output that was run.
	diff -b output/AS_09125_050116030001_D03f00d0_Outline.png output/gold/AS_09125_050116030001_D03f00d0_Outline.png
	diff -b output/Nuclei.csv output/gold/Nuclei.csv
	diff -b output/Cells.csv output/gold/Cells.csv
	diff -b output/Cytoplasm.csv output/gold/Cytoplasm.csv
