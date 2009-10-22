/**

Cloner

*/
package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.core.base.SpriteWidget;
	import com.bedrockframework.plugin.data.ClonerData;
	import com.bedrockframework.plugin.event.ClonerEvent;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.MathUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class Cloner extends SpriteWidget
	{

		/*
		Variable Decarations
		*/
		private var _objParent:DisplayObjectContainer;
		private var _objContainer:DisplayObjectContainer;
		private var _objCurrentClone:DisplayObjectContainer;

		private var _numXposition:int;
		private var _numYposition:int;

		private var _numIndex:int;
		private var _numColumn:int;
		private var _numRow:int;
		private var _numWrapIndex:int;

		private var _objCloneMap:HashMap;
		private var _objCloneArray:Array;
		
		public var clone:Class;
		public var data:ClonerData;
		/*
		Constructor
		*/
		public function Cloner($clone:Class, $parent:DisplayObjectContainer = null)
		{
			this._objCloneMap=new HashMap  ;
			this._objParent=$parent || this;
			this.clone=$clone;
		}
		public function initialize($data:ClonerData):Array
		{
			this.data = $data;
			this.clear();
			//
			this.status("Initialize");
			this.dispatchEvent(new ClonerEvent(ClonerEvent.INITIALIZE,this,{total:$data.total}));
			//
			this.setOffset($data.offset);
			//
			var arrCloneClips:Array=new Array;
			
			if ($data.total > 0) {
				for (var i:int=0; i < this.data.total; i++) {
					arrCloneClips.push(this.createClone());
				}
			}
			this.dispatchEvent(new ClonerEvent(ClonerEvent.COMPLETE,this,{total:this.data.total,children:arrCloneClips}));
			//
			return arrCloneClips;
		}
		public function clear($resetPosition:Boolean=true,$resetIndex:Boolean=true,$resetWrapping:Boolean=true):void
		{
			this._numColumn=1;
			this._numRow=1;
			//
			if ($resetPosition) {
				this._numXposition=0;
				this._numYposition=0;
			}
			if ($resetIndex) {
				this._numIndex=0;
			}
			if ($resetWrapping) {
				this._numWrapIndex=1;
			}
			//
			this.destroyClones();
			this._objCloneMap.clear();
			this._objCloneArray = new Array;
			//
			this.recreateContainer();
			//
			this.dispatchEvent(new ClonerEvent(ClonerEvent.CLEAR,this));
			this.status("Cleared");
		}
		/*
		Destroy Clones
		*/
		private function destroyClones():void
		{
			try {
				var numLength:int = this._objCloneMap.size;
				for (var i:int =0; i <numLength; i++) {
					this.removeClone(i);
				}
			} catch ($e:Error) {
			}
		}
		/*
		Clone Functions
		*/
		public function createClone():DisplayObjectContainer
		{
			this._objCurrentClone=new this.clone;
			this._objCloneMap.saveValue(this._numIndex.toString(), this._objCurrentClone);
			this._objCloneArray.push( this._objCurrentClone );

			this.applyProperties(this._objCurrentClone,this.getProperties());
			this._objContainer.addChild(this._objCurrentClone);

			this.dispatchEvent(new ClonerEvent(ClonerEvent.CREATE,this,{child:this._objCurrentClone, id:this._numIndex, index:this._numIndex}));
			this._numIndex++;
			return this._objCurrentClone;
		}
		public function removeClone($identifier:*):void
		{
			var numID:Number;
			var objChild:DisplayObject;
			if (typeof $identifier == "number") {
				numID=$identifier;
				objChild = this._objContainer.removeChild(this.getClone($identifier));
			} else {
				numID=$identifier;
				objChild = this._objContainer.removeChild($identifier);
			}
			objChild = null;
			this.dispatchEvent(new ClonerEvent(ClonerEvent.REMOVE,this,{id:numID}));
		}
		/*
		
		
		Empty Container Functions
		
		
		*/
		private function recreateContainer():void
		{
			this.removeContainer();
			this.createContainer();
		}
		private function createContainer():DisplayObjectContainer
		{
			if (this.data.useDummyContainer) {
				this._objContainer=new Sprite  ;
				this._objParent.addChild(this._objContainer);
			} else {
				this._objContainer=this._objParent;
			}
			return this._objContainer;
		}
		private function removeContainer($notify:Boolean=true):void
		{
			try {
				this._objContainer.parent.removeChild(this._objContainer);
			} catch ($e:Error) {

			}
		}
		/*
		
		
		Positioning Property
		
		
		*/
		private function getProperties():Object
		{
			if (this._numIndex != 0) {
				this._numWrapIndex++;
				switch (this.data.pattern) {
					case ClonerData.GRID :
						this.calculateGridProperties();
						break;
					case ClonerData.LINEAR :
						this.calculateLinearProperties();
						break;
					case ClonerData.RANDOM :
						return {x:MathUtil.random(this.data.rangeX),y:MathUtil.random(this.data.rangeY),id:this._numIndex};
						break;
				}
			} else if (this.data.pattern == ClonerData.RANDOM) {
				return {x:MathUtil.random(this.data.rangeX),y:MathUtil.random(this.data.rangeY),id:this._numIndex};
			}
			return {x:this._numXposition,y:this._numYposition,column:this._numColumn,row:this._numRow,id:this._numIndex};
		}
		private function calculateGridProperties():void
		{
			switch (this.data.direction) {
				case ClonerData.HORIZONTAL :
					this._numXposition+= this.data.spaceX;
					if (this._numWrapIndex > this.data.wrap) {
						this._numXposition=0;
						this._numYposition+= this.data.spaceY;
						this._numWrapIndex=1;
						this._numRow+= 1;
					}
					this._numColumn=this._numWrapIndex;
					break;
				case ClonerData.VERTICAL :
					this._numYposition+= this.data.spaceY;
					if (this._numWrapIndex > this.data.wrap) {
						this._numYposition=0;
						this._numXposition+= this.data.spaceX;
						this._numWrapIndex=1;
						this._numColumn+= 1;
					}
					this._numRow=this._numWrapIndex;
					break;
			}
		}
		private function calculateLinearProperties():void
		{
			switch (this.data.direction) {
				case ClonerData.HORIZONTAL :
					this._numXposition+= this.data.spaceX;
					break;
				case ClonerData.VERTICAL :
					this._numYposition+= this.data.spaceY;
					break;
			}
		}
		private function applyProperties($target:DisplayObjectContainer,$data:Object):void
		{
			var objData:Object = $data;
			try {
				var objClone:IClonable=$target as IClonable;
			} catch ($e:Error) {
				// Is not type of IClonable, cannot apply certain properties.
				delete objData.id;
				delete objData.column;
				delete objData.row;
			} 
			if ( objClone == null ) {
				delete objData.id;
				delete objData.column;
				delete objData.row;
			}
			
			for (var i:String in objData) {
				$target[i]=objData[i];
			}
		}
		/*
		
		
		Getters
		
		
		*/
		public function getClone($index:int):*
		{
			return this._objCloneMap.getValue($index.toString());
		}

		/*
		
		
		Property Definitions
		
		
		*/
		public function setOffset($offset:int=0):void
		{
			if ($offset >= this.data.wrap && this.data.wrap != 0) {
				this.error("Offset cannot be greater than or equal to wrap count!");
			}
			switch (this.data.direction) {
				case ClonerData.HORIZONTAL :
					this._numXposition=this.data.spaceX * $offset;
					break;
				case ClonerData.VERTICAL :
					this._numYposition=this.data.spaceY * $offset;
					break;
			}
			if (this.data.pattern == ClonerData.GRID) {
				this._numWrapIndex=$offset + 1;
			}
		}
		/*
		Returns the current index of the movieclip being cloned.
		*/
		public function get index():int
		{
			return this._numIndex;
		}
		public function get row():int
		{
			return this._numRow;
		}
		public function get column():int
		{
			return this._numColumn;
		}
		/*
		Returns the instance of the display object being cloned.
		*/
		public function get current():*
		{
			return this._objCurrentClone;
		}
		
	
		public function get children():Array
		{
			return this._objCloneArray;
		}
		
		
	}
}