package com.autumntactics.bedrock.logging
{
	import com.autumntactics.bedrock.dispatcher.BedrockDispatcher;
	import com.autumntactics.bedrock.events.LogEvent;
	import com.autumntactics.storage.SimpleMap;

	public class EventLogger implements ILogger
	{
		private var objCategoryHash:SimpleMap;
		
		public function EventLogger()
		{
			this.createCategoryLabels();
		}
		
		private function createCategoryLabels():void
		{
			this.objCategoryHash = new SimpleMap;
			this.objCategoryHash.saveValue(LogLevel.CONSTRUCTOR.toString(), LogEvent.CONSTRUCTOR);
			this.objCategoryHash.saveValue(LogLevel.DEBUG.toString(), LogEvent.DEBUG);
			this.objCategoryHash.saveValue(LogLevel.ERROR.toString(),  LogEvent.ERROR);
			this.objCategoryHash.saveValue(LogLevel.FATAL.toString(), LogEvent.FATAL);
			this.objCategoryHash.saveValue(LogLevel.STATUS.toString(), LogEvent.INFO);
			this.objCategoryHash.saveValue(LogLevel.WARNING.toString(), LogEvent.WARNING);
		}
		
		
		public function log($target:*, $category:int, $message:String):void
		{
			BedrockDispatcher.dispatchEvent(new LogEvent(this.objCategoryHash.getValue($category.toString()), $target, {message:$message}));
		}
		
	}
}