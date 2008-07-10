package com.bedrockframework.engine.view
{
	

	public interface IPreloader extends IView
	{
		function displayProgress($percent:uint):void;
		function remove():void;
	}
}