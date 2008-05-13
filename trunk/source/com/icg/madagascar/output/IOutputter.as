package com.icg.madagascar.output
{
	public interface IOutputter
	{
		function output($trace:*, $category:String = "status"):void;
	}
}