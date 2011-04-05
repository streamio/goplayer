package goplayer
{
  import flash.display.Sprite

	public class StandardSkinSWF extends Sprite implements ISkinSWF
  {
    public function getSkin() : ISkin
    { return new ThisSkin }
  }
}
