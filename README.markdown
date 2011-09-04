
General Info
------------

This extensions provides an MPRIS interface for controlling Songbird through the Linux DBUS.
This allows for changing tracks, volume and position, prev/next, play/pause/stop, as well as allows for retrieval of metadata on songs.

This supports almost all MPRIS functionality, except for:

* AddTrack method
* DelTrack method
* GetCaps method just says everything works
* CapsChange signal not implemented
* TrackListChange signal not implemented
* Metadata retrieval from external sources like Musicbrainz and Amazon

If you want them implemented, leave a comment!


Uses
----

This will allow query/control with anything using the MPRIS protocol.
For example:

* Pidgin MusicTracker
* AMSN Music plugin
 * May need to install libqt4-dbus for the program qdbus
* Panflute, Gnome music applet (0.6.0 branch)
* mpris-remote, command line tool
* CoverGloobus, coverart/lyrics display


Sample Code
-----------

    #!/usr/bin/env python
    import dbus
    bus = dbus.SessionBus()
    object = bus.get_object('org.mpris.songbird', '/Player')
    stat = object.GetStatus()
    if stat[0] == 0:
      print "Playing"
    elif stat[0] == 1:
      print "Paused"
    else:
      print "Stopped"
    
    data = object.GetMetadata()
    print data['title']
    print data['artist']


Development
-----------

If you are running Ubuntu, you should be able to run "sudo make deps"
to install the packages that you need to compile this extension.

Packages:

* build-essential - compilers and standard libraries
* libdbus-1-dev   - DBUS dev files for compiling dbus related programs
* xulrunner-dev   - Mozilla development libraries

After that, you should be able to modify the code in the src/components directory.

The important files are:

* sbIMpris.idl
* sbMprisPlugin.js
* sbDbusConnection.h
* sbDbusConnection.cpp
* sbDbusConnectionPlugin.cpp


Notes
-----

This is the only Mozilla that I've ever made, so sorry 
if it has errors or memory leaks or does something wrong :P

