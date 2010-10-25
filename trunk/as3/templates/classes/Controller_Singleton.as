package %%classPackage%%
{
	import com.bedrockframework.core.base.BasicWidget;
	
	public class %%className%% extends BasicWidget
	{
		/*
		Variable Declarations
		*/
		private static var __objInstance:%%className%%;
		/*
		Constructor
		*/
		public function %%className%%( $singletonEnforcer:SingletonEnforcer )
		{
		}
		public static function getInstance():%%className%%
		{
			if (%%className%%.__objInstance == null) {
				%%className%%.__objInstance = new %%className%%( new SingletonEnforcer );
			}
			return %%className%%.__objInstance;
		}
		
		public function initialize():void
		{
		}
		/*
		Creation Functions
	 	*/
	 	
	 	
	 	/*
	 	Property Definitions
	 	*/
	
	}
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}