package com.bedrockframework.plugin.util
{
	import com.bedrockframework.core.base.StaticWidget;
	
	import flash.display.MovieClip;
	public class MovieClipUtil extends StaticWidget
	{
		/**
		 * $clip MovieClip targeted.
		 * $label Frame label requested.
		 * return Returns the frame number of a specific frame label.
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
		/**
		 * $clip MovieClip targeted.
		 * $frame Frame or frame label targeted.
		 * $compression Optional parameter that allows you to modify the time returned (speed up the timing).
		 * return Returns the suggested tweening time based on the current frame and the frame number specified.
		*/
		public static function getTweenTime($clip:MovieClip, $frame:*, $compression:Number=1):Number
		{
			if ($clip == null) {
				throw new Error("MovieClip reference is null!");
			}
			var numFrame:Number;
			switch(typeof($frame)){
				case "number":
					numFrame = $frame;
					break;
				case "string":
					numFrame = MovieClipUtil.getFrame($clip, $frame);
					break;
				default:
					throw new Error("Frame parameter must be a label or a string!");
					break;
			}
			return (Math.abs(numFrame - $clip.currentFrame)) / $clip.stage.frameRate;
		
			
		}
	}
}