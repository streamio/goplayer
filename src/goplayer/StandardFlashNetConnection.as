package goplayer
{
  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.media.Video
  import flash.net.NetConnection
  import flash.net.NetStream
  import streamio.BandwidthChecker

  public class StandardFlashNetConnection implements IFlashNetConnection
  {
    private const connection : NetConnection = new NetConnection

    private var video : Video

    private var _listener : IFlashNetConnectionListener

    private var dummy : Boolean = false
    private var serverVersion : Number = 0

    private var bandwidthChecker : BandwidthChecker

    public function StandardFlashNetConnection(video : Video)
    {
      this.video = video

      bandwidthChecker = new BandwidthChecker()
      bandwidthChecker.onComplete = function(kbps:Number) {
        _listener.handleBandwidthDetermined(Bitrate.kbps(kbps), Duration.milliseconds(0))
      }
      bandwidthChecker.onError = function() {
        _listener.handleBandwidthDetermined(Bitrate.kbps(0), Duration.milliseconds(0))
      }

      connection.addEventListener(NetStatusEvent.NET_STATUS, handleNetConnectionStatus)
      connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError)
      connection.client = { onBWCheck: onBWCheck, onBWDone: onBWDone }
    }

    public function set listener(value : IFlashNetConnectionListener) : void
    { _listener = value }

    public function connect(url : URL) : void
    {
      debug("Connecting to <" + url + ">...")

      try
        { connection.connect(url.toString()) }
      catch (error : Error)
        {
          debug("Connection failed: " + error.message)
          _listener.handleConnectionFailed()
        }
    }

    public function dontConnect() : void
    {
      dummy = true
      connection.connect(null)
    }

    public function determineBandwidth() : void
    {
      debug("Performing bandwidth check...")
      if(dummy)
        bandwidthChecker.check()
      else
        connection.call("checkBandwidth", null)
    }

    private function onBWCheck(... rest : Array) : Number
    { return 0 }

    private function onBWDone(... rest : Array) : void
    {
      if (rest.length == 0) return

      const bandwidth : Bitrate = Bitrate.kbps(rest[0])
      const latency : Duration = Duration.milliseconds(rest[3])

      _listener.handleBandwidthDetermined(bandwidth, latency)
    }

    public function getNetStream() : IFlashNetStream
    { return new StandardFlashNetStream(connection, video) }

    private function handleNetConnectionStatus(event : NetStatusEvent) : void
    {
      const code : String = event.info.code

      if (code == CONNECTION_ESTABLISHED && !dummy)
        if (event.info.data && "version" in event.info.data)
          parseServerVersion(event.info.data.version)

      if (dummy)
        null
      else if (code == CONNECTION_ESTABLISHED)
        debug("Connection established " +
              "(server version " + serverVersion + ").")
      else if (code == CONNECTION_FAILED)
        debug("Connection failed.")
      else if (code == CONNECTION_CLOSED)
        debug("Connection closed.")
      else if (code == NETWORK_CHANGED)
        debug("Detected change in network conditions.")
      else if (code == IDLE_TIME_OUT)
        debug("Closing idle connection.")
      else
        debug("Net connection status: " + code)

      if (code == CONNECTION_ESTABLISHED && !dummy)
        _listener.handleConnectionEstablished()
      else if (code == CONNECTION_FAILED)
        // When the connection fails, the listener is likely to make
        // another attempt at connecting.  But NetConnection.connect
        // cannot be called from within this event handler, so we
        // prevent that from happening by trampolining here.
        later(_listener.handleConnectionFailed)
      else if (code == CONNECTION_CLOSED)
        _listener.handleConnectionClosed()
    }

    private function parseServerVersion(input : String) : void
    { serverVersion = parseFloat(input.replace(/^(\d+),(\d+).*/, "$1.$2")) }

    private function handleAsyncError(event : AsyncErrorEvent) : void
    { debug("Asynchronuous connection error: " + event.error.message) }

    private static const CONNECTION_ESTABLISHED : String
      = "NetConnection.Connect.Success"
    private static const CONNECTION_FAILED : String
      = "NetConnection.Connect.Failed"
    private static const CONNECTION_CLOSED : String
      = "NetConnection.Connect.Closed"
    private static const NETWORK_CHANGED : String
      = "NetConnection.Connect.NetworkChange"
    private static const IDLE_TIME_OUT : String
      = "NetConnection.Connect.IdleTimeOut"
  }
}
