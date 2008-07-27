package com.bedrockframework.plugin.remoting
{
	public interface IResponder
	{
		function result($data:Object = null):void;
		function fault($data:Object  = null):void;
	}
}