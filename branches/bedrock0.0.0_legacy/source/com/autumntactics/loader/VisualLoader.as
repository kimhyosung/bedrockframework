package com.builtonbedrock.loader
{
	import com.builtonbedrock.bedrock.logging.Logger;
	import com.builtonbedrock.bedrock.output.OutputManager;
	import com.builtonbedrock.events.LoaderEvent;
	import com.builtonbedrock.gadget.IClonable;
	import com.builtonbedrock.storage.SimpleMap;
	import com.builtonbedrock.util.ClassUtil;
	import com.builtonbedrock.util.MathUtil;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class VisualLoader extends Loader implements IClonable
	{
		public static var cachePrevention:Boolean = false;
		public static var cacheKey:String = "";
		
		private var objURLRequest:URLRequest;
		private static  var OBJ_REPLACEMENTS:SimpleMap;		
		private var numID:int;
		private var numRow:int;
		private var numColumn:int;
		private var strURL:String;

		VisualLoader.setupReplacements();
		
		public function VisualLoader($url:String = null)
		{
			
			//OutputManager.send("Constructed", "constructor", ClassUtil.getDisplayClassName(this));
			this.setupListeners(this.contentLoaderInfo);
			if ($url != null) {
				this.loadURL($url);
			}
		}
		private static function setupReplacements():void
		{
			var arrStandardEvents:Array = new Array(Event.COMPLETE, Event.OPEN, Event.INIT, Event.UNLOAD, HTTPStatusEvent.HTTP_STATUS, ProgressEvent.PROGRESS, IOErrorEvent.IO_ERROR, SecurityErrorEvent.SECURITY_ERROR);
			var arrLoaderEvents:Array=new Array("COMPLETE","OPEN","INIT","UNLOAD", "HTTP_STATUS", "PROGRESS", "IO_ERROR", "SECURITY_ERROR" );
			OBJ_REPLACEMENTS=new SimpleMap  ;
			//
			var numLength:Number=arrStandardEvents.length;
			for (var i:Number=0; i < numLength; i++) {
				OBJ_REPLACEMENTS.saveValue(arrStandardEvents[i],LoaderEvent[arrLoaderEvents[i]]);
			}
			
		}
		public function setupListeners($loaderInfo:LoaderInfo)
		{
			$loaderInfo.addEventListener(Event.COMPLETE, this.dispatchEvent);
			$loaderInfo.addEventListener(Event.OPEN, this.dispatchEvent);
			$loaderInfo.addEventListener(Event.INIT, this.dispatchEvent);
			$loaderInfo.addEventListener(Event.UNLOAD, this.dispatchEvent);
			$loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.dispatchEvent);
			$loaderInfo.addEventListener(ProgressEvent.PROGRESS, this.dispatchEvent);
			
			$loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
			$loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
			$loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchEvent);
			$loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
		}
		public function loadURL($url:String, $context:LoaderContext = null):void
		{
			this.strURL = $url;
			this.objURLRequest=new URLRequest(this.getURL(this.strURL));
			try {
				this.load(this.objURLRequest, $context);
			} catch (error:Error) {
				Logger.warning(this, "Unable to load " + this.strURL + "!");
			}
		}
		
		private function getURL($url:String):String
		{
			if (BackgroundLoader.cachePrevention) {
				return this.strURL + "cache=" + BackgroundLoader.cacheKey;
			} else {
				return this.strURL;
			}
		}
		
		override public  function addEventListener($type:String,$listener:Function,$capture:Boolean=false,$priority:int=0,$weak:Boolean=true):void
		{
			super.addEventListener($type,$listener,$capture,$priority,$weak);
		}
		override public function dispatchEvent($event:Event):Boolean
		{
			return super.dispatchEvent(this.recastEvent($event));
		}
		private function recastEvent($event:*):Event
		{
			var objDetails:Object=new Object;
			switch ($event.type) {
				case Event.COMPLETE :
					objDetails.bytesLoaded=this.contentLoaderInfo.bytesLoaded;
					objDetails.bytesTotal=this.contentLoaderInfo.bytesTotal;
					objDetails.contentType=this.contentLoaderInfo.contentType;
					objDetails.url=this.strURL;
					break;
				case Event.OPEN : 
					objDetails.url=this.strURL;
					break;
				case Event.INIT :
					objDetails.url=this.strURL;
					objDetails.contentType=this.contentLoaderInfo.contentType;
					break;
				case Event.UNLOAD :
					objDetails.url=this.strURL;
					break;
				case HTTPStatusEvent.HTTP_STATUS :
					objDetails.status=HTTPStatusEvent($event).status;
					break;
				case ProgressEvent.PROGRESS :
					objDetails.bytesLoaded=ProgressEvent($event).bytesLoaded;
					objDetails.bytesTotal=ProgressEvent($event).bytesTotal;
					objDetails.percent=MathUtil.calculatePercentage(objDetails.bytesLoaded,objDetails.bytesTotal);
					break;
				case IOErrorEvent.IO_ERROR :
					objDetails.text=IOErrorEvent($event).text;
					break;
				case SecurityErrorEvent.SECURITY_ERROR :
					objDetails.text=SecurityErrorEvent($event).text;
					break;
			}
			return new LoaderEvent(VisualLoader.OBJ_REPLACEMENTS.getValue($event.type),this,objDetails);
		}
		/*
		Event Handlers
		*/
		private function onIOError($event:IOErrorEvent):void
		{
			Logger.warning(this, $event.text);
		}
		private function onSecurityError($event:IOErrorEvent):void
		{
			Logger.warning(this, $event.text);
		}
		/*
		Property Definitions
		*/
		public function get request():URLRequest
		{
			return this.objURLRequest;
		}
		public function set id($id:int):void
		{
			this.numID = $id;
		}
		public function get id():int
		{
			return this.numID;
		}
		public function set row($row:int):void
		{
			this.numRow = $row;
		}
		public function get row():int
		{
			return this.numRow;
		}
		public function set column($column:int):void
		{
			this.numColumn = $column;
		}
		public function get column():int
		{
			return this.numColumn;
		}
		public function get url():String
		{
			return this.strURL;
		}
	}
}