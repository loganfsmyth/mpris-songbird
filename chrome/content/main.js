/*
 * Written by Logan F. Smyth © 2009
 * http://logansmyth.com
 * me@logansmyth.com
 * 
 * Feel free to use/modify this code, but if you do
 * then please at least tell me!
 *
 */


Components.utils.import("resource://gre/modules/XPCOMUtils.jsm"); 

// Make a namespace.
if (typeof Mpris == 'undefined') {
  var Mpris = {};
}


Mpris.Controller = {
  onLoad: function() {

    this.handler = Components.classes['@logansmyth.com/Songbird/MprisPlugin;1'].createInstance(Components.interfaces.sbIMprisPlugin);
  
    this.handler.init();

    // initialization code
    this._initialized = true;
    
  },
  onUnLoad: function() {
    this._initialized = false;
  },
};

window.addEventListener("load", function(e) { Mpris.Controller.onLoad(e); }, false);
window.addEventListener("unload", function(e) { Mpris.Controller.onUnLoad(e); }, false);

