
package com.bedrockframework.engine.manager
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.model.Queue;
	import com.bedrockframework.plugin.util.DeepLinkUtil;
	
	public class DeepLinkManager extends StaticWidget
	{
		/*
		Constructor
		*/
		Logger.log(DeepLinkManager, LogLevel.CONSTRUCTOR, "Constructed");

		public static function initialize():void
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, DeepLinkManager.onSWFAddressInit);
			BedrockDispatcher.addEventListener(BedrockEvent.DO_DEFAULT, DeepLinkManager.onDoSetup);
			DeepLinkManager.enableChangeHandler();
		}
		
		public static function clear():void
		{
			BedrockDispatcher.removeEventListener(BedrockEvent.INITIALIZE_COMPLETE, DeepLinkManager.onInitializeComplete);
			BedrockDispatcher.removeEventListener(BedrockEvent.SET_QUEUE, DeepLinkManager.onPauseChangeHandler);
			SWFAddress.removeEventListener(SWFAddressEvent.INIT, DeepLinkManager.onSWFAddressInit);
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, DeepLinkManager.onChangeNotification);
		}
		/*
		Set Mode
		*/
		public static function setMode($mode:String):void
		{
			switch ($mode.toLowerCase()) {
				case BedrockData.AUTO_DEEP_LINK :
					BedrockDispatcher.addEventListener(BedrockEvent.INITIALIZE_COMPLETE, DeepLinkManager.onInitializeComplete);
					BedrockDispatcher.addEventListener(BedrockEvent.SET_QUEUE, DeepLinkManager.onPauseChangeHandler);
					break;
				case BedrockData.MANUAL_DEEP_LINK :
					BedrockDispatcher.removeEventListener(BedrockEvent.INITIALIZE_COMPLETE, DeepLinkManager.onInitializeComplete);
					BedrockDispatcher.removeEventListener(BedrockEvent.SET_QUEUE, DeepLinkManager.onPauseChangeHandler);
					break;
				default :
					Logger.error(DeepLinkManager, "Invalid mode!");
					break;
			}
		}
		/*
		Enable/ Disable Change Event
		*/
		private static function enableChangeHandler()
		{
			Logger.status(DeepLinkManager, "Change handler enabled!")
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, DeepLinkManager.onChangeNotification);
		}
		private static function disableChangeHandler()
		{
			Logger.status(DeepLinkManager, "Change handler disabled!")
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, DeepLinkManager.onChangeNotification);
		}
		
		private static function getDetailObject():Object
		{
			var objDetails:Object = new Object();
			objDetails.query = DeepLinkUtil.getParameterObject();
			objDetails.paths = DeepLinkUtil.getPathNames();
			return objDetails;
		}
		/*
		Event Handlers
		*/
		private static function onDoSetup($event:BedrockEvent):void
		{
			BedrockDispatcher.removeEventListener(BedrockEvent.DO_DEFAULT, DeepLinkManager.onDoSetup);
			DeepLinkManager.setMode(BedrockData.AUTO_DEEP_LINK);
		}	
		private static function onChangeNotification($event:SWFAddressEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.URL_CHANGE,DeepLinkManager, DeepLinkManager.getDetailObject()));
		}		
		private static function onInitializeComplete($event:BedrockEvent):void
		{
			DeepLinkUtil.clearPath();
			DeepLinkUtil.setPath(Queue.current.alias);
			SWFAddress.setStatus("Ready");
			DeepLinkManager.enableChangeHandler();		
		}
		private static function onPauseChangeHandler($event:BedrockEvent):void
		{
			DeepLinkManager.disableChangeHandler();
		}
		private static function onSWFAddressInit($event:SWFAddressEvent):void
		{
			SWFAddress.removeEventListener(SWFAddressEvent.INIT, DeepLinkManager.onSWFAddressInit);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DEEP_LINK_INITIALIZE, DeepLinkManager,DeepLinkManager.getDetailObject()));
		}
		
	}
}