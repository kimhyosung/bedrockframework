package com.bedrockframework.engine.model
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;

	public class Queue extends StaticWidget
	{
		private static var __objCurrent:Object;
		private static var __objPrevious:Object;
		/*
		* Constructor
		*/
		Logger.log(Queue, LogLevel.CONSTRUCTOR, "Constructed");
		/*
		Set Queue
		*/
		public static function setQueue($page:Object):Boolean
		{
			var bolFirstRun:Boolean = (Queue.__objCurrent == null);
			var objPage:Object = $page;
			if (objPage != null) {
				if (objPage != Queue.__objCurrent) {
					Queue.__objPrevious = Queue.__objCurrent;
					Queue.__objCurrent=objPage;
				} else {
					Logger.warning(Queue, "Page already in queue!");
				}
			}
			return bolFirstRun;
		}
		/*
		Load Queue
		*/
		public static function getQueue():Object
		{
			var objTemp:Object=Queue.current;
			if (objTemp == null) {
				Logger.warning(Queue, "Queue is empty!");
			}
			return objTemp;
		}
		/*
		Clear Queue
		*/
		public static function clearQueue():void
		{
			Queue.__objCurrent=null;
			Queue.__objPrevious=null;
		}
		/*
		Get Current Queue
		*/
		public static function get current():Object
		{
			return Queue.__objCurrent;
		}
		/*
		Get Previous Queue
		*/
		public static function get previous():Object
		{
			return Queue.__objPrevious;
		}
		
	}
}