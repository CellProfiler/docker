ARCHIVES = http://d1zymp9ayga15t.cloudfront.net/content/Examplezips

.DEFAULT_GOAL: build
build:
		docker build -t cellprofiler .

ExampleHumanImages: ExampleHumanImages.zip
		unzip $<

.INTERMEDIATE: ExampleHumanImages.zip
ExampleHumanImages.zip:
		wget ${ARCHIVES}/$@

ExampleHumanImages/filelist.txt: ExampleHumanImages
		echo 'file:///ExampleHumanImages/AS_09125_050116030001_D03f00d0.tif' >> $@
		echo 'file:///ExampleHumanImages/AS_09125_050116030001_D03f00d1.tif' >> $@
		echo 'file:///ExampleHumanImages/AS_09125_050116030001_D03f00d2.tif' >> $@

output:
		mkdir -m 777 -p $@

.PHONY: test
test: ExampleHumanImages/filelist.txt output
		docker run --volume=`pwd`/ExampleHumanImages:/ExampleHumanImages \
							 --volume=`pwd`/output:/output cellprofiler            \
							 --file-list=/ExampleHumanImages/filelist.txt          \
							 --image-directory=/ExampleHumanImages                 \
							 --output-directory=/output                            \
							 --pipeline=/ExampleHumanImages/ExampleHuman.cppipe
