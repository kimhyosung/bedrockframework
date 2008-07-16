package com.bedrockframework.core.event
{
	import com.bedrockframework.core.event.GenericEvent;

	public class LogEvent extends GenericEvent
	{
		
		public static const FATAL:String = "LogEvent.onFatal";
	    public static const ERROR:String = "LogEvent.onError";
	    public static const WARNING:String = "LogEvent.onWarning";
	    public static const DEBUG:String = "LogEvent.onDebug";
	    public static const STATUS:String = "LogEvent.onStatus";	
	    public static const CONSTRUCTOR:String = "LogEvent.onConstructor";	
		
		
		public function LogEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
		
	}
}