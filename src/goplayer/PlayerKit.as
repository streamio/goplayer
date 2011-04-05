package goplayer
{
  import flash.media.Video

  public class PlayerKit
  {
    private const flashVideo : Video = new Video
    private const connection : IFlashNetConnection
      = new StandardFlashNetConnection(flashVideo)
    private const sharedVolumeVariable : SharedVariable
      = new SharedVariable("player", "volume")

    public var player : Player
    public var video : PlayerVideo

    public function PlayerKit
      (movie : IMovie,
       bitratePolicy : BitratePolicy,
       enableRTMP : Boolean,
       reporter : IMovieEventReporter,
       dimensions : Dimensions)
    {
      player = new Player
        (connection,
         movie,
         bitratePolicy,
         enableRTMP,
         reporter,
         sharedVolumeVariable,
         new ShareEmbed(movie, dimensions))

      video = new PlayerVideo(player, flashVideo)
    }
  }
}
