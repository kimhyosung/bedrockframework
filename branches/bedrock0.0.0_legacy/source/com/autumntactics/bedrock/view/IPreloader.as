﻿package com.autumntactics.bedrock.view
{
	

	public interface IPreloader extends IView
	{
		function displayProgress($percent:uint):void;
		function remove():void;
	}
}