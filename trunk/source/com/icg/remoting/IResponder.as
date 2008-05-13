package com.icg.remoting
{
	public interface IResponder
	{
		function result($data:Object):void;
		function fault($data:Object):void;
	}
}