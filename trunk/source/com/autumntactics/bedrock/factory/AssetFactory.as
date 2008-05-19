package com.autumntactics.bedrock.factory
{
	/*
	Imports
	*/
	import com.autumntactics.storage.HashMap;
	import com.autumntactics.bedrock.base.StandardWidget;
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
			AssetFactory.OBJ_VIEW_MAP = new HashMap();
			AssetFactory.OBJ_PRELOADER_MAP = new HashMap();
			AssetFactory.OBJ_BITMAP_MAP = new HashMap();
			AssetFactory.OBJ_SOUND_MAP = new HashMap();
		}
		/*
		Add/ Return new view instance
		*/
		public static function addView($name:String, $class:Class)
		{
			AssetFactory.OBJ_VIEW_MAP.saveValue($name, $class);
		}
		public static function getView($name:String):*
		{
			var clsResult:Class = AssetFactory.OBJ_VIEW_MAP.getValue($name);
			return new clsResult;
		}
		/*
		Add/ Return new preloader instance
		*/
		public static function addPreloader($name:String, $class:Class)
		{
			AssetFactory.OBJ_PRELOADER_MAP.saveValue($name, $class);
		}
		public static function getPreloader($name:String):*
		{
			var clsResult:Class = AssetFactory.OBJ_PRELOADER_MAP.getValue($name);
			return new clsResult;
		}
		/*
		Add/ Return new bitmap instance
		*/
		public static function addBitmap($name:String, $class:Class)
		{
			AssetFactory.OBJ_BITMAP_MAP.saveValue($name, $class);
		}
		public static function getBitmap($name:String):*
		{
			var clsResult:Class = AssetFactory.OBJ_BITMAP_MAP.getValue($name);
			return new clsResult(0,0);
		}
		/*
		Add/ Return new sound instance
		*/
		public static function addSound($name:String, $class:Class)
		{
			AssetFactory.OBJ_SOUND_MAP.saveValue($name, $class);
		}
		public static function getSound($name:String):*
		{
			var clsResult:Class = AssetFactory.OBJ_SOUND_MAP.getValue($name);
			return new clsResult;
		}
	}

}