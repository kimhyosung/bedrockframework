package com.builtonbedrock.loader
{
	import com.builtonbedrock.events.LoaderEvent;
	import com.builtonbedrock.bedrock.output.OutputManager;
	import com.builtonbedrock.storage.SimpleMap;
	import com.builtonbedrock.util.ClassUtil;
	import com.builtonbedrock.util.MathUtil;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class BackgroundLoader extends URLLoader
	{
		/*
		Variable Declarations
		*/
		public static var cachePrevention:Boolean = false;
		public static var cacheKey:String = "";
		
		private static  var OBJ_REPLACEMENTS:SimpleMap;
		private var objURLRequest:URLRequest;
		private var strURL:String;		
		
		
		
		/*
		Constructor
		*/	
		BackgroundLoader.setupReplacements();
		
		public function BackgroundLoader($url:String=null)
		{
			//OutputManager.send("Constructed","constructor",ClassUtil.getDisplayClassName(this));
			this.objURLRequest = new URLRequest;
			if ($url != null) {
				this.loadURL($url);
			}
			this.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
		}
		private static function setupReplacements():void
		{
			var arrStandardEvents:Array = new Array(Event.COMPLETE, Event.OPEN, HTTPStatusEvent.HTTP_STATUS, ProgressEvent.PROGRESS, IOErrorEvent.IO_ERROR, SecurityErrorEvent.SECURITY_ERROR);
			var arrLoaderEvents:Array=new Array("COMPLETE","OPEN","HTTP_STATUS", "PROGRESS", "IO_ERROR", "SECURITY_ERROR" );
			OBJ_REPLACEMENTS=new SimpleMap;
			//
			var numLength:Number=arrStandardEvents.length;
			for (var i:Number=0; i < numLength; i++) {
				OBJ_REPLACEMENTS.saveValue(arrStandardEvents[i],LoaderEvent[arrLoaderEvents[i]]);
			}
		}
		public function loadURL($url:String, $context:LoaderContext = null):void
		{
			this.strURL = $url;
			this.objURLRequest.url = this.getURL(this.strURL);
			try {
				this.load(this.objURLRequest);
			} catch (error:Error) {
				OutputManager.send("Unable to load requested document","warning",ClassUtil.getDisplayClassName(this));
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
		private function recastEvent($event:Event):Event
		{
			var objDetails:Object=new Object;
			switch ($event.type) {
				case Event.COMPLETE :
					objDetails.bytesLoaded=this.bytesLoaded;
					objDetails.bytesTotal=this.bytesTotal;
					objDetails.data=this.data;
					break;
				case Event.OPEN :
					objDetails.url = this.strURL;
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
			//
			return new LoaderEvent(BackgroundLoader.OBJ_REPLACEMENTS.getValue($event.type),this,objDetails);

		}
		/*
		Event Handlers
		*/
		private function onIOError($event:IOErrorEvent):void
		{
			OutputManager.send($event.text,"warning",ClassUtil.getDisplayClassName(this));
		}
		private function onSecurityError($event:IOErrorEvent):void
		{
			OutputManager.send($event.text,"warning",ClassUtil.getDisplayClassName(this));
		}
		/*
		Property Definitions
		*/
		public function get request():URLRequest
		{
			return this.objURLRequest;
		}
	}
}