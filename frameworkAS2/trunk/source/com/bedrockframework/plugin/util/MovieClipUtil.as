class com.bedrockframework.plugin.util.MovieClipUtil extends com.bedrockframework.core.base.StaticWidget
{
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "MovieClipUtil";
	/*
	Get the frame number of a label
	*/
	public static function getFrame($clip:MovieClip, $label:String):Number
	{
		var mcTarget:MovieClip = $clip.duplicateMovieClip("mcTemp", $clip._parent.getNextHighestDepth());
		mcTarget.gotoAndStop($label);
		var numFrame:Number = mcTarget._currentframe;
		removeMovieClip(mcTarget);
		return numFrame;
	}
	/*
	Removes any MovieClip on stage regardless if it was attached or not
	*/
	public static function remove($clip:MovieClip):Void
	{
		if ($clip != undefined) {
			var numLevel:Number = $clip._parent.getNextHighestDepth();
			$clip.swapDepths(numLevel);
			$clip.removeMovieClip();
		}
	}
}
