﻿
class com.TestEvent extends com.bedrockframework.core.event.GenericEvent
{
	/*
	Event Declarations
	*/
	public static var TEST:String = "TestEvent.onTest";
	
	
	
	public function TestEvent($type:String, $target:Object, $details:Object)
	{
		super($type, $target, $details);
	}
}
