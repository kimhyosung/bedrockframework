package com.autumntactics.bedrock.view
{
	

	public interface IPreloader
	{
		function initialize($properties:Object = null):void;
		function intro($properties:Object = null):void;
		function outro($properties:Object = null):void;
		//
		function displayProgress($percent:uint):void;
		function remove():void;
	}
}