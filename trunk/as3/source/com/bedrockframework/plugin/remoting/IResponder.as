package com.bedrockframework.engine.remoting
{
	public interface IResponder
	{
		function result($data:Object):void;
		function fault($data:Object):void;
	}
}