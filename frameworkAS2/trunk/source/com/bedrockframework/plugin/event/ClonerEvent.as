class com.bedrockframework.plugin.event.ClonerEvent extends com.bedrockframework.core.event.GenericEvent
	{
		public static var INITIALIZE:String = "ClonerEvent.onInitialize";
		public static var CREATE:String = "ClonerEvent.onCreate";
		public static var REMOVE:String = "ClonerEvent.onRemove";		
		public static var COMPLETE:String = "ClonerEvent.onComplete";		
		public static var CLEAR:String = "ClonerEvent.onClear";
		

		public function ClonerEvent($type:String, $origin:Object, $details:Object)
		{
			super($type, $origin, $details);
		}
	}