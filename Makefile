SVN = http://cellprofiler.org/svnmirror/ExampleImages/ExampleHumanImages

.DEFAULT_GOAL: build
build:
		docker build -t cellprofiler .

.PHONY: input
input:
		mkdir -p $@

output:
		mkdir -m 777 -p $@

ExampleHuman.cppipe:
		curl -O ${SVN}/ExampleHuman.cppipe

input/ExampleHuman.cppipe: ExampleHuman.cppipe
		mv $< $@

AS_09125_050116030001_D03f00d0.tif:
		curl -O ${SVN}/$@

input/AS_09125_050116030001_D03f00d0.tif: AS_09125_050116030001_D03f00d0.tif
		mv $< $@

AS_09125_050116030001_D03f00d1.tif: AS_09125_050116030001_D03f00d1.tif
		curl -O ${SVN}/$@

input/AS_09125_050116030001_D03f00d1.tif: AS_09125_050116030001_D03f00d1.tif
		mv $< $@

AS_09125_050116030001_D03f00d2.tif:
		curl -O ${SVN}/$@

input/AS_09125_050116030001_D03f00d2.tif: AS_09125_050116030001_D03f00d2.tif
		mv $< $@

input/filelist.txt: input/AS_09125_050116030001_D03f00d0.tif input/AS_09125_050116030001_D03f00d1.tif input/AS_09125_050116030001_D03f00d2.tif
		echo 'file:///input/AS_09125_050116030001_D03f00d0.tif' >> $@
		echo 'file:///input/AS_09125_050116030001_D03f00d1.tif' >> $@
		echo 'file:///input/AS_09125_050116030001_D03f00d2.tif' >> $@

.PHONY: test
test: input output input/filelist.txt input/ExampleHuman.cppipe
		docker run --volume=`pwd`/input:/input --volume=`pwd`/output:/output cellprofiler --image-directory=/input --output-directory=/output --pipeline=/input/ExampleHuman.cppipe --file-list=/input/filelist.txt
