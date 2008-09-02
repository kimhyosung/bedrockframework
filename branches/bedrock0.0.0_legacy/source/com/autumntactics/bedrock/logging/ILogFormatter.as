package com.builtonbedrock.bedrock.logging
{
	public interface ILogFormatter
	{
		function format($target:*, $category:int, $arguments:Array):String;
	}
}