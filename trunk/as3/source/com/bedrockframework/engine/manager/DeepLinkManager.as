
package com.bedrockframework.engine.manager
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.IDeepLinkManager;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.util.DeepLinkUtil;
	import com.bedrockframework.engine.bedrock;
	
	public class DeepLinkManager extends StandardWidget implements IDeepLinkManager
	{
		/*
		Constructor
		*/

		public function initialize():void
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, this.onSWFAddressInit);
			BedrockDispatcher.addEventListener(BedrockEvent.DO_DEFAULT, this.onDoSetup);
			this.enableChangeHandler();
		}
		
		public function clear():void
		{
			BedrockDispatcher.removeEventListener(BedrockEvent.INITIALIZE_COMPLETE, this.onInitializeComplete);
			BedrockDispatcher.removeEventListener(BedrockEvent.SET_QUEUE, this.onPauseChangeHandler);
			SWFAddress.removeEventListener(SWFAddressEvent.INIT, this.onSWFAddressInit);
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, this.onChangeNotification);
		}
		/*
		Set Mode
		*/
		public function setMode($mode:String):void
		{
			switch ($mode.toLowerCase()) {
				case BedrockData.AUTO_DEEP_LINK :
					BedrockDispatcher.addEventListener(BedrockEvent.INITIALIZE_COMPLETE, this.onInitializeComplete);
					BedrockDispatcher.addEventListener(BedrockEvent.SET_QUEUE, this.onPauseChangeHandler);
					break;
				case BedrockData.MANUAL_DEEP_LINK :
					BedrockDispatcher.removeEventListener(BedrockEvent.INITIALIZE_COMPLETE, this.onInitializeComplete);
					BedrockDispatcher.removeEventListener(BedrockEvent.SET_QUEUE, this.onPauseChangeHandler);
					break;
				default :
					this.error("Invalid mode!");
					break;
			}
		}
		/*
		Enable/ Disable Change Event
		*/
		private function enableChangeHandler():void
		{
			this.status("Change handler enabled!")
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.onChangeNotification);
		}
		private function disableChangeHandler():void
		{
			this.status("Change handler disabled!")
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, this.onChangeNotification);
		}
		
		private function getDetailObject():Object
		{
			var objDetails:Object = new Object();
			objDetails.query = DeepLinkUtil.getParameterObject();
			objDetails.paths = DeepLinkUtil.getPathNames();
			return objDetails;
		}
		/*
		Event Handlers
		*/
		private function onDoSetup($event:BedrockEvent):void
		{
			BedrockDispatcher.removeEventListener(BedrockEvent.DO_DEFAULT, this.onDoSetup);
			this.setMode(BedrockData.AUTO_DEEP_LINK);
		}	
		private function onChangeNotification($event:SWFAddressEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.URL_CHANGE,DeepLinkManager, this.getDetailObject()));
		}		
		private function onInitializeComplete($event:BedrockEvent):void
		{
			DeepLinkUtil.clearPath();
			DeepLinkUtil.setPath(BedrockEngine.getInstance().bedrock::pageManager.current.alias);
			SWFAddress.setStatus("Ready");
			this.enableChangeHandler();		
		}
		private function onPauseChangeHandler($event:BedrockEvent):void
		{
			this.disableChangeHandler();
		}
		private function onSWFAddressInit($event:SWFAddressEvent):void
		{
			SWFAddress.removeEventListener(SWFAddressEvent.INIT, this.onSWFAddressInit);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DEEP_LINK_INITIALIZE, this, this.getDetailObject()));
		}
		
	}
}