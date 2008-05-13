package com.icg.util
{
	import com.icg.madagascar.base.StaticWidget;
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	public class Aligner extends StaticWidget
	{


		public static  const LEFT:String="left";
		public static  const RIGHT:String="right";
		public static  const CENTER:String="center";
		public static  const BOTTOM:String="bottom";
		public static  const TOP:String="top";

		public static function alignHorizontal($target:DisplayObject,$alignment:String, $base:Number = 0, $offset:Number =0):void
		{
			var objTarget:DisplayObject=$target;
			var numSize:Number=objTarget.width;			
			var numBase:Number = $base
			var numOffset:Number = $offset;
			
			var numPosition:Number;
			switch ($alignment.toLowerCase()) {
				case Aligner.LEFT :
					numPosition=0+numOffset;
					break;
				case Aligner.CENTER :
					numPosition=((numBase/2)-(numSize/2))+numOffset;
					break;
				case Aligner.RIGHT :
					numPosition=(numBase-numSize)+numOffset;
					break;

			}
			objTarget.x=numPosition;
		}
		public static function alignVertical($target:DisplayObject,$alignment:String, $base:Number = 0, $offset:Number =0):void
		{
			var objTarget:DisplayObject=$target;
			var numSize:Number=objTarget.height;
			var numBase:Number = $base;
			var numOffset:Number = $offset;
			
			var numPosition:Number;
			switch ($alignment.toLowerCase()) {
				case Aligner.TOP :
						numPosition=0+numOffset;
					break;
				case Aligner.CENTER :
					numPosition=((numBase/2)-(numSize/2))+numOffset;
					break;
				case Aligner.BOTTOM :
					numPosition=(numBase-numSize)+numOffset;
					break;
			}
			objTarget.y=numPosition;
		}
	}
}