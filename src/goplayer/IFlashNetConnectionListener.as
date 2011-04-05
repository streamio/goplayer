package goplayer
{
  public interface IFlashNetConnectionListener
  {
    function handleConnectionEstablished() : void
    function handleConnectionFailed() : void
    function handleConnectionClosed() : void
    function handleBandwidthDetermined
      (bandwidth : Bitrate, latency : Duration) : void
  }
}
