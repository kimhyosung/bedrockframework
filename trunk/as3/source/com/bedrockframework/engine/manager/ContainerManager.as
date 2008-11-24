package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.engine.api.IContainerManager;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	
	import flash.display.DisplayObjectContainer;

	public class ContainerManager extends StandardWidget implements IContainerManager
	{
		/*
		Variable Declarations
		*/
		private var _objScope:DisplayObjectContainer;
		private var _objContainerMap:HashMap=new HashMap;
		/*
		Constructor
		*/
		public function ContainerManager()
		{
		}

		public function initialize($scope:DisplayObjectContainer):void
		{
			this._objScope=$scope;
		}
		public function createContainer($name:String,$child:DisplayObjectContainer=null,$properties:Object=null,$container:DisplayObjectContainer=null,$depth:int=-1):*
		{
			if (!this.hasContainer($name)) {
				return this.tempContainer($name, $child, $properties, $container, $depth);
			}
		}
		public function replaceContainer($name:String,$child:DisplayObjectContainer,$properties:Object=null,$container:DisplayObjectContainer=null,$depth:int=-1):*
		{
			if (this.hasContainer($name)) {
				return this.tempContainer($name, $child, $properties, $container, $depth);
			}
		}
		private function tempContainer($name:String,$child:DisplayObjectContainer,$properties:Object=null,$container:DisplayObjectContainer=null,$depth:int=-1):*
		{
			var numDepth:int=-1;
			if (this.hasContainer($name)) {
				numDepth=this.getDepth($name);
				this.removeContainer($name);
			}
			numDepth=($depth > -1) ? $depth : numDepth;
			
			var objChild:DisplayObjectContainer = $child || new VisualLoader;
		
			var numActualDepth:int=this.addContainer($container || this._objScope,objChild,numDepth);
			this.applyProperties(objChild,$properties);

			this.saveData($name,objChild,numActualDepth);
			return objChild;
		}
		/*
		Layout Related
		*/
		public function buildLayout($layout:Array):void
		{
			for (var i:int = 0; i < $layout.length; i++) {
				this.buildLayoutContainer($layout[i]);
			}
		}
		private function buildLayoutContainer($properties:Object):void
		{
			var strName:String =$properties.name;
			var objView:DisplayObjectContainer = $properties.view || new VisualLoader();
			delete $properties.name;
			this.createContainer(strName, objView, $properties);
		}
		/*
		Item Specific Stuff
		*/
		private function saveData($name:String, $container:DisplayObjectContainer, $depth:uint):void
		{
			this._objContainerMap.saveValue($name, new ContainerData($container, $depth));
		}
		private function getData($name:String):ContainerData
		{
			return this._objContainerMap.getValue($name);
		}
		private function removeData($name:String):void
		{
			this._objContainerMap.removeValue($name);
		}
		/*
		Apply Property Object to container
		*/
		private function applyProperties($target:DisplayObjectContainer,$properties:Object=null):void
		{
			for (var i:String in $properties) {
				$target[i]=$properties[i];
			}
		}
		/*
		Depth Functions
		*/
		public function getDepth($name:String):int
		{
			var objData:ContainerData=this.getData($name);
			return objData.depth;
		}
		private function getActualDepth($name:String):int
		{
			var objChild:* =this.getContainer($name);
			var objParent:* =this.getContainerParent($name);
			return objParent.getChildIndex(objChild);
		}
		/*
		Container Functions
		*/
		private function addContainer($container:DisplayObjectContainer,$child:DisplayObjectContainer,$depth:int=-1):int
		{
			try {
				$container.addChildAt($child,$depth);
			} catch ($error:Error) {
				$container.addChild($child);
			}
			return $container.getChildIndex($child);
		}
		public function getContainer($name:String):*
		{
			var objData:ContainerData=this.getData($name);
			return objData ? objData.container : null;
		}
		public function getContainerParent($name:String):*
		{
			var objContainer:* = this.getContainer($name);
			return objContainer ? objContainer.parent : null;
		}
		public function removeContainer($name:String):void
		{
			var objChild:* =this.getContainer($name);
			var objParent:* =this.getContainerParent($name);
			if (objChild && objParent) {
				objParent.removeChild(objChild);
			}
		}
		public function hasContainer($name:String):Boolean
		{
			return this._objContainerMap.containsKey($name);
		}
		/*
		Swapping Functions
		*/
		public function swapChildren($name1:String,$name2:String):void
		{
			var objChild1:* =this.getContainer($name1);
			var objChild2:* =this.getContainer($name2);
			if (objChild1.parent === objChild2.parent) {
				objChild1.parent.swapChildren(objChild1,objChild2);
			} else {
				this.error("Parent containers do not match!");
			}
		}
		public function swapTo($name:String,$depth:Number):void
		{
			var objChild:* =this.getContainer($name);
			var objParent:* =this.getContainerParent($name);
			try {
				objParent.setChildIndex(objChild,$depth);
			} catch ($e:RangeError) {
				this.error($e.message + " Swap failed!");
			}
		}
		public function swapToTop($name:String,$offset:Number=0):void
		{
			var objParent:* =this.getContainerParent($name);
			this.swapTo($name, (objParent.numChildren - 1) + $offset);
		}
		public function swapToBottom($name:String,$offset:Number=0):void
		{
			this.swapTo($name, 0 + $offset);
		}
		
		public function get scope():DisplayObjectContainer
		{
			return this._objScope;
		}
	}
}
	import flash.display.DisplayObjectContainer;
	
class ContainerData 
{
	public var container:DisplayObjectContainer;
	public var depth:uint;
	
	public function ContainerData($container:DisplayObjectContainer, $depth:uint)
	{
		this.container = $container;
		this.depth = $depth;
	}
}