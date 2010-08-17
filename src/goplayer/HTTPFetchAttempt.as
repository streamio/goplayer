package goplayer
{
  import flash.display.Bitmap
  import flash.display.Loader
  import flash.events.Event
  import flash.net.URLLoader
  import flash.net.URLRequest

  public class HTTPFetchAttempt
  {
    private const loader : URLLoader = new URLLoader

    private var url : URL
    private var handler : HTTPResponseHandler

    public function HTTPFetchAttempt
      (url : URL, handler : HTTPResponseHandler)
    { this.url = url, this.handler = handler }

    public function execute() : void
    {
      loader.addEventListener(Event.COMPLETE, handleContentLoaded)
      loader.load(new URLRequest(url.toString()))
    }
    
    private function handleContentLoaded(event : Event) : void
    { handler.handleHTTPResponse(loader.data) }
  }
}
