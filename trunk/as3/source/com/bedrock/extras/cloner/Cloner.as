package com.bedrock.extras.cloner
{
	import com.bedrock.framework.core.base.SpriteBase;
	import com.bedrock.framework.plugin.storage.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import com.bedrock.extras.util.MathUtil;

	public class Cloner extends SpriteBase
	{

		/*
		Variable Decarations
		*/
		private var _currentClone:DisplayObjectContainer;

		private var _positionX:int;
		private var _positionY:int;
		
		private var _numMaxSpacingX:int;
		private var _numMaxSpacingY:int;

		private var _index:int;
		private var _numColumn:int;
		private var _numRow:int;
		private var _wrapIndex:int;

		private var _mapClones:HashMap;
		private var _arrClones:Array;
		
		public var data:ClonerData;
		/*
		Constructor
		*/
		public function Cloner()
		{
			this._mapClones = new HashMap;
			this._arrClones = new Array;
		}
		public function initialize($data:ClonerData):Array
		{
			this.data = $data;
			this.clear();
			//
			this.status("Initialize");
			this.dispatchEvent( new ClonerEvent( ClonerEvent.INITIALIZE, this, { total:this.data.total } ) );
			
			if ( this.data.autoPositioning && this.data.positionClonesAt == ClonerData.CREATION ) {
				this.applyOffset();
			}
			
			for (var i:int = 0; i < this.data.total; i++) {
				this.createClone();
			}
			this.dispatchEvent( new ClonerEvent( ClonerEvent.COMPLETE, this, { total:this.data.total, children:this._arrClones } ) );
			
			if ( this.data.autoPositioning && this.data.positionClonesAt == ClonerData.COMPLETION ) {
				this.positionClones();
			}
			
			return this._arrClones;
		}
		public function clear($resetPosition:Boolean=true,$resetIndex:Boolean=true,$resetWrapping:Boolean=true):void
		{
			this._numColumn = 0;
			this._numRow = 0;
			//
			if ($resetPosition) {
				this._positionX = 0;
				this._positionY = 0;
			}
			if ($resetIndex) {
				this._index= 0;
			}
			if ($resetWrapping) {
				this._wrapIndex = 0;
			}
			//
			this.destroyClones();
			this._mapClones.clear();
			this._arrClones = new Array;

			this.dispatchEvent(new ClonerEvent(ClonerEvent.CLEAR,this));
			this.status("Cleared");
		}
		
		
		/*
		Destroy Clones
		*/
		private function destroyClones():void
		{
			try {
				var numLength:int = this._arrClones.length;
				for (var i:int =0; i <numLength; i++) {
					this.removeClone( i );
				}
			} catch ($e:Error) {
			}
		}
		public function positionClones():void
		{
			this._calculateMaxSpacing();
			this.applyOffset();
			var numLength:int = this._arrClones.length;
			for (var i:int =0; i <numLength; i++) {
				this._applyProperties( this._arrClones[ i ], this._getPositionProperties( i ) );
			}
		}
		/*
		Clone Functions
		*/
		public function createClone():DisplayObjectContainer
		{
			this._currentClone=new this.data.clone;
			this._mapClones.saveValue( this._index.toString(), this._currentClone );
			this._arrClones.push( this._currentClone );

			this.addChild( this._currentClone );
			if ( this.data.autoPositioning && this.data.positionClonesAt == ClonerData.CREATION ) {
				this._applyProperties( this._currentClone, this._getPositionProperties( this._index ) );
			}

			this.dispatchEvent( new ClonerEvent( ClonerEvent.CREATE, this, { child:this._currentClone, index:this._index } ) );
			this._index++;
			return this._currentClone;
		}
		public function removeClone($identifier:*):void
		{
			var numID:Number;
			var objChild:DisplayObject;
			if ( $identifier is Number ) {
				numID=$identifier;
				objChild = this.removeChild(this.getClone($identifier));
			} else {
				numID=$identifier;
				objChild = this.removeChild($identifier);
			}
			objChild = null;
			this.dispatchEvent(new ClonerEvent(ClonerEvent.REMOVE,this,{id:numID}));
		}
		/*
		
		
		Positioning Property
		
		
		*/
		private function _getPositionProperties( $index:int ):Object
		{
			if ( $index != 0) {
				this._wrapIndex++;
				switch (this.data.pattern) {
					case ClonerData.GRID :
						this._calculateGridProperties( $index );
						break;
					case ClonerData.LINEAR :
						this._calculateLinearProperties( $index );
						break;
					case ClonerData.RANDOM :
						return this._calculateRandomProperties( $index );
						break;
				}
			} else if (this.data.pattern == ClonerData.RANDOM) {
				return this._calculateRandomProperties( $index );
			}
			return { x:this._positionX, y:this._positionY, column:this._numColumn, row:this._numRow, index:$index};
		}
		private function _calculateLinearProperties( $index:int ):void
		{
			switch (this.data.direction) {
				case ClonerData.HORIZONTAL :
					this._positionX += this._getSpacingX( $index );
					break;
				case ClonerData.VERTICAL :
					this._positionY += this._getSpacingY( $index );
					break;
			}
		}
		private function _calculateGridProperties( $index:int ):void
		{
			switch (this.data.direction) {
				case ClonerData.HORIZONTAL :
					this._positionX += this._getSpacingX( $index );
					if ( this._wrapIndex >= this.data.wrap ) {
						this._positionX = 0;
						this._positionY += this._getSpacingY( $index );
						this._wrapIndex = 0;
						this._numRow += 1;
					}
					this._numColumn = this._wrapIndex;
					break;
				case ClonerData.VERTICAL :
					this._positionY += this._getSpacingY( $index );
					if ( this._wrapIndex >= this.data.wrap ) {
						this._positionY = 0;
						this._positionX += this._getSpacingX( $index );
						this._wrapIndex = 0;
						this._numColumn += 1;
					}
					this._numRow = this._wrapIndex;
					break;
			}
		}
		private function _calculateRandomProperties(  $index :int ):Object
		{
			return { x:MathUtil.random( this.data.rangeX ), y:MathUtil.random( this.data.rangeY ), index:$index };
		}
		
		private function _getSpacingX( $index:int ):Number
		{
			if ( !this.data.autoSpacing ) {
				return this.data.spaceX + this.data.paddingX;
			} else {
				switch ( this.data.pattern ) {
					case ClonerData.LINEAR :
						return this.getClone( $index - 1 ).width + this.data.paddingX;
					case ClonerData.GRID :
						if ( this.data.positionClonesAt == ClonerData.COMPLETION ) {
							return this._numMaxSpacingX + this.data.paddingX;
						} else {
							return this.data.spaceX + this.data.paddingX;
						}
				}
			}
			return this.data.spaceX;
		}
		private function _getSpacingY( $index:int ):Number
		{
			if ( !this.data.autoSpacing ) {
				return this.data.spaceY + this.data.paddingY;;
			} else {
				switch ( this.data.pattern ) {
					case ClonerData.LINEAR :
						return this.getClone( $index - 1 ).height + this.data.paddingY;
					case ClonerData.GRID :
						if ( this.data.positionClonesAt == ClonerData.COMPLETION ) {
							return this._numMaxSpacingY + this.data.paddingY;
						} else {
							return this.data.spaceY + this.data.paddingY;
						}
				}
			}
			return this.data.spaceY;
		}
		private function _calculateMaxSpacing():void
		{
			var objClone:DisplayObjectContainer;
			var numLength:int = this._arrClones.length;
			for (var i:int =0; i <numLength; i++) {
				objClone = this._arrClones[ i ];
				if ( objClone.width > this._numMaxSpacingX ) this._numMaxSpacingX = objClone.width;
				if ( objClone.height > this._numMaxSpacingY ) this._numMaxSpacingY = objClone.height;
			}
		}
		
		private function _applyProperties($target:DisplayObjectContainer,$data:Object):void
		{
			var objData:Object = $data;
			try {
				var objClone:IClonable=$target as IClonable;
			} catch ($e:Error) {
				// Is not type of IClonable, cannot apply certain properties.
				delete objData.index;
				delete objData.column;
				delete objData.row;
			} 
			if ( objClone == null ) {
				delete objData.index;
				delete objData.column;
				delete objData.row;
			}
			for (var d:String in objData) {
				$target[ d ]=objData[ d ];
			}
		}
		/*
		
		
		Getters
		
		
		*/
		public function getClone( $index:int ):*
		{
			return this._mapClones.getValue( $index.toString() );
		}

		/*
		
		
		Property Definitions
		
		
		*/
		private function applyOffset():void
		{
			if ( this.data.offsetX != 0 ) this._positionX += this.data.offsetX;
			if ( this.data.offsetY != 0 ) this._positionY += this.data.offsetY;
		}
		/*
		Returns the current index of the movieclip being cloned.
		*/
		public function get index():int
		{
			return this._index;
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
			return this._currentClone;
		}
	
		public function get clones():Array
		{
			return this._arrClones;
		}
		
	}
}