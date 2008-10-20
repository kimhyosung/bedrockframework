package com.bedrockframework.engine.api
{
	public interface IDeepLinkManager
	{
		function initialize():void
		function clear():void
		/*
		Set Mode
		*/
		function setMode($mode:String):void
	}
}