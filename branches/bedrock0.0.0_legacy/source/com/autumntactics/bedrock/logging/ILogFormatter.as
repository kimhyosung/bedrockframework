package com.autumntactics.bedrock.logging
{
	public interface ILogFormatter
	{
		function format($target:*, $category:int, $arguments:Array):String;
	}
}