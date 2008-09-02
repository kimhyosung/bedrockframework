package 
{
	import com.builtonbedrock.bedrock.base.StandardWidget;

	public class SingletonTemplate extends StandardWidget
	{
		/*
		Variable Declarations
		*/
		private static var OBJ_INSTANCE:SingletonTemplate;
		/*
		Constructor
		*/
		public function SingletonTemplate($enforcer:SingletonEnforcer)
		{
		
		}
		public static function getInstance():SingletonTemplate
		{
			if (OBJ_INSTANCE == null) {
				OBJ_INSTANCE = new SingletonTemplate(new SingletonEnforcer());
			}
			return OBJ_INSTANCE;
		}
	}
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}