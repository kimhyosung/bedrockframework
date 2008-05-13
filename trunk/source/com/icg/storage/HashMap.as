
package com.icg.storage
{
	import flash.utils.Dictionary;
	import com.icg.storage.IMap;
	import com.icg.madagascar.base.BasicWidget;

	public class HashMap extends BasicWidget implements IMap
	{

		private var objDictionary:Dictionary;


		public function HashMap($weakReferences:Boolean = true)
		{
			this.objDictionary = new Dictionary( $weakReferences );
		}
		public function saveValue($key:*, $value:*):void
		{
			this.objDictionary[$key] = $value;
		}
		public function pullValue($key:*):*
		{
			var tmpReturn:* = this.getValue($key);
			this.removeValue($key);
			return tmpReturn;
		}
		public function removeValue($key:*):void
		{
			delete this.objDictionary[$key];
		}
		public function containsKey($key:*):Boolean
		{
			return this.objDictionary[$key] != null;
		}
		public function containsValue($value:*):Boolean
		{
			var bolResult:Boolean;
			for (var k:* in this.objDictionary) {
				if ( this.objDictionary[k] == $value ) {
					bolResult = true;
					break;
				}
			}
			return bolResult;
		}
		public function getKey($value:*):String
		{
			var strID:String = null;

			for (var k:* in this.objDictionary) {
				if ( this.objDictionary[k] == $value ) {
					strID = k;
					break;
				}
			}
			return strID;
		}
		public function getKeys():Array
		{
			var arrKeys:Array = [];

			for (var k:* in this.objDictionary) {
				arrKeys.push(k);
			}
			return arrKeys;
		}
		public function getValue($key:*):*
		{
			if (this.containsKey($key)) {
				return this.objDictionary[$key];
			}
		}
		public function getValues():Array
		{
			var arrValues:Array = [];

			for (var k:* in this.objDictionary) {
				arrValues.push( this.objDictionary[k] );
			}
			return arrValues;
		}

		public function get size():int
		{
			var numLength:int = 0;

			for (var k:* in this.objDictionary) {
				numLength++;
			}
			return numLength;
		}
		
		public function isEmpty():Boolean
		{
			return this.size <= 0;
		}
		public function reset():void
		{
			for (var k:* in this.objDictionary) {
				this.objDictionary[k] = null;
			}
		}
		public function resetAllExcept($key:*):void
		{
			for (var k:* in this.objDictionary) {
				if ( k != $key ) {
					this.objDictionary[k] = null;
				}
			}
		}
		public function clear():void
		{
			for (var k:* in this.objDictionary) {
				this.removeValue(k);
			}
		}
		public function clearAllExcept($key:*):void
		{
			for (var k:* in this.objDictionary) {
				if ( k != $key ) {
					this.removeValue( k );
				}
			}
		}
	}
}