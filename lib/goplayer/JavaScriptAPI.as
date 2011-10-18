/*
DESCRIPTION:
This class handles event communication between JavaScript and Flash.

USAGE:

Inside flash the class is called to dispatch events after initialization.

JavaScriptAPI.initialize() // Run once to prepare the ExternalInterface and send the onPlayerReady event
JavaScriptAPI.dispatchEvent("onMessage", {message: "Hello There!"})

Outside flash (javascript in embedding html page) the add/removeEventListener methods are availible.

<script>
  function onPlayerRead(e) {
    player = document.getElementById("player-object-id")
    player.addEventListener("onVideoLoaded") // Listen to onVideoLoaded with a method with the same name
    player.addEventListener("onPlay", "onPlaybackStarted") // Listen to onPlay with a method called onPlaybackStarted
  }
  
  function onVideoLoaded(e) {
    alert("Loaded: "+e.video.title)
  }
  
  function onPlaybackStarted(e) {
    alert("Playing!")
  }
</script>
*/

package goplayer
{
  import flash.external.ExternalInterface
  
  public class JavaScriptAPI
  {
    private static var listeners:Object
    
    public static function initialize()
    {
      listeners = new Object
      
      ExternalInterface.addCallback("addEventListener", addEventListener)
      ExternalInterface.addCallback("removeEventListener", removeEventListener)
      ExternalInterface.call("onPlayerReady")
    }
    
    public static function dispatchEvent(type:String, event:Object)
    {
      if(!listeners[type]) return
      for each (var callback:String in listeners[type])
      {
        ExternalInterface.call(callback, event)
      }
    }
    
    private static function addEventListener(type:String, callback:String = null)
    {
      if(!callback) callback = type
      listeners[type] = listeners[type] || new Array
      listeners[type].push(callback)
    }
    
    private static function removeEventListener(type:String, callback:String = null)
    {
      if(!callback) callback = type
      var callbacks:Array = listeners[type] = listeners[type] || new Array
      for(var i=0; i<callbacks.length; i++)
      {
        var cb:String = callbacks[i]
        if (cb == callback)
        {
          callbacks.splice(i, 1)
          return
        }
      }
    }
  }
}