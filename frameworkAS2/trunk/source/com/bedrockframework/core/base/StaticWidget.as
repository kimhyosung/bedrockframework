class com.bedrockframework.core.base.StaticWidget
{
	/*
	Variable Definitions
	*/
	private var _strClassName:String="StaticWidget";
	/*
	Constructor
	*/
	public function StaticWidget()
	{
		throw new Error("Cannot instantiate static class " + this._strClassName + "!");
	}
}