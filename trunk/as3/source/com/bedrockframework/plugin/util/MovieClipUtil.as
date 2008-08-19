package 
{
	import com.bedrockframework.core.base.StaticWidget;
	
	import flash.display.MovieClip;
	public class MovieClipUtil extends StaticWidget
	{
		/*
		Returns the frame number of a specific frame label.
		*/
		public static function getFrame($clip:MovieClip, $label:String):int
		{
			var arrLabels:Array = $clip.currentLabels
			for(var i:Number = 0; i < arrLabels.length; i++){
				if($label == arrLabels[i].name){
					return (arrLabels[i].frame);
				}
			}
			return ($clip.currentFrame);
		}           
		/*
		 * Returns the suggested tweening time based on the current frame and the frame number specified.
		 * $clip - MovieClip targeted.
		 * $frame - Frame or frame label targeted.
		 * $compression - Optional parameter that allows you to modify the time returned (speed up the timing).
		*/
		public static function getTweenTime($clip:MovieClip, $frame:*, $compression:Number=1):Number
		{
			var numFrame:Number;
			switch(typeof($frame)){
				case "number":
					numFrame = $frame;
				case "string":
					numFrame = MovieClipUtil.getFrame($clip, $frame);
				default:
					throw new Error("Frame parameter must be a label or a string!");
			}
			return (Math.abs(numFrame - $clip.currentFrame)) / $clip.stage.frameRate;
		}
	}
}