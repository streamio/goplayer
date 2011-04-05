package goplayer
{
  public interface IFlashNetStreamListener
  {
    function handleNetStreamMetadata(data : Object) : void
    function handleStreamingStarted() : void
    function handleBufferFilled() : void
    function handleBufferEmptied() : void
    function handleStreamingStopped() : void
    function handleCurrentTimeChanged() : void
  }
}
