package com.autumntactics.bedrock.output
{
	public interface IOutputter
	{
		function output($trace:*, $category:String = "status"):void;
	}
}