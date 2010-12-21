package goplayer
{
  public function debug(message : Object) : void
  { 
    trace(message)
    debugLogger.log(message.toString()) 
  }
}
