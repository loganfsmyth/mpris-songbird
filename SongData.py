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


object.SetMetadata('rating', 'OMG');