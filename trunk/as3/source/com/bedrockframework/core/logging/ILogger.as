package com.bedrockframework.core.logging
{
	public interface ILogger
	{
		function log($target:*, $category:int, $message:String):void;
	}
}