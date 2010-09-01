package goplayer
{
	import flash.display.DisplayObject
	import flash.display.Sprite

  public class AbstractSkin extends Component implements Skin
  {
    private var _backend : SkinBackend = null

    public function set backend(value : SkinBackend) : void
    { _backend = value }

    public function get frontend() : DisplayObject
    { return this }

    override public function update() : void
    {
      super.update()

      dimensions = internalDimensions

      scaleX = backend.skinScale
      scaleY = backend.skinScale
    }

    private function get internalDimensions() : Dimensions
    { return externalDimensions.scaledBy(1 / backend.skinScale) }

    private function get externalDimensions() : Dimensions
    { return new Dimensions(backend.skinWidth, backend.skinHeight) }

    // -----------------------------------------------------

    public function get backend() : SkinBackend
    { return _backend }

    protected function get playheadRatio() : Number
    { return backend.playheadRatio }

    protected function get bufferRatio() : Number
    { return backend.bufferRatio }

    protected function get bufferFillRatio() : Number
    { return backend.bufferFillRatio }

    protected function get playing() : Boolean
    { return backend.playing }

    protected function get buffering() : Boolean
    { return backend.buffering }

    protected function get volume() : Number
    { return backend.volume }

    protected function get muted() : Boolean
    { return volume == 0 }

    protected function get leftTimeText() : String
    { return getDurationByRatio(playheadRatio).mss }

    protected function get rightTimeText() : String
    { return getDurationByRatio(1 - playheadRatio).mss }

    protected function getDurationByRatio(ratio : Number) : Duration
    { return Duration.seconds(backend.streamLengthSeconds * ratio) }

    protected function lookup(name : String) : *
    {
      try
        { return SkinPartFinder.lookup(this, name.split(".")) }
      catch (error : SkinPartMissingError)
        { backend.handleSkinPartMissing(error.names.join(".")) }

      return null
    }

    protected function undefinedPart(name : String) : *
    { lookup("<undefined:" + name + ">") ; return null }
  }
}