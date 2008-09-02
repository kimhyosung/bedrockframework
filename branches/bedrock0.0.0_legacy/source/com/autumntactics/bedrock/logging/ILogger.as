package com.builtonbedrock.bedrock.logging
{
	public interface ILogger
	{
		function log($target:*, $category:int, $message:String):void;
	}
}