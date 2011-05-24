package goplayer
{
  import flash.ui.Keyboard

  public class Application extends Component
  implements ISkinSWFLoaderListener, IPluginSWFLoaderListener, IMovieHandler, IPlayerListener
  {
    private const background : Background = new Background(0x000000, 1)
    private const contentLayer : Component = new Component
    private const debugLayer : Component = new EphemeralComponent

    private var configuration : Configuration

    private var api : StreamioAPI

    private var skinSWF : ISkinSWF = null
    private var pluginSWF : IPluginSWF = null
    private var movie : IMovie = null
    private var player : Player = null
    private var view : Component = null

    private var _listener : IApplicationListener = null

    public function Application(parameters : Object)
    {
      this.configuration = ConfigurationParser.parse(parameters)

      if (configuration.externalLoggingFunctionName !== "")
        // Parse the parameters again for logging purposes.
        installLogger(), ConfigurationParser.parse(parameters)

      JavaScriptAPI.initialize()

      api = new StreamioAPI(configuration.apiURL, new StandardHTTP, configuration.trackerID)

      addChild(background)
      addChild(contentLayer)
      addChild(debugLayer)
    }

    public function set listener(value : IApplicationListener) : void
    { _listener = value }

    private function installLogger() : void
    {
      new DebugLoggerInstaller
        (configuration.externalLoggingFunctionName, debugLayer).execute()
    }

    override protected function initialize() : void
    {
      onkeydown(stage, handleKeyDown)

      if (configuration.pluginURL)
        loadPlugin()

      if (configuration.skinURL)
        loadSkin()
      else
        lookUpMovie()
    }

    private function loadSkin() : void
    { new SkinSWFLoader(configuration.skinURL, this).execute() }

    public function handleSkinSWFLoaded(swf : ISkinSWF) : void
    {
      skinSWF = swf
      lookUpMovie()
    }

    private function lookUpMovie() : void
    {
      debug("Looking up Streamio video “" + configuration.movieID + "”...")
      api.fetchMovie(configuration.movieID, this)
    }

    private function loadPlugin() : void
    { new PluginSWFLoader(configuration.pluginURL, this).execute() }

    public function handlePluginSWFLoaded(swf : IPluginSWF) : void
    {
    	PluginAPI.config = configuration.pluginConfig
    	PluginAPI.mouseEventListener = stage
    	pluginSWF = swf
    	initPlugin()
    }

    private function initPlugin() : void
    {
    	if(pluginSWF)
    	{
    		PluginAPI.plugin = pluginSWF.getPlugin()
    		PluginAPI.plugin.init()
    	}
    }

    public function handleMovie(movie : IMovie) : void
    {
      this.movie = movie

      logMovieInformation()
      createPlayer()

      PluginAPI.dimensions = dimensions

      JavaScriptAPI.dispatchEvent("onVideoLoaded", {video: movie.attributes})

      if (configuration.enableAutoplay)
        player.start()
    }

    private function logMovieInformation() : void
    {
      debug("Movie “" + movie.title + "” found.")
      debug("Will use " + configuration.bitratePolicy + ".")

      const bitrates : Array = []

      for each (var stream : IRTMPStream in movie.rtmpStreams)
        bitrates.push(stream.bitrate)

      if (bitrates.length == 0)
        debug("No RTMP streams available.")
      else
        debug("Available RTMP streams: " + bitrates.join(", "))

      if (!configuration.enableRTMP)
        debug("Will not use RTMP (disabled by configuration).")
    }

    private function createPlayer() : void
    {
      if (player != null)
        player.destroy()

      const kit : PlayerKit = new PlayerKit
        (movie, configuration.bitratePolicy, configuration.enableRTMP, api, dimensions)

      player = kit.player
      player.listener = this

      if (skinSWF)
        view = new SkinnedPlayerView(kit.video, player, viewConfiguration)
      else
        view = new SimplePlayerView(kit.video, player)

      if (pluginSWF)
        view.plugin.addChild(PluginAPI.plugin.getDisplay())

      contentLayer.addChild(view)
    }

    private function get viewConfiguration() : SkinnedPlayerViewConfiguration
    {
      const result : SkinnedPlayerViewConfiguration = new SkinnedPlayerViewConfiguration

      result.skin = skinSWF.getSkin()
      result.enableChrome = configuration.enableChrome
      result.enableLargePlayButton = configuration.enableLargePlayButton
      result.enableTitle = configuration.enableTitle
      result.enableShareButton = configuration.enableShareButton
      result.enableEmbedButton = configuration.enableEmbedButton
      result.enablePlayPauseButton = configuration.enablePlayPauseButton
      result.enableElapsedTime = configuration.enableElapsedTime
      result.enableSeekBar = configuration.enableSeekBar
      result.enableTotalTime = configuration.enableTotalTime
      result.enableVolumeControl = configuration.enableVolumeControl
      result.enableFullscreenButton = configuration.enableFullscreenButton

      return result
    }

    public function handleKeyDown(key : Key) : void
    {
      if (key.code == Keyboard.ENTER)
        debugLayer.visible = !debugLayer.visible
      else if (player != null)
        $handleKeyDown(key)
    }

    private function $handleKeyDown(key : Key) : void
    {
      if (key.code == Keyboard.SPACE)
        player.togglePaused()
      else if (key.code == Keyboard.LEFT)
        player.seekBy(Duration.seconds(-3))
      else if (key.code == Keyboard.RIGHT)
        player.seekBy(Duration.seconds(+3))
      else if (key.code == Keyboard.UP)
        player.changeVolumeBy(+.1)
      else if (key.code == Keyboard.DOWN)
        player.changeVolumeBy(-.1)
    }

    public function handleMovieFinishedPlaying() : void
    {
      if (configuration.enableLooping)
        debug("Looping."), player.rewind()
      else if (_listener != null)
        _listener.handlePlaybackEnded()
    }

    public function handleCurrentTimeChanged() : void
    {
      if (_listener != null)
        _listener.handleCurrentTimeChanged()
    }

    public function play() : void
    {
      if (player != null)
        $play()
    }

    private function $play() : void
    {
      if (player.started)
        player.paused = false
      else
        player.start()
    }

    public function pause() : void
    {
      if (player != null)
        player.paused = true
    }

    public function stop() : void
    {
      if (player != null)
        player.stop()
    }

    public function get currentTime() : Duration
    { return player.currentTime }

    public function set currentTime(value : Duration) : void
    { player.currentTime = value }

    public function get duration() : Duration
    { return player.duration }
  }
}
