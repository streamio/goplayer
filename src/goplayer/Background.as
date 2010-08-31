package goplayer
{
  public class Background extends Component
  {
    public function Background(color : uint, alpha : Number)
    {
      this.color = color
      this.alpha = alpha

      mouseEnabled = false
      mouseChildren = false
    }

    override public function update() : void
    { width = dimensions.width, height = dimensions.height }

    public function set color(value : uint) : void
    {
      graphics.clear()
      graphics.beginFill(value)
      graphics.drawRect(0, 0, 1, 1)
      graphics.endFill()
    }
  }
}
