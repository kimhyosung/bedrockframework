package %%classPackage%%
{
	import com.bedrock.framework.core.base.StandardBase;
	
	public class %%className%% extends StandardBase
	{
		/*
		Variable Declarations
		*/
		private static var __instance:%%className%%;
		/*
		Constructor
		*/
		public function %%className%%( $singletonEnforcer:SingletonEnforcer )
		{
		}
		public static function getInstance():%%className%%
		{
			if (%%className%%.__instance == null) {
				%%className%%.__instance = new %%className%%( new SingletonEnforcer );
			}
			return %%className%%.__instance;
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