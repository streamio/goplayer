package goplayer
{
  import flash.display.DisplayObject
  import flash.display.InteractiveObject
  import flash.display.Sprite
  import flash.text.TextField
  import flash.events.*

	public class StandardSkinWithTitleScreen extends StandardSkin
  {
    protected var titleScreenFader : Fader
    
    override protected function initialize() : void
    {
      super.initialize()
      
      addEventListener(Event.ENTER_FRAME, checkTitleMouseOver)
      onclick(titleScreen, function() { backend.handleUserPlay() })

      titleScreen.buttonMode = true
      titleScreen.mouseChildren = false
      titleScreenFader = new Fader(titleScreen, Duration.seconds(1))
      titleScreen.title.text = titleText
      
      titleScreen.description.html = true
      
      titleScreen.description.autoSize = titleScreen.title.autoSize = "left"
    }
    
    protected function checkTitleMouseOver(event : Event) : void
    {
      titleScreen.over.visible = titleScreen.over.hitTestPoint(mouseX, mouseY)
    }
    
    override public function update() : void
    {
      super.update()

      setPosition(titleScreen, dimensions.center)
      var backgroundWidth : Number = (stage.stageWidth / 2) - titleScreen.background.x
      titleScreen.background.width = titleScreen.description.width = backgroundWidth * 2
      
      if(backend.movie.description && backend.movie.description.length > 0)
      {
        titleScreen.description.htmlText = "<i>"+truncate(backend.movie.description, backgroundWidth / 10)+"</i>"
      }
      else
      {
        titleScreen.description.visible = false
        titleScreen.title.y = -20
      }
      
      titleScreenFader.targetAlpha = showLargePlayButton ? 1 : 0
    }
    
    override protected function get showChrome() : Boolean
    { return backend.showChrome && running }
    
    protected function get titleScreen() : MovieClip
    { return lookup("titleScreen") }
    
    protected function truncate(string : String, length : Number) : String
    {
      if(string.length > length)
      {
        var words : Array = string.split(" ")
        string = words.shift()
        for(var i=0; i<words.length; i++)
        {
          var word : String = words[i]
          if(string.length + word.length > length)
            return string + "..."
          else
            string += " "+word
        }
      }
      return string
    }
  }
}
