package goplayer
{
  public interface IApplicationListener
  {
    function handleCurrentTimeChanged() : void
    function handlePlaybackEnded() : void
  }
}
