package goplayer
{
  public interface IMovieEventReporter
  {
    function reportMovieViewed(movieID : String) : void
    function reportMoviePlayed(movieID : String) : void
    function reportMovieHeatmapData(movieID : String, time : Number) : void
  }
}
