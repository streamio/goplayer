package goplayer
{
  public interface IMovie
  {
    function get attributes() : Object // Should be a pure AS object that can be serialized through ExternalInterface

    function get id() : String
    function get title() : String
    function get duration() : Duration
    function get aspectRatio() : Number
    function get imageURL() : URL
    function get watermarkURL() : URL
    function get watermarkLink() : String

    function get rtmpURL() : URL
    function get rtmpStreams() : Array

    function get httpURL() : URL
    function get httpStreams() : Array

    function get shareURL() : URL
  }
}
