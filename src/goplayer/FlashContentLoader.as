package goplayer
{
  public class FlashContentLoader
  {
    public function load
      (url : String, listener : IFlashContentLoaderListener) : void
    { new FlashContentLoadAttempt(url, listener).execute() }
  }
}
