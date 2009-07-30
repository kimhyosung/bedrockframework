class com.bedrockframework.plugin.storage.HashMap
{
	/*
	Variable Declarations
	*/
	private var _objData:Object;
	/*
	Constructor
	*/
	public function HashMap()
	{
		this._objData = new Object();
	}
	public function saveValue($key, $value):Void
	{
		this._objData[$key] = $value;
	}
	public function pullValue($key)
	{
		var tmpReturn = this.getValue($key);
		this.removeValue($key);
		return tmpReturn;
	}
	public function removeValue($key):Void
	{
		delete this._objData[$key];
	}
	public function containsKey($key):Boolean
	{
		return this._objData[$key] != null;
	}
	public function containsValue($value):Boolean
	{
		var bolResult:Boolean = false;
		for (var k in this._objData) {
			if (this._objData[k] == $value) {
				bolResult = true;
				break;
			}
		}
		return bolResult;
	}
	public function getKey($value):String
	{
		var strID:String = null;

		for (var k in this._objData) {
			if (this._objData[k] == $value) {
				strID = k;
				break;
			}
		}
		return strID;
	}
	public function getKeys():Array
	{
		var arrKeys:Array = [];

		for (var k in this._objData) {
			arrKeys.push(k);
		}
		return arrKeys;
	}
	public function getValue($key)
	{
		if (this.containsKey($key)) {
			return this._objData[$key];
		}
	}
	public function getValues():Array
	{
		var arrValues:Array = [];

		for (var k in this._objData) {
			arrValues.push(this._objData[k]);
		}
		return arrValues;
	}

	public function reset():Void
	{
		for (var k in this._objData) {
			this._objData[k] = null;
		}
	}
	public function resetAllExcept($key):Void
	{
		for (var k in this._objData) {
			if (k != $key) {
				this._objData[k] = null;
			}
		}
	}
	public function clear():Void
	{
		for (var k in this._objData) {
			this.removeValue(k);
		}
	}
	public function clearAllExcept($key):Void
	{
		for (var k in this._objData) {
			if (k != $key) {
				this.removeValue(k);
			}
		}
	}

	public function isEmpty():Boolean
	{
		return this.size<=0;
	}
	/*
	Property Definitions
	 */
	public function get size():Number
	{
		var numLength:Number = 0;

		for (var k in this._objData) {
			numLength++;
		}
		return numLength;
	}
}