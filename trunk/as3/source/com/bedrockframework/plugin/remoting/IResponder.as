package com.bedrockframework.plugin.remoting
{
	public interface IResponder
	{
		function result($data:Object):void;
		function fault($data:Object):void;
	}
}