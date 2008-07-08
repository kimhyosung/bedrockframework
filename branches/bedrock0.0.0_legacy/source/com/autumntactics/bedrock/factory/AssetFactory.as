package com.autumntactics.bedrock.factory
{
	/*
	Imports
	*/
	import com.autumntactics.bedrock.base.StandardWidget;
	import com.autumntactics.storage.HashMap;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	/*
	Class Declaration
	*/
	public class AssetFactory extends StandardWidget
	{
		/*
		Variable Declarations
		*/
		private static  var OBJ_VIEW_MAP:HashMap;
		private static  var OBJ_PRELOADER_MAP:HashMap;
		private static  var OBJ_BITMAP_MAP:HashMap;
		private static  var OBJ_SOUND_MAP:HashMap;
		/*
		Initialize the class
		*/
		public static function initialize():void
		{
			OBJ_VIEW_MAP = new HashMap;
			OBJ_PRELOADER_MAP = new HashMap;
			OBJ_BITMAP_MAP = new HashMap;
			OBJ_SOUND_MAP = new HashMap;
		}
		/*
		Add/ Return new view instance
		*/
		public static function addView($name:String, $class:Class):void
		{
			OBJ_VIEW_MAP.saveValue($name, $class);
		}
		public static function getView($name:String):MovieClip
		{
			var clsResult:Class = OBJ_VIEW_MAP.getValue($name);
			return new clsResult;
		}
		public static function hasView($name:String):Boolean
		{
			return OBJ_VIEW_MAP.containsKey($name);
		}
		/*
		Add/ Return new preloader instance
		*/
		public static function addPreloader($name:String, $class:Class):void
		{
			OBJ_PRELOADER_MAP.saveValue($name, $class);
		}
		public static function getPreloader($name:String):MovieClip
		{
			var clsResult:Class = OBJ_PRELOADER_MAP.getValue($name);
			return new clsResult;
		}
		public static function hasPreloader($name:String):Boolean
		{
			return OBJ_PRELOADER_MAP.containsKey($name);
		}
		/*
		Add/ Return new bitmap instance
		*/
		public static function addBitmap($name:String, $class:Class):void
		{
			OBJ_BITMAP_MAP.saveValue($name, $class);
		}
		public static function getBitmap($name:String):BitmapData
		{
			var clsResult:Class = OBJ_BITMAP_MAP.getValue($name);
			return new clsResult(0,0);
		}
		public static function hasBitmap($name:String):Boolean
		{
			return OBJ_BITMAP_MAP.containsKey($name);
		}
		/*
		Add/ Return new sound instance
		*/
		public static function addSound($name:String, $class:Class):void
		{
			OBJ_SOUND_MAP.saveValue($name, $class);
		}
		public static function getSound($name:String):Sound
		{
			var clsResult:Class = OBJ_SOUND_MAP.getValue($name);
			return new clsResult;
		}
		public static function hasSound($name:String):Boolean
		{
			return OBJ_SOUND_MAP.containsKey($name);
		}
	}

}