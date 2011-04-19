package goplayer
{
  import flash.display.LoaderInfo
  import flash.utils.describeType
  import flash.utils.getQualifiedClassName

  public class PluginSWFLoader implements IFlashContentLoaderListener
  {
    private var url : String
    private var listener : IPluginSWFLoaderListener

    private var info : LoaderInfo

    public function PluginSWFLoader(url : String, listener : IPluginSWFLoaderListener)
    { this.url = url, this.listener = listener }

    public function execute() : void
    {
      debug("Loading plugin SWF <" + url + ">...")
      new FlashContentLoader().load(url, this)
    }

    public function handleContentLoaded(info : LoaderInfo) : void
    {
      this.info = info

      if (!(info.content is IPluginSWF))
        reportTypeMismatch()
      else
        handlePluginSWFLoaded(IPluginSWF(info.content))
    }

    private function reportTypeMismatch() : void
    {
      if (actualInterfaceNames.indexOf(expectedInterfaceName) != -1)
        reportWrongApplicationDomain()
      else
        reportInterfaceMissing()
    }

    private function reportWrongApplicationDomain() : void
    {
      debug("Error: Could not load plugin into the application domain " +
          "of the player.")
      debug("If you are running locally, please make sure that both the " +
          "player SWF and the plugin SWF are trusted by Flash Player; the " +
          "easiest way to do so is usually to go to the Flash Player " +
          "global settings and choose Add directory.")
    }

    private function reportInterfaceMissing() : void
    {
      debug("Error: Plugin SWF must implement " + expectedInterfaceName + ".")
      debug("If your plugin is a compiled FLA file, please make sure that " +
          "the document class is set to a class that implements the " +
          "correct version of this interface.")
    }

    private function get actualInterfaceNames() : Array
    {
      const typeInfo : XML = describeType(info.content)
      const result : Array = []

      for each (var element : XML in typeInfo.implementsInterface)
      result.push(element.@type)

      return result
    }

    private function get expectedInterfaceName() : String
    { return getQualifiedClassName(IPluginSWF) }

    private function handlePluginSWFLoaded(swf : IPluginSWF) : void
    {
      debug("Plugin SWF loaded successfully.")
      listener.handlePluginSWFLoaded(swf)
    }
  }
}
