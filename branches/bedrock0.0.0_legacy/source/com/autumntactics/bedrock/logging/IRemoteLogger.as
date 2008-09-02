package com.builtonbedrock.bedrock.logging
{
	public interface IRemoteLogger extends ILogger
	{
		function set loggerURL($url:String):void;
		function get loggerURL():String;
	}
}