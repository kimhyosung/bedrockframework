package com.bedrockframework.engine.api
{
	import com.bedrockframework.engine.view.ContainerView;
	
	import flash.display.DisplayObjectContainer;
	
	
	public interface IContainerManager
	{
		function initialize( $data:XML, $root:DisplayObjectContainer ):void;
		function createContainer( $id:String, $child:DisplayObjectContainer=null, $parent:DisplayObjectContainer=null, $data:*=null, $depth:int=-1 ):*;
		function replaceContainer( $id:String, $child:DisplayObjectContainer, $data:*=null, $depth:int=-1 ):*;
		
		/*
		Depth Functions
		*/
		function getDepth($name:String):int;
		/*
		Container Functions
		*/
		function getContainer($name:String):*;
		function removeContainer($name:String):void;
		function hasContainer($name:String):Boolean;
		/*
		Property Definitions
		*/
		function get root():DisplayObjectContainer;
	}
}