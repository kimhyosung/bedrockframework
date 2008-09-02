
package com.builtonbedrock.storage
{

	public interface IMap
	{

		function saveValue($key:*, $value:*):void;
		function removeValue($key:*):void;
		function pullValue($key:*):*;
		
		function containsKey($key:*):Boolean;
		function containsValue($value:*):Boolean;
		
		function getKey($value:*):String;
		function getValue($key:*):*;
		function getKeys():Array;
		function getValues():Array;


		function get size():int;
		function isEmpty():Boolean;

		function reset():void;
		function resetAllExcept($key:*):void;
		
		function clear():void;
		function clearAllExcept($key:*):void;
	}
}