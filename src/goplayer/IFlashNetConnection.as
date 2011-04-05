package goplayer
{
  public interface IFlashNetConnection
  {
    function set listener(value : IFlashNetConnectionListener) : void
    function connect(url : URL) : void
    function dontConnect() : void
    function determineBandwidth() : void
    function getNetStream() : IFlashNetStream
  }
}
