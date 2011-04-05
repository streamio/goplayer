package goplayer
{
  import flash.display.DisplayObject

  public interface ISkin
  {
    function set backend(value : ISkinBackend) : void
    function get frontend() : DisplayObject
    function update() : void
  }
}
