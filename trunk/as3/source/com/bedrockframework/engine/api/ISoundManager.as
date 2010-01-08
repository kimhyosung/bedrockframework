package com.bedrockframework.engine.api
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
		
	public interface ISoundManager
	{
		function initialize($sounds:Array = null):void;
		/*
		Sound Functions
		*/
		function addSound($alias:String, $sound:Sound, $allowMultiple:Boolean = true):void;
		function loadSound($alias:String, $url:String, $completeHandler:Function):void
		
		function playSound($alias:String, $startTime:Number = 0, $delay:Number = 0, $loops:int = 0, $volume:Number = 1, $panning:Number = 0):SoundChannel;
		function stopSound($alias:String):void;
		function closeSound($alias:String):void;
		
		function setSoundVolume($alias:String, $value:Number):void;
		function getSoundVolume($alias:String):Number;
		function setSoundPanning($alias:String, $value:Number):void;
		function getSoundPanning($alias:String):Number;
		
		function fadeSound($alias:String, $time:Number, $value:Number, $completeHandler:Function = null ):void;
		/*
		Global Sound Functions
		*/
		function muteGlobal():void;
		function unmuteGlobal():void;
		function toggleGlobalMute():Boolean;
		/*
		Property Definitions
	 	*/
	 	function setGlobalPanning($value:Number):void;
		function getGlobalPanning():Number;
		
		function setGlobalVolume($value:Number):void;
		function getGlobalVolume():Number;
	}
}