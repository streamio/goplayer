package goplayer
{
  import flash.system.System
  
  public class ShareEmbed
  {
    private var movie : IMovie
    private var dimensions : Dimensions

    public function ShareEmbed(movie : IMovie, dimensions : Dimensions)
    { this.movie = movie, this.dimensions = dimensions }
    
    public function openTwitter() : void
    { openURL(twitterURL) }

    public function openFacebook() : void
    { openURL(facebookURL) }
    
    public function openLinkedin() : void
    { openURL(linkedinURL) }

    private function openURL(url : String) : void
    { callJavascript("window.open", url, "share") }

    private function get twitterURL() : String
    {
      return "https://twitter.com/share?"
        + "url=" + encodeURIComponent(shareURL) + "&"
        + "text=" + encodeURIComponent(twitterText)
    }

    private function get twitterText() : String
    { return "Check out this video: " + movie.title }

    private function get facebookURL() : String
    { return "https://www.facebook.com/sharer.php?u=" + encodeURIComponent(shareURL) }

    private function get linkedinURL() : String
    { return "http://www.linkedin.com/shareArticle?mini=true&url=" + encodeURIComponent(shareURL) }

    public function get shareURL() : String
    { return movie.shareURL.toString() }

    public function copyShareURL() : void
    { copy(shareURL) }

    public function copyEmbedCode() : void
    { copy(embedCode) }

    private function copy(text : String) : void
    { System.setClipboard(text) }

    public function get embedCode() : String
    {
      const attributes : Array =
        ['width="' + dimensions.width + '"',
         'height="' + dimensions.height + '"',
         'src="' + shareURL + '"']
        
      return "<iframe " + attributes.join(" ") + "></iframe>"
    }
  }
}
