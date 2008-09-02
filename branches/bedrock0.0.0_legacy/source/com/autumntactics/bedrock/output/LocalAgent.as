/**


LocalAgent
Central processing point for all traces going to the output panel.


*/

package com.builtonbedrock.bedrock.output
{
	public class LocalAgent
	{
		import flash.events.Event;
		/*
		Post
		*/
		public static function post($trace, $category:String, $target:String):void
		{
			if ($trace != null){
				if (!LocalAgent.isEvent($category)) {
					if (typeof ($trace) == "object") {
						LocalAgent.outputObject($trace, $category, $target, LocalAgent.isError($category));
					} else {
						LocalAgent.outputSimple($trace, $category, $target, LocalAgent.isError($category));
					}
				} else {
					LocalAgent.outputEvent($trace);
				}
			}else{
				LocalAgent.outputSimple(null, $category, $target, LocalAgent.isError($category));
			}
		}
		/*
		Display
		*/
		private static function outputSimple($trace, $category:String, $target:String, $error:Boolean):void
		{
			var strTrace:String;
			if (LocalAgent.isConstructor($category)) {
				strTrace = $target + " : " + $trace;
			} else {
				strTrace = $target + " " + $category + " : " + $trace;
			}
			if (!$error) {
				trace(strTrace);
			} else {
				throw new Error(strTrace);
			}
		}
		private static function outputObject($trace, $category:String, $target:String, $error:Boolean):void
		{
			var strOutput:String = "";
			var objTrace:Object = $trace;
			var strName:String = objTrace.toString();
			if (strName.indexOf("undefined") != -1) {
				strName = "[object Object]";
			}
			if (!LocalAgent.isConstructor($category)) {
				strOutput += ("\n" + $target + " " + $category + " : " + strName + "\n");
			} else {
				strOutput += ("\n" + $target + " : " + strName + "\n");
			}
			strOutput += ("-------------------------------------------------------------------------------------" + "\n");
			for (var i in objTrace) {
				if (objTrace[i] != null) {
					if (typeof (objTrace[i]) == "object") {
						strOutput += ("  +[" + typeof (objTrace[i]) + "] " + i + " : " + "\n");
						for (var o in objTrace[i]) {
							strOutput += ("       -[" + typeof (objTrace[i][o]) + "] " + o + " : " + objTrace[i][o] + "\n");
						}
					} else {
						strOutput += ("  -[" + typeof (objTrace[i]) + "] " + i + " : " + objTrace[i] + "\n");
					}
				} else {
					strOutput += ("  -[" + typeof (objTrace[i]) + "] " + i + " : " + null + "\n");
				}
			}
			strOutput += "\n";
			if (!$error) {
				trace(strOutput);
			} else {
				throw new Error(strOutput);
			}
		}
		public static function outputEvent($event:Event):void
		{
			var strOutput:String = "";
			var objTrace:Object = $event;
			strOutput += ("\n" + objTrace.target.toString() + " : Event Object" + "\n");
			strOutput += ("-------------------------------------------------------------------------------------" + "\n");
			for (var i in objTrace) {
				if (typeof (objTrace[i]) == "object") {
					strOutput += ("  +[" + typeof (objTrace[i]) + "] " + i + " : " + "\n");
					for (var o in objTrace[i]) {
						strOutput += ("       -[" + typeof (objTrace[i][o]) + "] " + o + " : " + objTrace[i][o] + "\n");
					}
				} else {
					strOutput += ("  -[" + typeof (objTrace[i]) + "] " + i + " : " + objTrace[i] + "\n");
				}
			}
			strOutput += "\n";
			trace(strOutput);
		}
		/*
		Checks if the trace is of type constructor.
		*/
		private static function isConstructor($category:String):Boolean
		{
			if ($category == "[Constructor]") {
				return true;
			} else {
				return false;
			}
		}
		/*
		Checks if the trace is of type error.
		*/
		private static function isError($category:String):Boolean
		{
			if ($category == "[Error]") {
				return true;
			} else {
				return false;
			}
		}
		/*
		Checks if the trace is of type error.
		*/
		private static function isEvent($category:String):Boolean
		{
			if ($category == "[Event]") {
				return true;
			} else {
				return false;
			}
		}
	}
}