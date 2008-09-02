package com.builtonbedrock.audio
{
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	public interface ISoundBoard
	{
		function add($name:String, $sound:Sound):void;
		function load($name:String, $url:String, $completeHandler:Function):void
		
		function play($name:String, $startTime:Number = 0, $loops:int = 0, $transform:SoundTransform = null):SoundChannel;
		function stop($name:String):void;
		function close($name:String):void;
		
		function setVolume($name:String, $value:Number):void;
		function setPan($name:String, $value:Number):void;
	}
}