package com.bedrockframework.engine.api
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	public interface IAssetManager
	{
		/*
		Add/ Return new view instance
		*/
		function addView($name:String, $class:Class):void;
		function getView($name:String):MovieClip;
		function hasView($name:String):Boolean;
		/*
		Add/ Return new preloader instance
		*/
		function addPreloader($name:String, $class:Class):void;
		function getPreloader($name:String):MovieClip;
		function hasPreloader($name:String):Boolean;
		/*
		Add/ Return new bitmap instance
		*/
		function addBitmap($name:String, $class:Class):void;
		function getBitmap($name:String):BitmapData;
		function hasBitmap($name:String):Boolean;
		/*
		Add/ Return new sound instance
		*/
		function addSound($name:String, $class:Class):void;
		function getSound($name:String):Sound;
		function hasSound($name:String):Boolean;
	}
}