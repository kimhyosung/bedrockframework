import flash.display.BitmapData;
class com.bedrockframework.plugin.util.BitmapUtil extends icg.base.StaticWidget {
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "BitmapUtil";
	/*
	Pass in a movieclip and receive an instance of BitmapData.
	*/
	public static function createBitmap($clip:MovieClip, $width:Number, $height:Number, $transparency:Boolean):BitmapData {
		var numWidth:Number = $width || $clip._width;
		var numHeight:Number = $height || $clip._height;
		var bolTransparency:Boolean = ($transparency != undefined) ? $transparency : true;
		var objBitmapData:BitmapData = new BitmapData(numWidth, numHeight, bolTransparency);
		objBitmapData.draw($clip);
		return objBitmapData;
	}
}
