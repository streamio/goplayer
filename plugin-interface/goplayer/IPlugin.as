package goplayer
{
  import flash.display.DisplayObject
  import flash.display.MovieClip
  
  public interface IPlugin
  {
    function init():void
    function getDisplay():MovieClip
    function onResize():void
    function onVolumeChange():void
    function onContentProgress():void
    function onBeforeRewind():void
    function onBeforeContentStart():void
    function onContentFinished():void
    function onPause():void
    function onPlay():void
  }
}
