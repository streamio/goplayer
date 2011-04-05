package goplayer
{
  public interface IPlayerListener
  { 
    function handleMovieFinishedPlaying() : void
    function handleCurrentTimeChanged() : void
  }
}
