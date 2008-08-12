class com.bedrockframework.plugin.data.ClonerData
{
	
	public static var HORIZONTAL:String = "horizontal";
	public static var VERTICAL:String = "vertical";
	public static var LINEAR:String = "linear";
	public static var GRID:String = "grid";
	public static var RANDOM:String = "random";

	public var spaceX:Number;
	public var spaceY:Number;
	public var offset:Number;
	public var rangeX:Number;
	public var rangeY:Number;
	public var wrap:Number;
	public var total:Number;
	
	public var direction:String;
	public var pattern:String;

	public function ClonerData()
	{
		this.wrap = 0;
		this.total = 0;
	}


}