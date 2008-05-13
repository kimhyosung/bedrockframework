package com.icg.remoting {
	
	import com.icg.events.CallEvent;
	import com.icg.madagascar.output.IOutputter;
	import com.icg.madagascar.output.Outputter;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	
	public dynamic class Service extends Proxy implements IEventDispatcher, IOutputter {
		
		public static var ENCODING_TYPE:uint = ObjectEncoding.AMF3;
		protected var objConnection:NetConnection;
		protected var strGateway:String;
		private var objEventDispatcher:EventDispatcher;
		private var strPath:String;
		private var objOutputter:Outputter;
		
		/**
		 * Constructor
		 * 
		 * <P>
		 * This constructs the <code>ServiceProxy</code> class.
		 * 
		 * @param gateway the url of the gateway
		 * @param service the name of the service
		 * @param bolUseQueue wherether to use pooling, default = true
		 */
		public function Service($gateway:String, $path:String) {
			this.objOutputter = new Outputter(this)
			if($gateway == null) {
				throw new Error("The gateway parameter is required in the Service class.");
			}
			this.strGateway = $gateway;
			this.strPath = $path;
			this.objEventDispatcher = new EventDispatcher();
			this.objConnection = new NetConnection();
			this.objConnection.client = this;
			this.objConnection.addEventListener(NetStatusEvent.NET_STATUS, this.onConnectionStatus);
			this.objConnection.addEventListener(IOErrorEvent.IO_ERROR, this.onConnectionError);
			this.objConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR , this.onConnectionError);
			this.objConnection.objectEncoding = Service.ENCODING_TYPE;
			try{
				this.objConnection.connect(this.strGateway);
				this.output("Connected to - " + this.strGateway)
			}catch($error:Error){
				this.output("Could not connect to remote service!", "warning")
			}finally{
				//this.objConnection.connect(strGateway);
			}
			
		}
		
		

		/**
		 * Appends additional information to the gateway url
		 * 
		 * @param value object to be appended to the url
		 */
		public function appendToGatewayUrl($value:String):void {
			this.strGateway += $value;
		}
	
		/**
		 * call a method with params
		 * 
		 * @param methodName (String)
		 * @param arguments (Array)
		 */
		public function call($methodName:String, $arguments:Array):void
		{
			var strPath:String = this.strPath;
			var strCall:String = $methodName.toString()
			var objCall:Call = new Call(strCall, this);
			objCall.addEventListener(CallEvent.RESULT, this.onResult, false, 0, true);
			objCall.addEventListener(CallEvent.FAULT, this.onFault, false, 0, true);
			objCall.addEventListener(CallEvent.CONNECTION_ERROR, this.onTimeout, false, 0, true);
			objCall.execute.apply(this, $arguments);
		}
		
		flash_proxy override function callProperty($methodName:*, ...$args):* {
			try {
				this.call($methodName, $args);
			}catch($error:Error) {}
			return null;
		}
		
  		flash_proxy override function hasProperty($name:*):Boolean {
			return false;
		}
		
		flash_proxy override function getProperty($name:*):* 
		{
			return null;
		}
		/*
		Output Function
		*/
		public function output($trace:*, $category:String = "status"):void 
		{
			this.objOutputter.output($trace, $category)
		}
		/**
		 * Dispatches a fault event on a connection error
		 */
		private function onConnectionError(event:ErrorEvent):void {
			this.dispatchEvent(new CallEvent(CallEvent.CONNECTION_ERROR, this, {text:"Connection Error: " + event.text}));
		}
		
		/**
		 * Dispatches a fault event on a connection error
		 */
		private function onConnectionStatus($event:NetStatusEvent):void {
			var objInfo:Object = $event.info;
			this.output("Connection Status - " + objInfo.code)
			switch(objInfo.code) {
				case "NetConnection.Connect.Failed":
					this.dispatchEvent(new CallEvent(CallEvent.CONNECTION_ERROR, this, {text:"Connection Error: " + $event.info.code}));
					break;
			}
		}
		
		private function onFault($event:CallEvent):void {
			this.dispatchEvent($event);
		}
		
		private function onResult($event:CallEvent):void {
			this.dispatchEvent($event);
		}
		
		private function onTimeout($event:CallEvent):void {
			this.dispatchEvent($event);
		}
		/*
		Event Dispatcher Stuff
		*/
		
		public function addEventListener($type:String, $listener:Function, $useCapture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void {
			this.objEventDispatcher.addEventListener($type, $listener, $useCapture, $priority, $weak);
		}
		
		public function dispatchEvent($event:Event):Boolean {
			return this.objEventDispatcher.dispatchEvent($event);
		}
		
		public function hasEventListener($type:String):Boolean {
			return this.objEventDispatcher.hasEventListener($type);
		}
		
		public function removeEventListener($type:String, $listener:Function, $useCapture:Boolean = false):void {
			this.objEventDispatcher.removeEventListener($type, $listener, $useCapture);
		}
		
		public function willTrigger($type:String):Boolean {
			return this.objEventDispatcher.willTrigger($type);
		}
		/*
		Property Definitions
		*/
		public function set objectEncoding($encoding:uint):void{
			 this.objConnection.objectEncoding = $encoding;
		}
		public function get objectEncoding():uint{
			return this.objConnection.objectEncoding
		}
		
		public function get connection():NetConnection
		{
			return this.objConnection;
		}
		public function get path():String
		{
			return this.strPath;
		}
	}
}