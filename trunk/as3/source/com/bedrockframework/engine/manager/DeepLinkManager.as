
package com.bedrockframework.engine.manager
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.model.Queue;
	import com.bedrockframework.plugin.util.VariableUtil;
	
	public class DeepLinkManager extends StaticWidget
	{
		/*
		Variable Decarations
		*/
		public static  var AUTO:String = "auto";
		public static  var MANUAL:String = "manual";
		
		Logger.log(DeepLinkManager, LogLevel.CONSTRUCTOR, "Constructed");
		/*
		Constructor
		*/

		public static function initialize():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.DO_DEFAULT, DeepLinkManager.onDoSetup, false, 1);
			DeepLinkManager.enableChangeHandler();
		}
		/*
		Set Mode
		*/
		public static function setMode($mode:String):void
		{
			switch ($mode.toLowerCase()) {
				case DeepLinkManager.AUTO :
					BedrockDispatcher.addEventListener(BedrockEvent.INITIALIZE_COMPLETE, DeepLinkManager.onInitializeComplete);
					BedrockDispatcher.addEventListener(BedrockEvent.SET_QUEUE, DeepLinkManager.onPauseChangeHandler);
					break;
				case DeepLinkManager.MANUAL :
					BedrockDispatcher.removeEventListener(BedrockEvent.INITIALIZE_COMPLETE, DeepLinkManager.onInitializeComplete);
					BedrockDispatcher.removeEventListener(BedrockEvent.SET_QUEUE, DeepLinkManager.onPauseChangeHandler);
					break;
				default :
					Logger.error(DeepLinkManager, "Invalid mode!");
					break;
			}
		}
		/*
		Enable/ Disable Change Event
		*/
		private static function enableChangeHandler()
		{
			Logger.status(DeepLinkManager, "Change handler enabled!")
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, DeepLinkManager.onChangeNotification);
		}
		private static function disableChangeHandler()
		{
			Logger.status(DeepLinkManager, "Change handler disabled!")
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, DeepLinkManager.onChangeNotification);
		}
		/*
		
		
		Wrapper functions
		
		
		*/
		public static function getTitle():String
		{
			return SWFAddress.getTitle();
		}
		public static function setTitle($title:String):void
		{
			SWFAddress.setTitle($title);
		}
		/*
		
		Status bar functions 
		
		*/
		public static function getStatus():String
		{
			return SWFAddress.getStatus();
		}
		public static function setStatus($status:String):void
		{
			SWFAddress.setStatus($status);
		}
		public static function resetStatus():void
		{
			SWFAddress.resetStatus();
		}
		/*
		
		Path functions
		
		*/
		public static function getPath():String
		{
			return SWFAddress.getPath();
		}
		public static function setPath($path:String):void
		{
			SWFAddress.setValue("/" + $path);
		}
		public static function clearPath():void
		{
			SWFAddress.setValue("")
		}
		public static function getCleanPath():String
		{
			var strPath:String = DeepLinkManager.getPath();
			var numStartIndex:int  = (strPath.charAt(0) == "/") ? 1 : 0;
			var numLastIndex:int = (strPath.charAt(strPath.length -1) == "/") ? strPath.length -1 : strPath.length
			var strTempPath:String = strPath.substring(numStartIndex, numLastIndex)
			var strCleanPath:String = (strTempPath == "/") ? null : strTempPath ;
			return strCleanPath;
		}
		/*
		
		Query string functions
		
		*/
		public static function setQueryString($query:String):void
		{
			var strAddress:String=DeepLinkManager.getAddress();
			if (strAddress.indexOf("?") != -1) {
				var strBeginning:String=strAddress.substr(0,strAddress.indexOf('?'));
				DeepLinkManager.setAddress(strBeginning + $query);
			} else {
				DeepLinkManager.setAddress(strAddress + "?" + $query);
			}
		}
		public static function getQueryString():String
		{
			return SWFAddress.getQueryString();
		}
		public static function clearQueryString():void
		{
			var strAddress:String=DeepLinkManager.getAddress();
			var arrDivision:Array=strAddress.split("?");
			DeepLinkManager.setAddress(arrDivision[0]);
		}
		/*
		
		Single Parameter functions
		
		*/
		public static function getParameter($parameter:String):String
		{
			return SWFAddress.getParameter($parameter);
		}
		public static function populateParameters($query:Object):void
		{
			DeepLinkManager.clearQueryString();
			for (var q in $query) {
				DeepLinkManager.addParameter(q,$query[q]);
			}
		}
		public static function addParameter($parameter:String,$value:String):void
		{
			var strAddress:String=DeepLinkManager.getAddress();
			if (strAddress.indexOf("?") != -1) {
				strAddress+= "&" + $parameter + "=" + $value;
			} else {
				strAddress+= "?" + $parameter + "=" + $value;
			}
			DeepLinkManager.setAddress(strAddress);
		}
		public static function setParameter($parameter:String,$value:String):void
		{
			var objQuery:Object=DeepLinkManager.getParameterObject();
			if (objQuery[$parameter] != undefined) {
				objQuery[$parameter]=$value;
				DeepLinkManager.populateParameters(objQuery);
			} else {
				DeepLinkManager.addParameter($parameter,$value);
			}
		}
		public static function getParameterObject():Object
		{
			var strQuery:String=DeepLinkManager.getQueryString();
			var objQuery:Object=new Object;
			var arrValuePairs:Array=strQuery.split("&");
			var tmpPreviousResult:*;
			for (var i in arrValuePairs) {
				var arrPair:Array=arrValuePairs[i].split("=");


				var tmpValueName:String = arrPair[0];
				var tmpValueClean:* = VariableUtil.sanitize(arrPair[1]);

				// Look for an existing value by that name

				if (objQuery[tmpValueName] != null) {

					//If found and is Array push value else, create array and push value

					if (objQuery[tmpValueName] is Array) {
						objQuery[tmpValueName].push(tmpValueClean);
					} else {
						//create new array
						tmpPreviousResult = objQuery[tmpValueName];
						objQuery[tmpValueName] = new Array();
						objQuery[tmpValueName].push(tmpPreviousResult);
						objQuery[tmpValueName].push(tmpValueClean);
					}
				} else {
					objQuery[tmpValueName]=tmpValueClean;
				}
			}
			return objQuery;
		}
		/*
		Returns all the names of the query string parameters
		*/
		public static function getParameterNames():Array
		{
			return SWFAddress.getParameterNames();
		}
		/*
		Clears a single parameter
		*/
		public static function clearParameter($parameter:String):void
		{
			var objQuery:Object=DeepLinkManager.getParameterObject();
			delete objQuery[$parameter];
			DeepLinkManager.populateParameters(objQuery);
		}
		/*
		Event Handlers
		*/
		public static function onDoSetup($event:BedrockEvent):void
		{
			BedrockDispatcher.removeEventListener(BedrockEvent.DO_DEFAULT, DeepLinkManager.onDoSetup);
			DeepLinkManager.setMode(DeepLinkManager.AUTO);
		}	
		private static function onChangeNotification($event:SWFAddressEvent)
		{
			var objDetails:Object = new Object();
			objDetails.query = DeepLinkManager.getParameterObject();
			objDetails.path = DeepLinkManager.getCleanPath();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.URL_CHANGE,DeepLinkManager, objDetails));
		}		
		private static function onInitializeComplete($event:BedrockEvent)
		{
			DeepLinkManager.clearPath();
			DeepLinkManager.setPath(Queue.current.alias);
			SWFAddress.setStatus("Ready");
			DeepLinkManager.enableChangeHandler();		
		}
		private static function onPauseChangeHandler($event:BedrockEvent)
		{
			DeepLinkManager.disableChangeHandler();
		}
		/*
		
		Address functions 
		
		*/
		/*
		Returns everything currently in the address bar
		*/
		public static function getAddress():String
		{
			return SWFAddress.getValue();
		}
		public static function setAddress($value:String):void
		{
			SWFAddress.setValue($value);
		}
		public static function clearAddress($value:String):void
		{
			DeepLinkManager.setAddress("");
		}
	}
}