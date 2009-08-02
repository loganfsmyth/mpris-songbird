VERSION=0.1.1

UUID32={0a067f25-b5fa-4530-9396-fc7088a05415}
UUID64={1332dba8-bade-4111-b097-f09f10f03ef2}

# DBus headers/libs
DBUS_INC_LIB=`pkg-config --cflags --libs dbus-1`

# Mozilla headers, libraries and idl files
XUL_SDK = `pkg-config --variable=sdkdir libxul`
XUL_LIB=`pkg-config --cflags --libs libxul`

# Random stuff needed by Mozilla 
DEFINES = -DXPCOM_GLUE_USE_NSPR -DXPCOM_GLUE
OPTIONS = -fno-rtti -fno-exceptions -shared -Wall -Os -fPIC -Wl,-z,defs -include "xpcom-config.h" -fshort-wchar

package32: build
	sed '7s/MPRIS/MPRIS (32-bit)/' src/install.rdf | sed '5s/UUID/$(UUID32)/' > install.rdf
	zip -r Mpris-$(VERSION)-32bit.xpi components/ chrome/ install.rdf chrome.manifest
	
package64: build
	sed '7s/MPRIS/MPRIS (64-bit)/' src/install.rdf | sed '5s/UUID/$(UUID64)/' > install.rdf
	zip -r Mpris-$(VERSION)-64bit.xpi components/ chrome/ install.rdf chrome.manifest


build: idl src/sbDbusConnection.cpp src/sbDbusConnectionModule.cpp
	g++ -o sbDbusConnection.so src/sbDbusConnection.cpp src/sbDbusConnectionModule.cpp $(OPTIONS) $(DEFINES) $(XUL_LIB) $(DBUS_INC_LIB)
	mv -f sbDbusConnection.so components/
	cp -f src/sbMprisPlugin.js components/
	rm -rf chrome
	mkdir chrome
	mkdir chrome/content
	cp -f src/scripts-overlay.xul chrome/content/
	cp -f src/main.js chrome/content/
	cp -f src/icon.png chrome/content/
	
idl: src/sbIMpris.idl
	$(XUL_SDK)/bin/xpidl -m header -I$(XUL_SDK)/idl src/sbIMpris.idl
	$(XUL_SDK)/bin/xpidl -m typelib -w -v -I$(XUL_SDK)/idl src/sbIMpris.idl
	rm -rf components
	mkdir components
	mv -f sbIMpris.h src/
	mv -f sbIMpris.xpt components/

deps: 
	sudo aptitude install build-essential
	sudo aptitude install xulrunner-dev
	sudo aptitude install libdbus-1-dev
	
	
	