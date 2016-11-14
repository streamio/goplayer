package goplayer
{
  import flash.display.Sprite
  import flash.display.StageDisplayState
  import flash.display.MovieClip
  import flash.net.URLRequest
  import flash.net.navigateToURL
  import flash.events.Event
  import flash.events.FullScreenEvent
  import flash.events.MouseEvent
  import flash.events.TimerEvent
  import flash.geom.Point
  import flash.geom.Rectangle
  import flash.media.Video
  import flash.utils.Timer

  public class PlayerVideo extends Component
  {
    private const timer : Timer = new Timer(30)
    private const screenshot : ExternalImage = new ExternalImage
    private const watermark : ExternalImage = new ExternalImage
	private const watermarkContainer : MovieClip = new MovieClip

    private const listeners : Array = []

    private var player : Player
    private var video : Video

    public function PlayerVideo(player : Player, video : Video)
    {
      this.player = player
      this.video = video

      video.smoothing = true

      addChild(screenshot)
      addChild(video)
      watermarkContainer.addChild(watermark)
	  addChild(watermarkContainer)

      if (player.movie.imageURL)
        screenshot.url = player.movie.imageURL
		
	  if (player.movie.watermarkURL) {
		watermark.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event) {
			var watermarkDimensions:Dimensions = new Dimensions(watermark.width, watermark.height)
			
			var watermarkPosition:Position = new Position(stage.stageWidth - watermark.width - 10, 10)
			setBounds(watermark, watermarkPosition, watermarkDimensions)
			stage.addEventListener(Event.ENTER_FRAME, function(e:Event) {
				if ( stage ) {
					var watermarkPosition:Position = new Position(stage.stageWidth - watermark.width - 10, 10)
					setBounds(watermark, watermarkPosition, watermarkDimensions)
				}
			});			
		})
        watermark.url = player.movie.watermarkURL
		if ( player.movie.watermarkLink ) {
			watermarkContainer.buttonMode = true;
			watermarkContainer.useHandCursor = true;
			watermark.addEventListener(MouseEvent.CLICK, function():void {
				navigateToURL(new URLRequest(player.movie.watermarkLink));
			})
		}
	  }	  

      mouseChildren = true
      doubleClickEnabled = true

      timer.addEventListener(TimerEvent.TIMER, handleTimerEvent)
      timer.start()

      addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage)
      video.addEventListener(MouseEvent.CLICK, handleClick)
      video.addEventListener(MouseEvent.DOUBLE_CLICK, handleDoubleClick)
    }

    public function addUpdateListener(value : IPlayerVideoUpdateListener) : void
    { listeners.push(value) }

    private function handleAddedToStage(event : Event) : void
    {
      stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenEvent)
    }

    private function handleClick(event : MouseEvent) : void
    { player.togglePaused() }

    private function handleDoubleClick(event : MouseEvent) : void
    {
      player.togglePaused() // Reverse the effect of the first click
      toggleFullscreen()
    }

    public function toggleFullscreen() : void
    {
      if (fullscreenEnabled)
        disableFullscreen()
      else
        enableFullscreen()
    }

    public function enableFullscreen() : void
    { stage.displayState = StageDisplayState.FULL_SCREEN }

    public function disableFullscreen() : void
    { stage.displayState = StageDisplayState.NORMAL }

    public function get fullscreenEnabled() : Boolean
    { return stage && stage.displayState == StageDisplayState.FULL_SCREEN }

    private function handleTimerEvent(event : TimerEvent) : void
    { relayout() }

    private function handleFullScreenEvent(event : FullScreenEvent) : void
    {
      PluginAPI.dimensions = dimensions
      relayout()
    }

    override public function update() : void
    {
      video.visible = videoVisible
	  setBounds(video, videoPosition, videoDimensions)
      setBounds(screenshot, videoPosition, videoDimensions)
	  

      for each (var listener : IPlayerVideoUpdateListener in listeners)
        listener.handlePlayerVideoUpdated()
    }

    private function get videoVisible() : Boolean
    { return player.playing || player.paused }

    public function get videoPosition() : Position
    { return dimensions.minus(videoDimensions).halved.asPosition }

    public function get videoCenter() : Position
    { return videoPosition.plus(videoDimensions.halved) }

    public function get videoDimensions() : Dimensions
    {
      var vd : Dimensions = dimensions.getInnerDimensions(player.aspectRatio)

      // Avoid decimal values causing <1px letter boxing on slight
      // player vs video dimensions mismatch.

      vd._width = Math.ceil(vd._width)
      vd._height = Math.ceil(vd._height)

      return vd
    }

    override public function get dimensions() : Dimensions
    { return fullscreenEnabled ? fullscreenDimensions : layoutDimensions }

    private function get fullscreenDimensions() : Dimensions
    { return stage ? $fullscreenDimensions : layoutDimensions }

    private function get $fullscreenDimensions() : Dimensions
    { return new Dimensions(stage.fullScreenWidth, stage.fullScreenHeight) }

    private function get fullScreenSourceRect() : Rectangle
    {
      const localPoint : Point = new Point(video.x, video.y)
      const globalPoint : Point = localToGlobal(localPoint)

      return new Rectangle
        (globalPoint.x, globalPoint.y, video.width, video.height)
    }
  }
}
