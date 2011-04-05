package goplayer
{
  public interface IRTMPStream
  {
    function get name() : String
    function get bitrate() : Bitrate
    function get dimensions() : Dimensions
  }
}
