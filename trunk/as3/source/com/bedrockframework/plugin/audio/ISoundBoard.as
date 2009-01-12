package com.bedrockframework.plugin.audio
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public interface ISoundBoard
	{
		function add($alias:String, $sound:Sound, $allowMultiple:Boolean = true):void;
		function load($alias:String, $url:String, $completeHandler:Function):void
		
		function play($alias:String, $startTime:Number = 0, $delay:Number = 0, $loops:int = 0, $volume:Number = 1, $panning:Number = 0):SoundChannel;
		function stop($alias:String):void;
		function close($alias:String):void;
		
		function setVolume($alias:String, $value:Number):void;
		function getVolume($alias:String):Number;
		function setPanning($alias:String, $value:Number):void;
		function getPanning($alias:String):Number;
	}
}