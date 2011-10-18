/*
import streamio.BandwidthChecker

var checker:BandwidthChecker = new BandwidthChecker()
checker.onComplete = function(kbps:Number) { trace("bandwidth calculated to "+kbps+"Kbps") }
checker.onError = function() { trace("somehow failed to determine bandwidth") }
checker.check()

// optionally you can set a specific file you want to check for
checker.file = "http://domain.com/file.ext"

// you may also specify how long to keep calculating bandwidth if the file takes too long to download completely
checker.timeOutDelay = 5000
*/

package streamio
{
  import goplayer.Configuration

  public class BandwidthChecker
  {
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.utils.*;

    private var stream:URLStream
    private var openTime:Number
    private var timeoutId:Number

    public var onComplete:Function
    public var onError:Function
    public var file:String = Configuration.protocol+"d253c4ja9jigvu.cloudfront.net/assets/bandwidth_checker.mov"
    public var timeOutDelay:Number = 3000

    public function BandwidthChecker()
    {
      stream = new URLStream()
      stream.addEventListener(Event.OPEN, onStreamOpen)
      stream.addEventListener(Event.COMPLETE, onStreamComplete)
      stream.addEventListener(IOErrorEvent.IO_ERROR, onStreamError)
    }

    public function check()
    {
      reset()
      var request:URLRequest = new URLRequest(file+"?"+new Date().valueOf())
      stream.load(request)
    }

    private function reset()
    {
      clearInterval(timeoutId)
      try
        { stream.close() }
      catch (error : Error)
        {}
    }

    private function onStreamOpen(e:Event)
    {
    	openTime = getTimer()
    	timeoutId = setTimeout(timeOut, timeOutDelay)
    }

    private function onStreamComplete(e:Event)
    {
      clearInterval(timeoutId)

    	var timeTakenInSeconds:Number = Math.abs(openTime - getTimer()) / 1000
    	var kiloBitsLoaded:Number = stream.bytesAvailable / 1000 * 8
    	var kbps:Number = kiloBitsLoaded / timeTakenInSeconds
    	onComplete(kbps)
    }

    private function timeOut()
    {
      var timeTakenInSeconds:Number = timeOutDelay / 1000
    	var kiloBitsLoaded = stream.bytesAvailable / 1000 * 8
    	var kbps = kiloBitsLoaded / timeTakenInSeconds
    	stream.close()
    	onComplete(kbps)
    }

    private function onStreamError(e:IOErrorEvent)
    {
      reset()
      onError()
    }
  }
}