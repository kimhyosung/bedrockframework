package %%classPackage%%
{
	import com.bedrock.framework.core.event.GenericEvent;

	public class %%className%% extends GenericEvent
	{
		public function %%className%%($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super( $type, $origin, $details, $bubbles, $cancelable );
		}
		
	}
}