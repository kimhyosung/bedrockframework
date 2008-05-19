/**

Cloner

*/
package com.autumntactics.gadget
{
	import com.autumntactics.data.ClonerData;
	import com.autumntactics.events.ClonerEvent;
	import com.autumntactics.bedrock.base.DispatcherWidget;
	import com.autumntactics.storage.HashMap;
	import com.autumntactics.util.MathUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class Cloner extends DispatcherWidget
	{

		/*
		Variable Decarations
		*/
		private var objParent:DisplayObjectContainer;
		private var objContainer:DisplayObjectContainer;
		private var objCurrentClone:DisplayObjectContainer;
		private var clsChild:Class;
		private var strDirection:String;

		private var numXspace:int;
		private var numYspace:int;
		private var numXrange:int;
		private var numYrange:int;
		private var numWrap:uint;

		private var numXposition:int;
		private var numYposition:int;

		private var numIndex:int;

		private var numWrapIndex:int;
		private var strPattern:String;
		private var numColumn:int;
		private var numRow:int;

		private var bolUseDummy:Boolean;

		private var objCloneMap:HashMap;
		/*
		Constructor
		*/
		public function Cloner($parent:DisplayObjectContainer,$child:Class,$useDummy:Boolean=true)
		{
			this.objParent=$parent;
			this.clsChild=$child;
			this.bolUseDummy=$useDummy;
		}
		public function initialize($data:ClonerData):Array
		{
			this.clear();
			//
			this.status("Initialize");
			this.dispatchEvent(new ClonerEvent(ClonerEvent.INIT,this,{total:$data.total}));
			this.objCloneMap=new HashMap  ;
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
			this.numColumn=1;
			this.numRow=1;
			//
			if ($resetPosition) {
				this.numXposition=0;
				this.numYposition=0;
			}
			if ($resetIndex) {
				this.numIndex=0;
			}
			if ($resetWrapping) {
				this.numWrapIndex=1;
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
				var numLength:int = this.objCloneMap.size;
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
			this.objCurrentClone=new this.clsChild  ;
			this.objCloneMap.saveValue(this.numIndex,this.objCurrentClone);

			this.applyProperties(this.objCurrentClone,this.getProperties());
			this.objContainer.addChild(this.objCurrentClone);

			this.dispatchEvent(new ClonerEvent(ClonerEvent.CREATE,this,{clone:this.objCurrentClone,id:this.numIndex}));
			this.numIndex++;
			return this.objCurrentClone;
		}
		public function removeClone($identifier:*):void
		{
			var numID:Number;
			var objChild:DisplayObject;
			if (typeof $identifier == "number") {
				numID=$identifier;
				objChild = this.objContainer.removeChild(this.getClone($identifier));
			} else {
				numID=$identifier;
				objChild = this.objContainer.removeChild($identifier);
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
			if (this.bolUseDummy) {
				this.objContainer=new Sprite  ;
				this.objParent.addChild(this.objContainer);
			} else {
				this.objContainer=this.objParent;
			}
			return this.objContainer;
		}
		private function removeContainer($notify:Boolean=true):void
		{
			try {
				this.objContainer.parent.removeChild(this.objContainer);
			} catch ($e:Error) {

			}
		}
		/*
		
		
		Positioning Property
		
		
		*/
		private function getProperties():Object
		{
			if (this.numIndex != 0) {
				this.numWrapIndex++;
				switch (this.strPattern) {
					case ClonerData.GRID :
						this.calculateGridProperties();
						break;
					case ClonerData.LINEAR :
						this.calculateLinearProperties();
						break;
					case ClonerData.RANDOM :
						return {x:MathUtil.random(this.numXrange),y:MathUtil.random(this.numYrange),id:this.numIndex};
						break;
				}
			} else if (this.strPattern == ClonerData.RANDOM) {
				return {x:MathUtil.random(this.numXrange),y:MathUtil.random(this.numYrange),id:this.numIndex};
			}
			return {x:this.numXposition,y:this.numYposition,column:this.numColumn,row:this.numRow,id:this.numIndex};
		}
		private function calculateGridProperties():void
		{
			switch (this.strDirection) {
				case ClonerData.HORIZONTAL :
					this.numXposition+= this.numXspace;
					if (this.numWrapIndex > this.numWrap) {
						this.numXposition=0;
						this.numYposition+= this.numYspace;
						this.numWrapIndex=1;
						this.numRow+= 1;
					}
					this.numColumn=this.numWrapIndex;
					break;
				case ClonerData.VERTICAL :
					this.numYposition+= this.numYspace;
					if (this.numWrapIndex > this.numWrap) {
						this.numYposition=0;
						this.numXposition+= this.numXspace;
						this.numWrapIndex=1;
						this.numColumn+= 1;
					}
					this.numRow=this.numWrapIndex;
					break;
			}
		}
		private function calculateLinearProperties():void
		{
			switch (this.strDirection) {
				case ClonerData.HORIZONTAL :
					this.numXposition+= this.numXspace;
					break;
				case ClonerData.VERTICAL :
					this.numYposition+= this.numYspace;
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
			return this.objCloneMap.getValue($index);
		}

		/*
		
		
		Property Definitions
		
		
		*/
		public function setPositionProperties($data:ClonerData):void
		{
			if (this.strPattern != ClonerData.RANDOM) {
				this.setWrap($data.wrap);
				this.setSpacing($data.xspace,$data.yspace);
				this.setOffset($data.offset);
			} else {
				this.setRange($data.xrange,$data.yrange);
			}
		}
		public function setSpacing($xspace:int,$yspace:int):void
		{
			this.numXspace=$xspace;
			this.numYspace=$yspace;
		}
		public function setWrap($wrap:int):void
		{
			this.numWrap=$wrap;
		}
		public function setOffset($offset:int=0):void
		{
			if ($offset >= this.numWrap && this.numWrap != 0) {
				this.error("Offset cannot be greater than or equal to wrap count!");
			}
			switch (this.strDirection) {
				case ClonerData.HORIZONTAL :
					this.numXposition=this.numXspace * $offset;
					break;
				case ClonerData.VERTICAL :
					this.numYposition=this.numYspace * $offset;
					break;
			}
			if (this.strPattern == ClonerData.GRID) {
				this.numWrapIndex=$offset + 1;
			}
		}
		public function setRange($xrange:int,$yrange:int):void
		{
			this.numXrange=$xrange || 0;
			this.numYrange=$yrange || 0;
		}
		public function setDirection($direction:String):void
		{
			var strDirectionTemp:String=$direction.toLowerCase();
			if (strDirectionTemp != ClonerData.HORIZONTAL && strDirectionTemp != ClonerData.VERTICAL && strDirectionTemp != ClonerData.RANDOM) {
				this.error("Invalid directional value!");
			} else {
				this.strDirection=strDirectionTemp;
				if (this.strDirection == ClonerData.RANDOM) {
					this.strPattern=ClonerData.RANDOM;
				}
			}
		}
		public function setPattern($pattern:String):void
		{
			var strPatternTemp:String=$pattern.toLowerCase();
			if (this.strDirection != ClonerData.RANDOM) {
				if (strPatternTemp != ClonerData.LINEAR && strPatternTemp != ClonerData.GRID && strPatternTemp != ClonerData.RANDOM) {
					this.error("Invalid pattern value!");
				} else {
					this.strPattern=strPatternTemp;
				}
			} else {
				this.strPattern=ClonerData.RANDOM;
			}
		}
		/*
		Returns the current index of the movieclip being cloned.
		*/
		public function get index():int
		{
			return this.numIndex;
		}
		public function get row():int
		{
			return this.numRow;
		}
		public function get column():int
		{
			return this.numColumn;
		}
		/*
		Returns the instance of the display object being cloned.
		*/
		public function get current():*
		{
			return this.objCurrentClone;
		}
		public function set direction($direction:String)
		{
			this.setDirection($direction);
		}
		public function get direction():String
		{
			return this.strDirection;
		}
		public function set pattern($pattern:String)
		{
			this.setPattern($pattern);
		}
		public function get pattern():String
		{
			return this.strPattern;
		}
		public function get wrap():int
		{
			return this.numWrap;
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
			return this.objCloneMap.getValues();
		}
		
		public function get numChildren():int
		{
			return this.objCloneMap.size;
		}
		/*
		Returns DisplayObject Info
		*/
		public function get parent():DisplayObjectContainer
		{
			return this.objParent;
		}
		public function get container():DisplayObjectContainer
		{
			return this.objContainer;
		}
	}
}