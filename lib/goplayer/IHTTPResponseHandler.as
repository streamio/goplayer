package goplayer
{
  public interface IHTTPResponseHandler
  {
    function handleHTTPResponse(text : String) : void
    function handleHTTPError(message : String) : void
  }
}
