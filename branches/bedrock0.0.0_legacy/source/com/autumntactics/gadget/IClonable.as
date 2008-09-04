package com.autumntactics.gadget
{
	public interface IClonable
	{
		function set id($index:int):void;
		function get id():int;
		
		function set row($index:int):void;
		function get row():int;
		
		function set column($index:int):void;
		function get column():int;
	}
}