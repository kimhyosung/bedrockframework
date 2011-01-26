package com.bedrock.framework.engine.api
{
	public interface IDeeplinkingManager
	{
		function initialize():void;
		function enableChangeHandler():void;
		function disableChangeHandler():void;
		function getAddress():String;
		function setAddress($value:String):void;
		function clearAddress():void;
		function getTitle():String;
		function setTitle($title:String):void;
		function getStatus():String;
		function setStatus($status:String):void;
		function resetStatus():void;
		function getPath():String;
		function setPath($path:String):void;
		function clearPath():void;
		function getPathNames():Array;
		function setQueryString($query:String):void;
		function getQueryString():String;
		function clearQueryString():void;
		function getParameter($parameter:String):*;
		function populateParameters($query:Object):void;
		function addParameter($parameter:String,$value:String):void;
		function setParameter($parameter:String,$value:String):void;
		function getParametersAsObject():Object;
		function getParameterNames():Array;
		function clearParameter($parameter:String):void;

	}
}