class com.bedrockframework.plugin.util.ArrayUtil extends com.bedrockframework.core.base.StaticWidget
{
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "ArrayUtil";
	/*
	Search: Returns Index
	*/
	public static function findIndex($array:Array, $value, $field:String)
	{
		if ($field == undefined) {
			for (var i:Number = 0; i < $array.length; i++) {
				if ($array[i] == $value) {
					return i;
				}
			}
		} else {
			for (var i:Number = 0; i < $array.length; i++) {
				if ($array[i][$field] == $value) {
					return i;
				}
			}
		}
		return -1;
	}
	/*
	Search: Returns Index
	*/
	public static function getIndex($array:Array, $value, $field:String):Number
	{
		return findIndex($array, $value, $field);
	}
	/*
	Search: Returns Single Item
	*/
	public static function findItem($array:Array, $value, $field:String)
	{
		if ($field == undefined) {
			for (var i:Number = 0; i < $array.length; i++) {
				if ($array[i] == $value) {
					return $array[i];
				}
			}
		} else {
			for (var i:Number = 0; i < $array.length; i++) {
				if ($array[i][$field] == $value) {
					return $array[i];
				}
			}
		}
		return;
	}
	/*
	Search: Returns Single Item
	*/
	static function getItem($array:Array, $value, $field:String)
	{
		return findItem($array, $value, $field);
	}
	/*
	Search: Returns New Array
	*/
	public static function search($array:Array, $value, $field:String)
	{
		return doSearch($array, $value, $field);
	}
	/*
	Search: Returns New Array
	*/
	public static function doSearch($array:Array, $value, $field:String)
	{
		var arrResults:Array = new Array();
		if ($field == undefined) {
			for (var i:Number = 0; i < $array.length; i++) {
				if ($array[i] == $value) {
					arrResults.push($array[i]);
				}
			}
		} else {
			for (var i:Number = 0; i < $array.length; i++) {
				if ($array[i][$field] == $value) {
					arrResults.push($array[i]);
				}
			}
		}
		return arrResults;
	}
	/*
	Search for and remove an item from an array
	*/
	public static function searchAndRemove($array:Array, $value, $field:String)
	{
		var arrResults:Array = new Array();
		var numLength:Number = $array.length;
		if ($field == undefined) {
			for (var i:Number = numLength; i > -1; i--) {
				if ($array[i] == $value) {
					var objTemp = $array.splice(i, 1);
					arrResults.push(objTemp[0]);
				}
			}
		} else {
			for (var i:Number = numLength; i > -1; i--) {
				if ($array[i][$field] == $value) {
					var objTemp = $array.splice(i, 1);
					arrResults.push(objTemp[0]);
				}
			}
		}
		return arrResults;
	}
	/*
	Divides an array into several smalled arrays
	*/
	public static function segment($array:Array, $count:Number):Array
	{
		var arrOutput:Array = new Array();
		var numItems:Number = $count;
		var numGroups:Number = Math.ceil($array.length / numItems);
		for (var i = 0; i < numGroups; i++) {
			var numStartIndex:Number = (numItems * i);
			var numEndIndex:Number = ((numItems * i) + numItems);
			var arrResult:Array = $array.slice(numStartIndex, numEndIndex);
			arrOutput.push(arrResult);
		}
		return arrOutput;
	}
	/*
	Output Random Number from Array
	*/
	public static function randomIndex($current:Number, $total:Number)
	{
		var numTemp:Number = $current;
		do {
			numTemp = random($total);
		} while (numTemp == $current);
		return numTemp;
	}
	/*
	Insert new data at location
	*/
	public static function insert($array:Array, $location:Number, $item)
	{
		$array.splice($location,0,$item);
		return $array;
	}
	/*
	Move item to a different location
	*/
	public static function move($array:Array, $index:Number, $location:Number):Array
	{
		var arrTemp:Array = $array;
		var objItem = remove(arrTemp, $index);
		insert($array,$location,objItem);
		return $array;
	}
	/*
	Remove data from index
	*/
	public static function remove($array:Array, $index:Number)
	{
		var item = $array.splice($index, 1);
		return item[0];
	}
	/*
	Duplicate Array
	*/
	public static function duplicate($array:Array):Array
	{
		return $array.concat();
	}
	/*
	Get random items based on a total
	*/
	public static function getRandomItems($array:Array, $total:Number)
	{
		var arrTemp:Array = duplicate($array);
		var arrNewItems:Array = new Array();
		//
		arrTemp = arrTemp.concat();
		for (var i = 0; i < $total; i++) {
			var numLength:Number = arrTemp.length;
			var objPackage:Object = remove(arrTemp, random(numLength));
			arrNewItems.push(objPackage);
		}
		return arrNewItems;
	}
	

}