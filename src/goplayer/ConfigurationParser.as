package goplayer
{
  import com.adobe.serialization.json.JSONDecoder;
  import com.adobe.serialization.json.JSONParseError;

  public class ConfigurationParser
  {
    public static const DEFAULT_SKIN_URL : String = "goplayer-skin.swf"
    public static const DEFAULT_STREAMIO_CHANNEL : String = "streamio"

    public static const VALID_PARAMETERS : Array
      = ["skin",
         "src",
         "bitrate",
         "enablertmp",
         "autoplay",
         "loop",
         "externalloggingfunction",
         "revision",

         "skinshowchrome",
         "skinshowlargeplaybutton",
         "skinshowtitle",
         "skinshowsharebutton",
         "skinshowembedbutton",
         "skinshowplaypausebutton",
         "skinshowelapsedtime",
         "skinshowseekbar",
         "skinshowtotaltime",
         "skinshowvolumecontrol",
         "skinshowfullscreenbutton",

         "startmute",

         "streamioapi",
         "stok",
         "channel",
         "playerid",
		 
         "plugin"]

    private const result : Configuration = new Configuration

    private var parameters : Object
    private var originalParameterNames : Object

    public function ConfigurationParser(parameters : Object, originalParameterNames : Object)
    {
      this.parameters = parameters
      this.originalParameterNames = originalParameterNames
    }

    public function execute() : void
    {
      result.revision = getString("revision")
      result.skinURL = getString("skin", DEFAULT_SKIN_URL) + (result.revision.length > 0 ? "?" + result.revision : "")
      result.movieID = getStreamioVideoID()
      result.playerID = getString("playerid")
      result.bitratePolicy = getBitratePolicy("bitrate", BitratePolicy.BEST)
      result.enableRTMP = getBoolean("enablertmp", false)
      result.enableAutoplay = getBoolean("autoplay", false)
      result.enableLooping = getBoolean("loop", false)
      result.externalLoggingFunctionName = getString("externalloggingfunction")

      result.enableChrome = getBoolean("skinshowchrome", true)
      result.enableLargePlayButton = getBoolean("skinshowlargeplaybutton", true)
      result.enableTitle = getBoolean("skinshowtitle", false)
      result.enableShareButton = getBoolean("skinshowsharebutton", false)
      result.enableEmbedButton = getBoolean("skinshowembedbutton", false)
      result.enablePlayPauseButton = getBoolean("skinshowplaypausebutton", true)
      result.enableElapsedTime = getBoolean("skinshowelapsedtime", true)
      result.enableSeekBar = getBoolean("skinshowseekbar", true)
      result.enableTotalTime = getBoolean("skinshowtotaltime", true)
      result.enableVolumeControl = getBoolean("skinshowvolumecontrol", true)
      result.enableFullscreenButton = getBoolean("skinshowfullscreenbutton", true)
	  
      result.startMute = getBoolean("startmute", false)

      result.apiURL = getString("streamioapi", Configuration.protocol+"streamio.com/api")
      result.stok = getString("stok")
      result.channel = getString("channel", DEFAULT_STREAMIO_CHANNEL)

      result.pluginConfig = getObject("plugin", { } )

      if (result.pluginConfig.src)
        result.pluginURL = result.pluginConfig.src
    }

    private function getStreamioVideoID() : String
    {
      if ("src" in parameters)
        return $getStreamioVideoID()
      else
        {
          debug("Error: Missing “src” parameter.")

          return null
        }
    }

    private function $getStreamioVideoID() : String
    {
      const src : String = parameters["src"]
      const match : Array = src.match(/^streamio:video:(.*)$/)

      if (match != null)
        return match[1]
      else
        {
          debug("Error: Unrecognized “src” value: “" + src + "”; " +
                "must be “streamio:video:foo”.")

          return null
        }
    }

    public static function parse(parameters : Object) : Configuration
    {
      const normalizedParameters : Object = {}
      const originalParameterNames : Object = {}

      for (var name : String in parameters)
        if (VALID_PARAMETERS.indexOf(normalize(name)) == -1)
          reportUnknownParameter(name)
        else
          normalizedParameters[normalize(name)] = parameters[name],
            originalParameterNames[normalize(name)] = name

      const parser : ConfigurationParser = new ConfigurationParser
        (normalizedParameters, originalParameterNames)

      parser.execute()

      return parser.result
    }

    private static function normalize(name : String) : String
    { return name.toLowerCase().replace(/[^a-z0-9]/g, "") }

    private static function reportUnknownParameter(name : String) : void
    { debug("Error: Unknown parameter: " + name) }

    // -----------------------------------------------------

    private function getString(name : String, fallback : String = "") : String
    { return name in parameters ? parameters[name] : fallback }

    private function getBoolean
      (name : String, fallback : Boolean) : Boolean
    {
      if (name in parameters)
        return $getBoolean(name, parameters[name], fallback)
      else
        return fallback
    }

    private function getObject(name : String, fallback : Object) : Object
    {
      var output:Object = fallback

      if (name in parameters)
      {
        var jsonDecoder:JSONDecoder

        try
          { jsonDecoder = new JSONDecoder(parameters[name], false) }
        catch (error : JSONParseError)
          { reportInvalidParameter(name, parameters[name], ["valid JSON"]) }

        if(jsonDecoder)
          output = jsonDecoder.getValue()
      }

      return output
    }

    private function $getBoolean
      (name : String, value : String, fallback : Boolean) : Boolean
    {
      try
        { return $$getBoolean(value) }
      catch (error : Error)
        {
          reportInvalidParameter(name, value, ["true", "false"])

          return fallback
        }

      throw new Error
    }

    private function $$getBoolean(value : String) : Boolean
    {
      if (value == "true")
        return true
      else if (value == "false")
        return false
      else
        throw new Error
    }

    // -----------------------------------------------------

    private function getBitratePolicy(name : String, fallback : BitratePolicy) : BitratePolicy
    {
      if (name in parameters)
        return $getBitratePolicy(name, parameters[name], fallback)
      else
        return fallback
    }

    private function $getBitratePolicy(name : String, value : String, fallback : BitratePolicy) : BitratePolicy
    {
      try
        { return $$getBitratePolicy(value) }
      catch (error : Error)
        {
          reportInvalidParameter(name, value, BITRATE_POLICY_VALUES)

          return fallback
        }

      throw new Error
    }

    private const BITRATE_POLICY_VALUES : Array =
      ["<number>kbps", "min", "max", "best"]

    private function $$getBitratePolicy(value : String) : BitratePolicy
    {
      if (value == "max")
        return BitratePolicy.MAX
      else if (value == "min")
        return BitratePolicy.MIN
      else if (value == "best")
        return BitratePolicy.BEST
      else if (Bitrate.parse(value))
        return BitratePolicy.specific(Bitrate.parse(value))
      else
        throw new Error
    }

    // -----------------------------------------------------

    private function reportInvalidParameter
      (name : String, value : String, validValues : Array) : void
    {
      debug("Error: Invalid parameter: " +
            "“" + originalParameterNames[name] + "=" + value + "”; " +
            getInvalidParameterHint(validValues) + ".")
    }

    private function getInvalidParameterHint(values : Array) : String
    { return $getInvalidParameterHint(getQuotedValues(values)) }

    private function $getInvalidParameterHint(values : Array) : String
    {
      return "please use " +
        "either " + values.slice(0, -1).join(", ") + " " +
        "or " + values[values.length - 1]
    }

    private function getQuotedValues(values : Array) : Array
    {
      var result : Array = []

      for each (var value : String in values)
        result.push("“" + value + "”")

      return result
    }
  }
}
