package com.bedrockframework.core.logging
{
	public interface ILogFormatter
	{
		function format($target:*, $category:int, $arguments:Array):String;
	}
}