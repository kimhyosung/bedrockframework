package com.bedrockframework.plugin.tools
{
	public interface IPageable
	{
		function hasNextPage():Boolean;
		function hasPreviousPage():Boolean;
		
		function selectPage($index:int):int;
		function nextPage():int;
		function previousPage():int;
		
		function get totalItems():int;
		function get selectedPage():int;
		function get totalPages():int;
		
	}
}