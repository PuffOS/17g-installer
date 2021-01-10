DESTDIR=/

all: clean build

build:
	mkdir -p build/usr/lib/ || true
	mkdir -p build/usr/bin/ || true
	mkdir -p build/usr/share/applications || true
	cp -prfv live-installer build/usr/lib/
	install live-installer.desktop build/usr/share/applications/live-installer.desktop
	install live-installer.sh build/usr/bin/live-installer
	#set parmissions
	chmod 755 -R build
	chown root -R build

install:
	cp -prfv build/* $(DESTDIR)/

create-deb:
	mkdir build-dep || true
	cd build && tar czvf ../build-dep/data.tar.gz *
	cd DEBIAN && tar czf ../build-dep/control.tar.gz *
	echo 2.0 > build-dep/debian-binary
	cd build-dep && ar r "live-installer_1.0_all.deb" debian-binary control.tar.gz data.tar.gz
	mv build-dep/*.deb ./
	
create-deb-debian:
	cp -prfv DEBIAN build/DEBIAN
	dpkg -b `pwd`/build

uninstall:
	rm -rf $(DESTDIR)/usr/lib/live-installer
clean:
	rm -rf build build-dep
