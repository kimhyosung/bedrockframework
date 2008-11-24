package com.bedrockframework.engine.api
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	public interface IAssetManager
	{
		/*
		Add/ Return new preloader instance
		*/
		function addPreloader($alias:String, $class:Class):void;
		function getPreloader($alias:String):MovieClip;
		function hasPreloader($alias:String):Boolean;
		/*
		Add/ Return new view instance
		*/
		function addView($alias:String, $class:Class):void;
		function getView($alias:String):MovieClip;
		function hasView($alias:String):Boolean;
		function getViews():Array;
		/*
		Add/ Return new bitmap instance
		*/
		function addBitmap($alias:String, $class:Class):void;
		function getBitmap($alias:String):BitmapData;
		function hasBitmap($alias:String):Boolean;
		function getBitmaps():Array;
		/*
		Add/ Return new sound instance
		*/
		function addSound($alias:String, $class:Class):void;
		function getSound($alias:String):Sound;
		function hasSound($alias:String):Boolean;
		function getSounds():Array;
	}
}