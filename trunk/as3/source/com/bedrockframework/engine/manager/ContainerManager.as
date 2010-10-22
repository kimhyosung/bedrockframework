package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.IContainerManager;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.view.ContainerView;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.XMLUtil2;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class ContainerManager extends BasicWidget implements IContainerManager
	{
		/*
		Variable Declarations
		*/
		private var _objRoot:DisplayObjectContainer;
		private var _mapContainers:HashMap;

		private var _objPageContainer:ContainerView;
		private var _objPreloaderContainer:ContainerView;
		/*
		Constructor
		*/
		public function ContainerManager()
		{
		}

		public function initialize( $data:XML, $root:DisplayObjectContainer ):void
		{
			this._mapContainers = new HashMap  ;
			this._objRoot = $root;
			this.parse( $data );
		}
		private function parse( $data:XML ):void
		{
			this.buildContainers( $data, this._objRoot, true );
		}
		/*
		Layout Related
		*/
		private function buildContainers( $data:*, $parent:DisplayObjectContainer, $root:Boolean = false ):void
		{
			var xmlData:XML = XMLUtil2.getAsXML( $data );
			var objContainer:DisplayObjectContainer;
			if ( !$root ) {
				objContainer = this.createContainer( xmlData.@id, new Sprite, $parent, $data );
			} else {
				objContainer = $parent;
			}
			
			for each (var xmlSubContainer:XML in xmlData.children() ) {
				this.buildContainers( xmlSubContainer, objContainer );
			}
		}
		/*
		Container Managment
		*/
		public function createContainer( $id:String, $child:DisplayObjectContainer=null, $parent:DisplayObjectContainer=null, $data:*=null, $depth:int=-1 ):*
		{
			if ( !this.hasContainer( $id ) ) {
				return this.getNewContainer( $id, $child, $parent, $data, $depth );
			}
		}
		public function replaceContainer( $id:String, $child:DisplayObjectContainer, $data:*=null, $depth:int=-1 ):*
		{
			if ( this.hasContainer( $id ) ) {
				return this.getNewContainer( $id, $child, this.getContainer( $id ).parent, $data, $depth );
			}
		}
		private function getNewContainer($id:String, $child:DisplayObjectContainer, $parent:DisplayObjectContainer=null, $data:*=null, $depth:int=-1):*
		{
			var numDepth:int = -1;
			if (this.hasContainer( $id ) ) {
				numDepth = this.getDepth( $id );
				this.removeContainer($id);
			}
			numDepth=($depth > -1) ? $depth : numDepth;

			var objChild:DisplayObjectContainer = $child || new VisualLoader  ;
			objChild.name = $id;

			var numActualDepth:int = this.addContainer($parent || this._objRoot,objChild,numDepth);
			this.applyProperties( objChild, $data );

			this.saveData( $id, objChild, numActualDepth );

			return objChild;
		}
		
		
		/*
		Apply Property Object to container
		*/
		private function applyProperties($target:DisplayObjectContainer, $data:*=null):void
		{
			var objData:Object = ( $data is XML ) ? XMLUtil2.getAttributesAsObject( $data ) : $data;
			for ( var a:String in objData ) {
				switch (a) {
					case "id" :
						break;
					default :
						$target[a] = objData[a];
						break;
				}
			}
		}
		/*
		Depth Functions
		*/
		public function getDepth($id:String):int
		{
			var objContainer:* = this.getContainer($id)
			return objContainer.parent.getChildIndex( objContainer );
		}
		/*
		Container Functions
		*/
		private function addContainer($container:DisplayObjectContainer, $child:DisplayObjectContainer, $depth:int =-1 ):int
		{
			try {
				$container.addChildAt($child, $depth);
			} catch ($error:Error) {
				$container.addChild($child);
			}
			return $container.getChildIndex($child);
		}
		public function getContainer($name:String):*
		{
			var objData:ContainerData = this.getData($name);
			return ( objData ) ? objData.container : null;
		}
		public function removeContainer($name:String):void
		{
			var objChild:* = this.getContainer($name);
			var objParent:* = objChild.parent;
			if (objChild && objParent) {
				objParent.removeChild(objChild);
			}
		}
		public function hasContainer($name:String):Boolean
		{
			return this._mapContainers.containsKey($name);
		}
		/*
		Item Specific Stuff
		*/
		private function saveData($name:String, $parent:DisplayObjectContainer, $depth:uint):void
		{
			this._mapContainers.saveValue($name, new ContainerData( $parent, $depth ) );
		}
		private function getData($name:String):ContainerData
		{
			return this._mapContainers.getValue($name);
		}
		private function removeData($name:String):void
		{
			this._mapContainers.removeValue($name);
		}
		/*
		Property Definitions
		*/
		public function get root():DisplayObjectContainer
		{
			return this._objRoot;
		}
	}
}

import flash.display.DisplayObjectContainer;
class ContainerData
{
	public var container:DisplayObjectContainer;
	public var depth:uint;

	public function ContainerData($parent:DisplayObjectContainer, $depth:uint)
	{
		this.container = $parent;
		this.depth = $depth;
	}
}