package goplayer
{
  public class StreamioAPI implements IMovieEventReporter
  {
    private static const VERSION : String = "/v1"

    private var baseURL : String
    private var http : IHTTP
    private var channel : String
    private var stok : String
	private var player_id : String

    public function StreamioAPI(baseURL : String, http : IHTTP, channel : String, stok : String, player_id : String)
    {
      this.baseURL = baseURL
      this.http = http
      this.channel = channel
      this.stok = stok
	  this.player_id = player_id
    }

    // -----------------------------------------------------

    public function fetchMovie(id : String, handler : IMovieHandler) : void
    {
	  var query = "?player_id=" + this.player_id;	  
      query = query + (stok ? "&stok="+stok : "")
      fetch(getJSONMoviePath(id)+query, new MovieJSONHandler(handler, this))
    }

    public function getShareMovieURL(id : String) : URL
    { return getURL(getMoviePath(id)) }

    public function reportMovieViewed(movieID : String) : void
    { reportMovieEvent(movieID, "views", {}) }

    public function reportMoviePlayed(movieID : String) : void
    { reportMovieEvent(movieID, "plays", {}) }

    private function reportMovieEvent(movieID : String, event : String, parameters : Object) : void
    { post(statsPath, getStatsParameters(movieID, event, parameters)) }

    private function getStatsParameters(movieID : String, event : String, parameters : Object) : Object
    {
      const result : Object = new Object

      result.channel = channel
      result.video_id = movieID
      result.event = event

      for (var name : String in parameters)
        result[name] = parameters[name]

      return result
    }

    // -----------------------------------------------------

    private function getMoviePath(id : String) : String
    { return "/videos/" + id + "/public_show" }

    private function getJSONMoviePath(id : String) : String
    { return getMoviePath(id) + ".json" }

    private function get statsPath() : String
    { return "/stats" }

    // -----------------------------------------------------

    private function fetch(path : String, handler : IJSONHandler) : void
    { http.fetch(getURL(path), new JSONAdapter(handler)) }

    private function post(path : String, parameters : Object) : void
    { http.post(getURL(path), parameters, new NullHTTPHandler) }

    private function getURL(path : String) : URL
    { return URL.parse(baseURL + VERSION + path) }
  }
}

import com.adobe.serialization.json.JSON

import goplayer.*

class JSONAdapter implements IHTTPResponseHandler
{
  private var handler : IJSONHandler

  public function JSONAdapter(handler : IJSONHandler)
  { this.handler = handler }

  public function handleHTTPResponse(text : String) : void
  { handler.handleJSON(JSON.decode(text)) }

  public function handleHTTPError(message : String) : void
  { debug("Error: HTTP request failed: " + message) }
}

class MovieJSONHandler implements IJSONHandler
{
  private var handler : IMovieHandler
  private var api : StreamioAPI

  public function MovieJSONHandler
    (handler : IMovieHandler, api : StreamioAPI)
  { this.handler = handler, this.api = api }

  public function handleJSON(json : Object) : void
  { handler.handleMovie(new StreamioMovie(json, api)) }
}

class NullHTTPHandler implements IHTTPResponseHandler
{
  public function handleHTTPResponse(text : String) : void {}
  public function handleHTTPError(message : String) : void {}
}
