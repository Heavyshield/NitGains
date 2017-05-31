default: linux

linux: 
	mkdir -p bin
	/home/thibaud/Documents/nit/nit/bin/nitc -o bin/nitGains src/nitGains.nit -m linux
androidApk: 
	mkdir -p bin
	/home/thibaud/Documents/nit/nit/bin/nitc -o bin/nitGains.apk src/androidVersions/android15.nit -m android

