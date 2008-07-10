﻿package com.autumntactics.bedrock.manager
{
	import com.autumntactics.storage.HashMap;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import com.autumntactics.bedrock.base.StaticWidget;
	import com.autumntactics.bedrock.logging.LogLevel;
	import com.autumntactics.bedrock.logging.Logger;
	import com.autumntactics.loader.VisualLoader;

	public class ContainerManager extends StaticWidget
	{
		private static  var OBJ_SCOPE:DisplayObjectContainer;
		private static  var OBJ_CONTAINER_MAP:HashMap=new HashMap;
		
		Logger.log(ContainerManager, LogLevel.CONSTRUCTOR, "Constructed");

		public static function initialize($scope:DisplayObjectContainer):void
		{
			ContainerManager.setScope($scope);
		}
		public static function setScope($scope:DisplayObjectContainer):void
		{
			ContainerManager.OBJ_SCOPE=$scope;
		}
		public static function buildContainer($name:String,$child:DisplayObjectContainer=null,$properties:Object=null,$container:DisplayObjectContainer=null,$depth:int=-1):*
		{
			var numDepth:int=-1;
			if (ContainerManager.containsItem($name)) {
				numDepth=ContainerManager.getDepth($name);
				ContainerManager.removeContainer($name);
			}
			numDepth=$depth > -1?$depth:numDepth;
			
			var objChild:DisplayObjectContainer=$child || new VisualLoader;
		
			var numActualDepth:int=ContainerManager.addChild($container || ContainerManager.OBJ_SCOPE,objChild,numDepth);
			ContainerManager.applyProperties(objChild,$properties);

			ContainerManager.saveItem($name,objChild,numActualDepth);
			return objChild;
		}
		private static function addChild($container:DisplayObjectContainer,$child:DisplayObjectContainer,$depth:int=-1):int
		{
			try {
				$container.addChildAt($child,$depth);
			} catch ($error:Error) {
				$container.addChild($child);
			}
			return $container.getChildIndex($child);
		}
		/*
		Item Specific Stuff
		*/
		public static function saveItem($name:String,$child:DisplayObjectContainer,$depth:int):void
		{
			ContainerManager.OBJ_CONTAINER_MAP.saveValue($name,{container:$child,depth:$depth});
		}
		public static function getItem($name:String):Object
		{
			return ContainerManager.OBJ_CONTAINER_MAP.getValue($name);
		}
		public static function removeItem($name:String):void
		{
			ContainerManager.OBJ_CONTAINER_MAP.removeValue($name);
		}
		public static function containsItem($name:String):Boolean
		{
			return ContainerManager.OBJ_CONTAINER_MAP.containsKey($name);
		}
		/*
		Apply Property Object to container
		*/
		private static function applyProperties($target:DisplayObjectContainer,$properties:Object=null):void
		{
			for (var i in $properties) {
				$target[i]=$properties[i];
			}
		}
		/*
		Depth Functions
		*/
		public static function getDepth($name:String):int
		{
			var objItem:Object=ContainerManager.getItem($name);
			return objItem.depth;
		}
		private static function getActualDepth($name:String):int
		{
			var objChild:* =ContainerManager.getContainer($name);
			var objParent:* =ContainerManager.getContainerParent($name);
			return objParent.getChildIndex(objChild);
		}
		/*
		Container Functions
		*/
		public static function getContainer($name:String):*
		{
			var objItem:Object=ContainerManager.getItem($name);
			return objItem?objItem.container:null;
		}
		public static function getContainerParent($name:String):*
		{
			var objContainer:Object=ContainerManager.getContainer($name);
			return objContainer?objContainer.parent:null;
		}
		public static function removeContainer($name:String):void
		{
			var objChild:* =ContainerManager.getContainer($name);
			var objParent:* =ContainerManager.getContainerParent($name);
			if (objChild && objParent) {
				objParent.removeChild(objChild);
			}
		}
		/*
		Swapping Functions
		*/
		public static function swapChildren($name1:String,$name2:String)
		{
			var objChild1:* =ContainerManager.getContainer($name1);
			var objChild2:* =ContainerManager.getContainer($name2);
			if (objChild1.parent === objChild2.parent) {
				objChild1.parent.swapChildren(objChild1,objChild2);
			} else {
				Logger.error(ContainerManager, "Parent containers do not match!");
			}
		}
		public static function swapTo($name:String,$depth:Number)
		{
			var objChild:* =ContainerManager.getContainer($name);
			var objParent:* =ContainerManager.getContainerParent($name);
			try {
				objParent.setChildIndex(objChild,$depth);
			} catch ($e:RangeError) {
				Logger.warning(ContainerManager, $e.message + " Swap failed!");
			}
		}
		public static function swapToTop($name:String,$offset:Number=0):void
		{
			var objParent:* =ContainerManager.getContainerParent($name);
			ContainerManager.swapTo($name,objParent.numChildren - 1 + $offset);
		}
		public static function swapToBottom($name:String,$offset:Number=0):void
		{
			var objParent:* =ContainerManager.getContainerParent($name);
			ContainerManager.swapTo($name,0 + $offset);
		}
	}
}