VERSION=0.1.10

# DBus headers/libs
DBUS_INC_LIB=`pkg-config --cflags --libs dbus-1`

# Mozilla headers, libraries and idl files
XUL_SDK = `pkg-config --variable=sdkdir libxul`
XUL_LIB=`pkg-config --cflags --libs libxul`

# Random stuff needed by Mozilla 
DEFINES = -DXPCOM_GLUE_USE_NSPR -DXPCOM_GLUE
OPTIONS = -fno-rtti -fno-exceptions -shared -Wall -Os -fPIC -Wl,-z,defs -include "xpcom-config.h" -fshort-wchar

package:
	sed '8s/VERSION_NUMBER/$(VERSION)/' src/install.rdf > install.rdf
	cp -f src/sbMprisPlugin.js components/
	mkdir -p chrome/content
	cp -f src/scripts-overlay.xul chrome/content/
	cp -f src/main.js chrome/content/
	cp -f src/options.xul chrome/content/
	cp -f src/icon.png chrome/content/
	mkdir -p defaults/preferences
	cp -f src/defaults.js defaults/preferences/
	zip -r Mpris-$(VERSION).xpi components/ chrome/ platform/ defaults/ install.rdf chrome.manifest -x@zip-exclude.txt
	
build32: build
	mkdir -p platform/Linux_x86-gcc3/components
	mv -f sbDbusConnection.so platform/Linux_x86-gcc3/components

build64: build
	mkdir -p platform/Linux_x86_64-gcc3/components
	mv -f sbDbusConnection.so platform/Linux_x86_64-gcc3/components


build: idl src/sbDbusConnection.cpp src/sbDbusConnectionModule.cpp
	g++ -o sbDbusConnection.so src/sbDbusConnection.cpp src/sbDbusConnectionModule.cpp $(OPTIONS) $(DEFINES) $(XUL_LIB) $(DBUS_INC_LIB)
	
	
idl: src/sbIMpris.idl
	$(XUL_SDK)/bin/xpidl -m header -I$(XUL_SDK)/idl src/sbIMpris.idl
	$(XUL_SDK)/bin/xpidl -m typelib -w -v -I$(XUL_SDK)/idl src/sbIMpris.idl
	mkdir -p components
	mv -f sbIMpris.h src/
	mv -f sbIMpris.xpt components/

deps: 
	sudo aptitude install build-essential
	sudo aptitude install xulrunner-dev
	sudo aptitude install libdbus-1-dev
	
	
	