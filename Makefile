SVN = http://cellprofiler.org/svnmirror/ExampleImages/ExampleHumanImages

.DEFAULT_GOAL: build
build:
		docker build -t cellprofiler .

.PHONY: input
input:
		mkdir -p $@

output:
		mkdir -m 777 -p $@

input/ExampleHuman.cppipe input/AS_09125_050116030001_D03f00d0.tif input/AS_09125_050116030001_D03f00d1.tif input/AS_09125_050116030001_D03f00d2.tif:
		cd input
		wget http://d1zymp9ayga15t.cloudfront.net/content/Examplezips/ExampleHumanImages.zip
		unzip ExampleHumanImages.zip
		mv ExampleHumanImages/* .
		rmdir ExampleHumanImages

input/filelist.txt: input/AS_09125_050116030001_D03f00d0.tif input/AS_09125_050116030001_D03f00d1.tif input/AS_09125_050116030001_D03f00d2.tif
		echo 'file:///input/AS_09125_050116030001_D03f00d0.tif' >> $@
		echo 'file:///input/AS_09125_050116030001_D03f00d1.tif' >> $@
		echo 'file:///input/AS_09125_050116030001_D03f00d2.tif' >> $@

.PHONY: test
test: input output input/filelist.txt input/ExampleHuman.cppipe
		docker run --volume=`pwd`/input:/input --volume=`pwd`/output:/output cellprofiler -r -c \
		--pipeline=/input/ExampleHuman.cppipe \
		--image-directory=/input \
		--output-directory=/output \
		--file-list=/input/filelist.txt
