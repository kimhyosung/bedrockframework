package com.bedrockframework.engine.view
{
	
	public interface IView
	{
		function initialize($properties:Object=null):void;
		function intro($properties:Object=null):void;
		function outro($properties:Object=null):void;
		//
		function clear():void;
	}
}