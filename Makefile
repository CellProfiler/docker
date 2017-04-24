VERSION = v2.2.0
# From http://cellprofiler.org/examples/#HumanCells
CDN = http://d1zymp9ayga15t.cloudfront.net/content/Examplezips

.DEFAULT_GOAL: build
build:
	docker build -t cellprofiler:$(VERSION) .

.PHONY: input
input:
		mkdir -p $@

output:
		mkdir -m 777 -p $@

ExampleHumanImages.zip:
		curl -O ${CDN}/$@

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
test: input output data input/filelist.txt
	docker run --volume=`pwd`/input:/input --volume=`pwd`/output:/output cellprofiler:$(VERSION) --image-directory=/input --output-directory=/output --pipeline=/input/ExampleHuman.cppipe --file-list=/input/filelist.txt
