package com.bedrockframework.plugin.util
{
	import com.bedrockframework.core.base.StaticWidget;
	import flash.display.MovieClip;

	public class MovieClipUtil extends StaticWidget
	{
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
		

	}
}