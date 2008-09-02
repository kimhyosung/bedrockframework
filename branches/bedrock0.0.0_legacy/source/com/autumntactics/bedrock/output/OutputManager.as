/**


OutputManager
Central routing point for all traces going to various mediums.


*/
package com.builtonbedrock.bedrock.output
{
	
	public class OutputManager 
	{
		import com.builtonbedrock.util.ArrayUtil;
		import com.builtonbedrock.util.StringUtil;
		/*
		Variable Definitions
		*/
		private static  var OBJ_INSTANCE:OutputManager = new OutputManager();
		private static  var ARR_CATEGORY_COLLECTION:Array= new Array("constructor","status", "warning", "error", "event", "timer");
		private static  var NUM_OUTPUT_LEVEL:Number = 1;
		private static  var OBJ_OUTPUT_ONLY:Object;

		/*
		Route the trace function to its destination
		*/
		public static function send($trace:*, $category:* = 0, $target:* = null):void
		{
			if (OutputManager.NUM_OUTPUT_LEVEL > 0) {
				LocalAgent.post($trace, OutputManager.getCategory($category), OutputManager.getTarget($target));
			}
		}
		/*
		Output Only
		*/
		public static function outputOnly($object:Object = null):void
		{
			if ($object != null) {
				OutputManager.OBJ_OUTPUT_ONLY = $object;
				trace("\n\n");
				OutputManager.send("Outputting only " + $object.toString() + " all other output is silenced!", "warning", "OutputManager");
				trace("\n\n");
			} else {
				throw new Error("[OutputManager] [Error] : Object is undefined, outputOnly failed!");
			}
		}
		/*
		Category Retreival
		*/
		private static function getCategory($category:* = 0):String
		{
			var strCategory:String = "status";
			if (typeof ($category) == "number") {
				strCategory = OutputManager.ARR_CATEGORY_COLLECTION[$category];
			} else if (typeof ($category) == "string") {
				var numIndex:Number = ArrayUtil.findIndex(OutputManager.ARR_CATEGORY_COLLECTION, $category.toLowerCase());
				if (numIndex != -1) {
					strCategory = OutputManager.ARR_CATEGORY_COLLECTION[numIndex];
				}
			}
			return "[" + StringUtil.capitalize(strCategory) + "]";
		}
		/*
		Target Retreival
		*/
		private static function getTarget($target:* = null):String
		{
			if (typeof ($target) != "string") {
				var strTarget:String = ($target != null) ? $target.toString() : "[Global]";
				return strTarget;
			} else {
				return ($target);
			}
		}
		/*
		Property Definitions
		*/
		public static function set outputLevel($level:Number):void
		{
			OutputManager.NUM_OUTPUT_LEVEL = $level;
		}
		public static function get outputLevel():Number
		{
			return OutputManager.NUM_OUTPUT_LEVEL;
		}
	}
}