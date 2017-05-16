default: linux

linux: 
	mkdir -p bin
	/home/thibaud/Documents/nit/nit/bin/nitc -o bin/nitGains src/nitGains.nit -m linux
android: 
	mkdir -p bin
	/home/thibaud/Documents/nit/nit/bin/nitc -o bin/nitGains.apk src/nitGains.nit -m android

