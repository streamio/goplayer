package goplayer
{
  public class StandardHTTP implements IHTTP
  {
    public function fetch(url : URL, handler : IHTTPResponseHandler) : void
    { new HTTPFetchAttempt(url, handler).execute() }

    public function post(url : URL, parameters : Object, handler : IHTTPResponseHandler) : void
    { new HTTPPostAttempt(url, parameters, handler).execute() }
  }
}
