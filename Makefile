VERSION=0.1.11

# DBus headers/libs
DBUS_INC_LIB=`pkg-config --cflags --libs dbus-1`

# Mozilla headers, libraries and idl files
XUL_SDK = `pkg-config --variable=sdkdir libxul`
XUL_LIB=`pkg-config --cflags --libs libxul`

# Random stuff needed by Mozilla 
DEFINES = -DXPCOM_GLUE_USE_NSPR -DXPCOM_GLUE
OPTIONS = -fno-rtti -fno-exceptions -shared -Wall -Os -fPIC -Wl,-z,defs -include "xpcom-config.h" -fshort-wchar

COMPONENT_FILES = src/components/sbDbusConnection.cpp src/components/sbDbusConnectionModule.cpp
GCC_ARGS = $(COMPONENT_FILES) $(OPTIONS) $(DEFINES) $(XUL_LIB) $(DBUS_INC_LIB)

build64: idl $(COMPONENT_FILES)
	g++ -o src/platform/Linux_x86_64-gcc3/components/sbDbusConnection.so $(GCC_ARGS)

build32: idl $(COMPONENT_FILES)
	g++ -o src/platform/Linux_x86-gcc3/components/sbDbusConnection.so $(GCC_ARGS)
		
idl: src/components/sbIMpris.idl
	cd src/components && $(XUL_SDK)/bin/xpidl -m header -I$(XUL_SDK)/idl sbIMpris.idl && $(XUL_SDK)/bin/xpidl -m typelib -w -v -I$(XUL_SDK)/idl sbIMpris.idl

package:
	sed -i '8s/em:version>[^<]*/em:version>$(VERSION)/' src/install.rdf
	cd src/ && zip -r ../dist/Mpris-$(VERSION).xpi components/ chrome/ platform/ defaults/ install.rdf chrome.manifest -x@zip-exclude.txt

clean: 
	rm src/components/sbIMpris.h
	rm src/components/sbIMpris.xpt

deps: 
	sudo aptitude install build-essential
	sudo aptitude install xulrunner-dev
	sudo aptitude install libdbus-1-dev
