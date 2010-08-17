package goplayer
{
  import org.asspec.util.sequences.Sequence

  public interface MovieMetadata
  {
    function get title() : String
    function get rtmpStreams() : Sequence
    function get duration() : Duration

    function dump() : void
  }
}
