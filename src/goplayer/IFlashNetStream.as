package goplayer
{
  import flash.media.Video

  public interface IFlashNetStream
  {
    function set listener(value : IFlashNetStreamListener) : void

    function playRTMP(stream : IRTMPStream, streams : Array) : void
    function playHTTP(url : URL) : void

    function get httpFileSize() : Bitsize

    function set paused(value : Boolean) : void

    function get currentTime() : Duration
    function set currentTime(value : Duration) : void

    function get bitrate() : Bitrate
    function get bandwidth() : Bitrate

    function get bufferLength() : Duration

    function get bufferTime() : Duration
    function set bufferTime(value : Duration) : void

    function get bytesLoaded() : uint
    function get bytesTotal() : uint

    function get volume() : Number
    function set volume(value : Number) : void

    function close() : void
    function destroy() : void
  }
}
