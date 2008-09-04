package com.autumntactics.bedrock.controller
{
	public interface IController
	{
		function initialize():void;
		function addCommand($type:String,$command:Class):void;
		function removeCommand($type:String,$command:Class):void;
	}
}