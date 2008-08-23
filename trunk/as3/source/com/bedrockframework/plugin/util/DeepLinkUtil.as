package com.bedrockframework.plugin.util
{
	import com.asual.swfaddress.SWFAddress;
	import com.bedrockframework.core.base.StaticWidget;

	public class DeepLinkUtil extends StaticWidget
	{
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
			DeepLinkUtil.setAddress("");
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
			SWFAddress.setValue("");
		}
		public static function getPathNames():Array
		{
			return SWFAddress.getPathNames();
		}
		/*
		
		Query string functions
		
		*/
		public static function setQueryString($query:String):void
		{
			var strAddress:String=DeepLinkUtil.getAddress();
			if (strAddress.indexOf("?") != -1) {
				var strBeginning:String=strAddress.substr(0,strAddress.indexOf('?'));
				DeepLinkUtil.setAddress(strBeginning + $query);
			} else {
				DeepLinkUtil.setAddress(strAddress + "?" + $query);
			}
		}
		public static function getQueryString():String
		{
			return SWFAddress.getQueryString();
		}
		public static function clearQueryString():void
		{
			var strAddress:String=DeepLinkUtil.getAddress();
			var arrDivision:Array=strAddress.split("?");
			DeepLinkUtil.setAddress(arrDivision[0]);
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
			DeepLinkUtil.clearQueryString();
			for (var q:String in $query) {
				DeepLinkUtil.addParameter(q,$query[q]);
			}
		}
		public static function addParameter($parameter:String,$value:String):void
		{
			var strAddress:String=DeepLinkUtil.getAddress();
			if (strAddress.indexOf("?") != -1) {
				strAddress+= "&" + $parameter + "=" + $value;
			} else {
				strAddress+= "?" + $parameter + "=" + $value;
			}
			DeepLinkUtil.setAddress(strAddress);
		}
		public static function setParameter($parameter:String,$value:String):void
		{
			var objQuery:Object=DeepLinkUtil.getParameterObject();
			if (objQuery[$parameter] != undefined) {
				objQuery[$parameter]=$value;
				DeepLinkUtil.populateParameters(objQuery);
			} else {
				DeepLinkUtil.addParameter($parameter,$value);
			}
		}
		public static function getParameterObject():Object
		{
			var strQuery:String=DeepLinkUtil.getQueryString();
			var objQuery:Object=new Object;
			var arrValuePairs:Array=strQuery.split("&");
			var tmpPreviousResult:*;
			for (var i:* in arrValuePairs) {
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
			var objQuery:Object=DeepLinkUtil.getParameterObject();
			delete objQuery[$parameter];
			DeepLinkUtil.populateParameters(objQuery);
		}
		
	}
}