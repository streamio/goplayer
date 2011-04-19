package goplayer
{
  import flash.display.Stage
  import flash.events.MouseEvent

  public class PluginAPI 
  {
    private static var _dimensions : Dimensions = null
    private static var _plugin : IPlugin = null
    private static var _player : Player = null
    private static var _configuration:Object = {}
    private static var _volume : Number = NaN
    private static var _times: Object = null
    private static var _lockDown:Boolean = false

    private static var _hideUIElements:Boolean = false
    private static var _showOnlyControlbar:Boolean = false
    private static var _stage:Stage = null

    public function PluginAPI() { }

    public static function get player() : Player
    { return _player }

    public static function set player(value : Player) : void
    { _player = value }

    public static function set plugin(plgn : IPlugin) : void
    { _plugin = plgn }

    public static function get plugin() : IPlugin
    { return _plugin }

    public static function get dimensions() : Dimensions
    { return _dimensions }

    public static function set dimensions(value : Dimensions) : void
    {
      _dimensions = value

      if(plugin)
        plugin.onResize()
    }

    public static function get volume() : Number
    { return _volume }

    public static function set volume(value : Number) : void
    {
      _volume = value

      if(plugin)
        plugin.onVolumeChange()
    }

    public static function get videoUpdate() : Object
    { return _times }

    public static function set videoUpdate(timeObj : Object) : void
    {
      _times = timeObj

      if(plugin)
        plugin.onContentProgress()
    }

    public static function onBeforeContent() : void
    { if(plugin) plugin.onBeforeContentStart() }

    public static function onBeforeRewind() : void
    { if(plugin) plugin.onBeforeRewind() }

    public static function proceedRewind():void
    { _player.proceedRewind() }

    public static function afterContent() : void
    { if(plugin) plugin.onContentFinished() }

    public static function get lockDown() : Boolean
    { return _lockDown }

    public static function set lockDown(bool : Boolean) : void
    {
      debug("__ set LockDown: " + bool)
      _lockDown = bool
    }

    public static function proceedContentStart():void
    { player.proceedStartPlaying() }

    public static function proceedContentFinished():void
    { player.proceedHandleFinishedPlaying() }

    public static function contentPause():void
    {
      _player.paused = true
      PluginAPI.lockDown = true
    }

    public static function contentPlay() : void
    { _player.paused = false }

    public static function get playing() : Boolean
    { return !_player.paused }

    public static function pluginPause() : void
    { if (plugin) plugin.onPause() }

    public static function pluginPlay() : void
    { if (plugin) plugin.onPlay() }

    public static function set config(cfg : Object) : void
    { _configuration = cfg }

    public static function get config() : Object
    { return _configuration }

    public static function hideControlbar() : void
    { _showOnlyControlbar = false }

    public static function showControlbar() : void
    { _showOnlyControlbar = true }

    public static function disableUIElements() : void
    { _hideUIElements = true }

    public static function enableUIElements() : void
    {
      _showOnlyControlbar = false
      _hideUIElements = false
    }

    public static function get hideUIElements() : Boolean
    { return _hideUIElements }

    public static function get showOnlyControlbar() : Boolean
    { return _showOnlyControlbar }

    public static function set mouseEventListener(playerStage : Stage) : void
    { _stage = playerStage }

    public static function receiveMouseEvent(mouseEventObject : Object) : void
    {
      if(_stage)
        _stage.dispatchEvent( new MouseEvent(MouseEvent.MOUSE_MOVE, true, false, mouseEventObject.localX, mouseEventObject.localY) )
    }

    public static function onSeek() : void
    {}
  }
}