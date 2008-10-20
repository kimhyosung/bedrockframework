package com.bedrockframework.engine.api
{
	import flash.display.DisplayObjectContainer;
	
	
	public interface IContainerManager
	{
		function initialize($scope:DisplayObjectContainer):void
		function buildContainer($name:String,$child:DisplayObjectContainer=null,$properties:Object=null,$container:DisplayObjectContainer=null,$depth:int=-1):*
		function buildLayout($layout:Array):void;
		/*
		Item Specific Stuff
		*/
		function saveItem($name:String,$child:DisplayObjectContainer,$depth:int):void		
		function getItem($name:String):Object		
		function removeItem($name:String):void		
		function containsItem($name:String):Boolean		
		
		/*
		Depth Functions
		*/
		function getDepth($name:String):int		
		/*
		Container Functions
		*/
		function getContainer($name:String):*		
		function getContainerParent($name:String):*		
		function removeContainer($name:String):void		
		/*
		Swapping Functions
		*/
		function swapChildren($name1:String,$name2:String):void		
		function swapTo($name:String,$depth:Number):void		
		function swapToTop($name:String,$offset:Number=0):void		
		function swapToBottom($name:String,$offset:Number=0):void		
	}
}