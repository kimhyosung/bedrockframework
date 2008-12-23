package com.bedrockframework.engine.api
{
	public interface IPageManager
	{
		function initialize($autoDefault:Boolean = true):void
		function setupPageLoad($page:Object):void
		function getDefaultPage($details:Object = null):String
		/*
		Set Queue
		*/
		function setQueue($page:Object):Boolean
		/*
		Load Queue
		*/
		function getQueue():Object
		/*
		Clear Queue
		*/
		function clearQueue():void
		/*
		Get Current Queue
		*/
		function get current():Object
		/*
		Get Previous Queue
		*/
		function get previous():Object
	}
}