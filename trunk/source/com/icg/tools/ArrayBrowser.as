package com.icg.tools
{
	import com.icg.madagascar.base.BasicWidget;
	public class ArrayBrowser extends BasicWidget
	{
		import com.icg.util.MathUtil;
		import com.icg.util.ArrayUtil;
		/*
		Variable Declarations
		*/
		private var arrData:Array;
		private var numSelectedIndex:Number;
		private var bolWrapIndex:Boolean;
		/*
		Constructor
		*/
		public function ArrayBrowser($data:Array = null)
		{
			this.data = $data;
			this.bolWrapIndex=false;
			this.reset();
		}
		/*
		Reset Selections
		*/
		public function reset():void
		{
			this.numSelectedIndex = 0;
		}
		/*
		Has more items
		*/
		public function hasNext():Boolean
		{
			if (this.bolWrapIndex) {			
				return true;
			}
			if ((this.numSelectedIndex + 1)  >= this.arrData.length) {
				return false;
				}else{
				return true;
			}			
		}
		public function hasPrevious():Boolean
		{
			if (this.bolWrapIndex) {			
				return true;
			}
			if ((this.numSelectedIndex - 1)  < 0) {
				return false;
				}else{
				return true;
			}	
		}
		/*
		Increment selected index
		*/
		public function selectNext():*
		{
			return this.setSelected(this.numSelectedIndex + 1);
		}
		/*
		Decrement selected index
		*/
		public function selectPrevious():*
		{
			return this.setSelected(this.numSelectedIndex - 1);
		}
		/*
		Select current index
		*/
		public function setSelected($index:Number):*
		{
			//check for wrapping
			var numLength:Number=this.arrData.length;
			this.numSelectedIndex=MathUtil.wrapIndex($index,numLength,this.bolWrapIndex);
			return this.getSelected();
		}
		/*
		Return selected item from the array
		*/
		public function getSelected():*
		{
			return this.getItemAt(this.numSelectedIndex);
		}
		/*
		Get random items based on a total
		*/
		public function getRandomItems($total:Number)
		{
			if (this.arrData.length > 0) {
				return ArrayUtil.getRandomItems(this.arrData,$total);
			}
		}
		/*
		Select a random item in the array
		*/
		public function selectRandom()
		{
			if (this.arrData.length > 0) {
				return this.setSelected(ArrayUtil.randomIndex(this.numSelectedIndex,this.arrData.length));
			}
		}
		/*
		Return item at location
		*/
		public function getItemAt($location:Number):*
		{
			if (this.bolWrapIndex){
				return this.arrData[MathUtil.wrapIndex($location, this.arrData.length, true)];
			}else{
				try{
					return this.arrData[$location];
				} catch($error:Error){
					return null
				}					
			}		
		}
		/*
		Get object properties from array
		*/
		public function getProperties($property:String):Array
		{
			var numLength:Number=this.arrData.length;
			var arrReturn:Array=new Array;
			for (var i=0; i < numLength; i++) {
				arrReturn.push(this.arrData[i][$property]);
			}
			return arrReturn;
		}
		/*
		Search: Returns array with results
		*/
		public function search($value:*,$field:String=null):Array
		{
			return ArrayUtil.search(this.arrData,$value,$field);
		}
		/*
		Search: Returns Single Index
		*/
		public function findIndex($value:*,$field:String=null):Number
		{
			return ArrayUtil.findIndex(this.arrData,$value,$field);
		}
		/*
		Search: Returns Single Item
		*/
		public function findItem($value:*,$field:String=null):*
		{
			return ArrayUtil.findItem(this.arrData,$value,$field);
		}
		/*
		Search: Finds a string within a field
		*/
		public function findContaining($value:*,$field:String=null):*
		{
			return ArrayUtil.findContaining(this.arrData,$value,$field);
		}
		/*
		Search: Returns true or false wether a value exists or not
		*/
		public function containsItem($value:*,$field:String=null):Boolean
		{
			return ArrayUtil.containsItem(this.arrData,$value,$field);
		}
		/*
		Search: Selects and Returns a Single Item
		*/
		public function findAndSelect($value:*,$field:String=null)
		{
			return this.setSelected(ArrayUtil.findIndex(this.arrData,$value,$field));
		}
		/*
		Search for and remove an item from an array
		*/
		public function searchAndRemove($value:*,$field:String=null):Array
		{
			return ArrayUtil.searchAndRemove(this.arrData,$value,$field);;
		}
		/*
		Set/ Get data
		*/
		public function set data($data:Array):void
		{
			this.arrData = $data;
			this.reset();
		}
		public function get data():Array
		{
			return this.arrData;
		}
		/*
		Set the wrapping properties of the array
		*/
		public function set wrapIndex($status:Boolean)
		{
			this.bolWrapIndex=$status;
		}
		public function get wrapIndex():Boolean
		{
			return this.bolWrapIndex;
		}
		/*
		Return selected item from the array
		*/
		public function get selectedIndex():Number
		{
			return this.numSelectedIndex;
		}
		public function get selectedItem():*
		{
			return this.getSelected();
		}
	}
}