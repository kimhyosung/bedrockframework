package com.bedrockframework.engine.api
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	
	public interface IAssetManager
	{
		function initialize( $applicationDomain:ApplicationDomain ):void;
		/*
		Add/ Return new preloader instance
		*/
		function addPreloader($name:String):void;
		function getPreloader($name:String):MovieClip;
		function hasPreloader($name:String):Boolean;
		/*
		Add/ Return new view instance
		*/
		function addView($name:String):void;
		function getView($name:String):*;
		function hasView($name:String):Boolean;
		function getViews():Array;
		/*
		Add/ Return new bitmap instance
		*/
		function addBitmap($name:String):void;
		function getBitmap($name:String):BitmapData;
		function hasBitmap($name:String):Boolean;
		function getBitmaps():Array;
		/*
		Add/ Return new sound instance
		*/
		function addSound($name:String):void;
		function getSound($name:String):Sound;
		function hasSound($name:String):Boolean;
		function getSounds():Array;
	}
}