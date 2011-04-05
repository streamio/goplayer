package goplayer
{
  public interface IHTTP
  {
    function fetch(url : URL, handler : IHTTPResponseHandler) : void
    function post(url : URL, parameters : Object, handler : IHTTPResponseHandler) : void
  }
}
