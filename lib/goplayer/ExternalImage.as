package goplayer
{
  import flash.display.Bitmap
  import flash.display.Loader
  import flash.system.LoaderContext
  import flash.events.Event

  public class ExternalImage extends Loader
  {
    public function ExternalImage()
    { contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete) }

    public function set url(value : URL) : void
    {
      var context:LoaderContext = new LoaderContext();
      context.checkPolicyFile = true;
      load(value.asURLRequest, context);
    }

    private function handleComplete(event : Event) : void
    {
      try
        { Bitmap(content).smoothing = true }
      catch (error : Error)
        {}
    }
  }
}
