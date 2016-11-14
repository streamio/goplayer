package goplayer
{
  public class StreamioMovie implements IMovie
  {
    private var json : Object
    private var api : StreamioAPI

    public function StreamioMovie(json : Object, api : StreamioAPI)
    { this.json = json, this.api = api }

    public function get attributes() : Object
    { return json }

    public function get id() : String
    { return json.id }

    public function get title() : String
    { return json.title }
    
    public function get description() : String
    { return json.description }

    public function get duration() : Duration
    { return Duration.seconds(json.duration) }

    public function get aspectRatio() : Number
    { return json.aspect_ratio_multiplier }

    public function get watermarkURL() : URL
	{
      if (json.watermark && json.watermark.image)
        return URL.parse(Configuration.protocol + json.watermark.image)
	  else
	    return null
	}
	
	public function get watermarkLink() : String
	{
      if (json.watermark && json.watermark.url)
        return json.watermark.url
	  else
	    return null
	}
	
	public function get imageURL() : URL
    {
      if (json.image)
        return URL.parse(Configuration.protocol + json.image.original)
      else
        return URL.parse(Configuration.protocol + json.screenshot.original)
    }

    public function get shareURL() : URL
    { return api.getShareMovieURL(id) }

    public function get httpURL() : URL
    { return hasTranscodings ? bestTranscoding.httpURL : null }

    public function get httpStreams() : Array
    { return transcodings }

    public function get rtmpURL() : URL
    { return hasTranscodings ? bestTranscoding.rtmpURL : null }

    public function get rtmpStreams() : Array
    { return transcodings }

    private function get hasTranscodings() : Boolean
    { return transcodings.length > 0 }

    private function get bestTranscoding() : StreamioTranscoding
    {
      var result : StreamioTranscoding = transcodings[0]

      for each (var transcoding : StreamioTranscoding in transcodings)
        if (transcoding.bitrate.isGreaterThan(result.bitrate))
          result = transcoding
      
      return result
    }

    private function get transcodings() : Array
    {
      const result : Array = []

      for each (var transcoding : Object in json.transcodings)
        result.push(new StreamioTranscoding(transcoding))

      return result
    }
  }
}
