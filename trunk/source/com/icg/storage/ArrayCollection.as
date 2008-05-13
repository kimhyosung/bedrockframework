package com.icg.storage
{

	public dynamic class ArrayCollection extends Array
	{
		import com.icg.util.MathUtil;
		import com.icg.util.ArrayUtil;
		import com.icg.util.ClassUtil;
		/*
		Variable Definitions
		*/
		private var numLimit:Number;
		private var strClassName:String;
		private var bolAllowDuplicates:Boolean;
		/*
		Constructor
		*/
		public function ArrayCollection()
		{
			this.strClassName=ClassUtil.getDisplayClassName(this);
			this.numLimit=0;
			this.bolAllowDuplicates=true;
		}
		/*
		Return Requested Item
		*/
		public function getItemAt($location:Number):*
		{
			var numIndex:Number = MathUtil.wrapIndex($location, this.length, false);
			try {
				return this[$location];
			} catch ($error:Error) {
				return null;
			}
		}
		/*
		*/
		public function clear():void
		{
			var numLength:Number=this.length;
			for (var i=0; i < numLength; i++) {
				this.pop();
			}
		}
		/*
		Loop through an array pushing each item in
		*/
		public function automaticPush($array:Array)
		{
			var numLength:Number=$array.length;
			for (var i=0; i < numLength; i++) {
				this.push($array[i]);
			}
		}
		/*
		Loop through an array unshift each item in
		*/
		public function automaticUnshift($array:Array)
		{
			var numLength:Number=$array.length;
			for (var i=0; i < numLength; i++) {
				this.unshift($array[i]);
			}
		}
		/*
		Wrappers 
		*/
		public function limitedPush():void
		{
			this.push(arguments);
			if (this.numLimit != 0) {
				if (this.length > this.numLimit) {
					var numLoop:Number=Math.abs(this.length - this.numLimit);
					for (var i=0; i < numLoop; i++) {
						this.shift();
					}
				}
			}
		}
		public function limitedUnshift():void
		{
			this.unshift(arguments);
			if (this.numLimit != 0) {
				if (this.length > this.numLimit) {
					var numLoop:Number=Math.abs(this.length - this.numLimit);
					for (var i=0; i < numLoop; i++) {
						this.pop();
					}
				}
			}
		}
		/*
		Returns a copy of the array
		*/
		public function duplicate():Array
		{
			return ArrayUtil.duplicate(this);
		}
		/*
		Insert new data at index
		*/
		public function insert($location:Number,$item):Array
		{
			return ArrayUtil.insert(this,$location,$item);
		}
		/*
		Move item to a different location
		*/
		public function move($index:Number,$location:Number):Array
		{
			return ArrayUtil.move(this,$index,$location);
		}
		/*
		Remove item at index
		*/
		public function remove($index:Number)
		{
			return ArrayUtil.remove(this,$index);
		}
		public function findAndRemove($value:*,$field:String=null):*
		{
			var numIndex:Number=ArrayUtil.findIndex(this,$value,$field);
			return ArrayUtil.remove(this,numIndex);
		}
		public function search($value,$field:String):Array
		{
			return ArrayUtil.search(this,$value,$field);
		}
		/*
		
		
		Property Definitions
		
		
		*/

		/*
		Set the limit for the number if items that should be in the array
		*/
		public function set itemLimit($limit:Number)
		{
			this.numLimit=$limit;
		}
		public function get itemLimit():Number
		{
			return this.numLimit;
		}
		/*
		Return the last index from the array
		*/
		public function get lastIndex():Number
		{
			return (this.length - 1);
		}
		/*
		Allow for duplicate entries
		*/
		public function set allowDuplicates($status:Boolean):void
		{
			this.bolAllowDuplicates=$status;
		}
		public function get allowDuplicates():Boolean
		{
			return this.bolAllowDuplicates;
		}
		/*
		Return selected item from the array
		*/
		public function toString():String
		{
			return this.strClassName + " : " + this.join(",");
		}
	}
}