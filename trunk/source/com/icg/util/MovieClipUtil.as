package com.icg.util
{
	import com.icg.madagascar.base.StaticWidget;
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