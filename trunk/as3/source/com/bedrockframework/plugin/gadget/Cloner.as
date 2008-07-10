/**

Cloner

*/
package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.plugin.data.ClonerData;
	import com.bedrockframework.plugin.event.ClonerEvent;
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.MathUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class Cloner extends DispatcherWidget
	{

		/*
		Variable Decarations
		*/
		private var _objParent:DisplayObjectContainer;
		private var _objContainer:DisplayObjectContainer;
		private var _objCurrentClone:DisplayObjectContainer;
		private var clsChild:Class;
		private var _strDirection:String;

		private var _numXspace:int;
		private var _numYspace:int;
		private var _numXrange:int;
		private var _numYrange:int;
		private var _numWrap:uint;

		private var _numXposition:int;
		private var _numYposition:int;

		private var _numIndex:int;

		private var _numWrapIndex:int;
		private var _strPattern:String;
		private var _numColumn:int;
		private var _numRow:int;

		private var _bolUseDummy:Boolean;

		private var _objCloneMap:HashMap;
		/*
		Constructor
		*/
		public function Cloner($parent:DisplayObjectContainer,$child:Class,$useDummy:Boolean=true)
		{
			this._objParent=$parent;
			this.clsChild=$child;
			this._bolUseDummy=$useDummy;
		}
		public function initialize($data:ClonerData):Array
		{
			this.clear();
			//
			this.status("Initialize");
			this.dispatchEvent(new ClonerEvent(ClonerEvent.INIT,this,{total:$data.total}));
			this._objCloneMap=new HashMap  ;
			//
			this.setDirection($data.direction || ClonerData.HORIZONTAL);
			this.setPattern($data.pattern || ClonerData.LINEAR);
			this.setPositionProperties($data);
			//
			var arrCloneClips:Array=new Array;
			for (var i=0; i < $data.total; i++) {
				arrCloneClips.push(this.createClone());
			}
			if ($data.total > 0) {
			}
			this.dispatchEvent(new ClonerEvent(ClonerEvent.COMPLETE,this,{total:$data.total,children:arrCloneClips}));
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
				for (var i =0; i <numLength; i++) {
					this.removeClone(i);
				}
			} catch ($e) {
			}
		}
		/*
		Clone Functions
		*/
		public function createClone():DisplayObjectContainer
		{
			this._objCurrentClone=new this.clsChild;
			this._objCloneMap.saveValue(this._numIndex.toString(), this._objCurrentClone);

			this.applyProperties(this._objCurrentClone,this.getProperties());
			this._objContainer.addChild(this._objCurrentClone);

			this.dispatchEvent(new ClonerEvent(ClonerEvent.CREATE,this,{child:this._objCurrentClone,id:this._numIndex}));
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
			if (this._bolUseDummy) {
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
				switch (this._strPattern) {
					case ClonerData.GRID :
						this.calculateGridProperties();
						break;
					case ClonerData.LINEAR :
						this.calculateLinearProperties();
						break;
					case ClonerData.RANDOM :
						return {x:MathUtil.random(this._numXrange),y:MathUtil.random(this._numYrange),id:this._numIndex};
						break;
				}
			} else if (this._strPattern == ClonerData.RANDOM) {
				return {x:MathUtil.random(this._numXrange),y:MathUtil.random(this._numYrange),id:this._numIndex};
			}
			return {x:this._numXposition,y:this._numYposition,column:this._numColumn,row:this._numRow,id:this._numIndex};
		}
		private function calculateGridProperties():void
		{
			switch (this._strDirection) {
				case ClonerData.HORIZONTAL :
					this._numXposition+= this._numXspace;
					if (this._numWrapIndex > this._numWrap) {
						this._numXposition=0;
						this._numYposition+= this._numYspace;
						this._numWrapIndex=1;
						this._numRow+= 1;
					}
					this._numColumn=this._numWrapIndex;
					break;
				case ClonerData.VERTICAL :
					this._numYposition+= this._numYspace;
					if (this._numWrapIndex > this._numWrap) {
						this._numYposition=0;
						this._numXposition+= this._numXspace;
						this._numWrapIndex=1;
						this._numColumn+= 1;
					}
					this._numRow=this._numWrapIndex;
					break;
			}
		}
		private function calculateLinearProperties():void
		{
			switch (this._strDirection) {
				case ClonerData.HORIZONTAL :
					this._numXposition+= this._numXspace;
					break;
				case ClonerData.VERTICAL :
					this._numYposition+= this._numYspace;
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
			} finally {
				for (var i in objData) {
					$target[i]=objData[i];
				}
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
		public function setPositionProperties($data:ClonerData):void
		{
			if (this._strPattern != ClonerData.RANDOM) {
				this.setWrap($data.wrap);
				this.setSpacing($data.xspace,$data.yspace);
				this.setOffset($data.offset);
			} else {
				this.setRange($data.xrange,$data.yrange);
			}
		}
		public function setSpacing($xspace:int,$yspace:int):void
		{
			this._numXspace=$xspace;
			this._numYspace=$yspace;
		}
		public function setWrap($wrap:int):void
		{
			this._numWrap=$wrap;
		}
		public function setOffset($offset:int=0):void
		{
			if ($offset >= this._numWrap && this._numWrap != 0) {
				this.error("Offset cannot be greater than or equal to wrap count!");
			}
			switch (this._strDirection) {
				case ClonerData.HORIZONTAL :
					this._numXposition=this._numXspace * $offset;
					break;
				case ClonerData.VERTICAL :
					this._numYposition=this._numYspace * $offset;
					break;
			}
			if (this._strPattern == ClonerData.GRID) {
				this._numWrapIndex=$offset + 1;
			}
		}
		public function setRange($xrange:int,$yrange:int):void
		{
			this._numXrange=$xrange || 0;
			this._numYrange=$yrange || 0;
		}
		public function setDirection($direction:String):void
		{
			var strDirectionTemp:String=$direction.toLowerCase();
			if (strDirectionTemp != ClonerData.HORIZONTAL && strDirectionTemp != ClonerData.VERTICAL && strDirectionTemp != ClonerData.RANDOM) {
				this.error("Invalid directional value!");
			} else {
				this._strDirection=strDirectionTemp;
				if (this._strDirection == ClonerData.RANDOM) {
					this._strPattern=ClonerData.RANDOM;
				}
			}
		}
		public function setPattern($pattern:String):void
		{
			var strPatternTemp:String=$pattern.toLowerCase();
			if (this._strDirection != ClonerData.RANDOM) {
				if (strPatternTemp != ClonerData.LINEAR && strPatternTemp != ClonerData.GRID && strPatternTemp != ClonerData.RANDOM) {
					this.error("Invalid pattern value!");
				} else {
					this._strPattern=strPatternTemp;
				}
			} else {
				this._strPattern=ClonerData.RANDOM;
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
		public function set direction($direction:String)
		{
			this.setDirection($direction);
		}
		public function get direction():String
		{
			return this._strDirection;
		}
		public function set pattern($pattern:String)
		{
			this.setPattern($pattern);
		}
		public function get pattern():String
		{
			return this._strPattern;
		}
		public function get wrap():int
		{
			return this._numWrap;
		}
		public function set child($child:Class):void
		{
			this.clsChild = $child;
		}
		public function get child():Class
		{
			return this.clsChild;
		}
		
		public function get children():Array
		{
			return this._objCloneMap.getValues();
		}
		
		public function get numChildren():int
		{
			return this._objCloneMap.size;
		}
		/*
		Returns DisplayObject Info
		*/
		public function get parent():DisplayObjectContainer
		{
			return this._objParent;
		}
		public function get container():DisplayObjectContainer
		{
			return this._objContainer;
		}
	}
}