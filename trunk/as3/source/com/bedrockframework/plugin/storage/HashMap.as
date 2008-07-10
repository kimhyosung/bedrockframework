
package com.bedrockframework.plugin.storage
{
	import flash.utils.Dictionary;
	import com.bedrockframework.plugin.storage.IMap;

	public class HashMap implements IMap
	{

		private var _objDictionary:Dictionary;


		public function HashMap($weakReferences:Boolean = true)
		{
			this._objDictionary = new Dictionary( $weakReferences );
		}
		public function saveValue($key:*, $value:*):void
		{
			this._objDictionary[$key] = $value;
		}
		public function pullValue($key:*):*
		{
			var tmpReturn:* = this.getValue($key);
			this.removeValue($key);
			return tmpReturn;
		}
		public function removeValue($key:*):void
		{
			delete this._objDictionary[$key];
		}
		public function containsKey($key:*):Boolean
		{
			return this._objDictionary[$key] != null;
		}
		public function containsValue($value:*):Boolean
		{
			var bolResult:Boolean = false;
			for (var k:* in this._objDictionary) {
				if ( this._objDictionary[k] == $value ) {
					bolResult = true;
					break;
				}
			}
			return bolResult;
		}
		public function getKey($value:*):String
		{
			var strID:String = null;

			for (var k:* in this._objDictionary) {
				if ( this._objDictionary[k] == $value ) {
					strID = k;
					break;
				}
			}
			return strID;
		}
		public function getKeys():Array
		{
			var arrKeys:Array = [];

			for (var k:* in this._objDictionary) {
				arrKeys.push(k);
			}
			return arrKeys;
		}
		public function getValue($key:*):*
		{
			if (this.containsKey($key)) {
				return this._objDictionary[$key];
			}
		}
		public function getValues():Array
		{
			var arrValues:Array = [];

			for (var k:* in this._objDictionary) {
				arrValues.push( this._objDictionary[k] );
			}
			return arrValues;
		}

		public function get size():int
		{
			var numLength:int = 0;

			for (var k:* in this._objDictionary) {
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
			for (var k:* in this._objDictionary) {
				this._objDictionary[k] = null;
			}
		}
		public function resetAllExcept($key:*):void
		{
			for (var k:* in this._objDictionary) {
				if ( k != $key ) {
					this._objDictionary[k] = null;
				}
			}
		}
		public function clear():void
		{
			for (var k:* in this._objDictionary) {
				this.removeValue(k);
			}
		}
		public function clearAllExcept($key:*):void
		{
			for (var k:* in this._objDictionary) {
				if ( k != $key ) {
					this.removeValue( k );
				}
			}
		}
	}
}