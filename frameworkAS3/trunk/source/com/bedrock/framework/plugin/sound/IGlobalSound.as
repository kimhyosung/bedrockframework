package com.bedrock.framework.plugin.sound
{
	public interface IGlobalSound
	{
		function mute():void;
		function unmute():void;
		function toggleMute():Boolean;
		function get isMuted():Boolean;
	}
}