package goplayer
{
  import flash.external.ExternalInterface

  public class Configuration
  {
    public var skinURL : String
    public var pluginURL : String
    public var movieID : String
    public var playerID : String
    public var bitratePolicy : BitratePolicy
    public var enableRTMP : Boolean
    public var enableAutoplay : Boolean
	public var startMute : Boolean
    public var enableLooping : Boolean
    public var externalLoggingFunctionName : String
    public var revision : String

    public var enableChrome : Boolean
    public var enableLargePlayButton : Boolean
    public var enableTitle : Boolean
    public var enableShareButton : Boolean
    public var enableEmbedButton : Boolean
    public var enablePlayPauseButton : Boolean
    public var enableElapsedTime : Boolean
    public var enableSeekBar : Boolean
    public var enableTotalTime : Boolean
    public var enableVolumeControl : Boolean
    public var enableFullscreenButton : Boolean

    public var apiURL : String
    public var stok : String
    public var channel : String

    public var pluginConfig : Object

    private static var _protocol : String
    public static function get protocol() : String
    {
      if(_protocol) return _protocol
      var protocol = ExternalInterface.call("document.location.protocol.toString") || "http:"
      _protocol = protocol + "//"
      return _protocol
    }
  }
}
