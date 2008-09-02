package com.builtonbedrock.remoting {
	
	import com.builtonbedrock.bedrock.base.DispatcherWidget;
	import com.builtonbedrock.events.ServiceEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	
	public dynamic class Service extends DispatcherWidget 
	{
		
		public static var ENCODING_TYPE:uint = ObjectEncoding.AMF3;
		protected var objConnection:NetConnection;
		protected var strGateway:String;
		private var strPath:String;
				
		/**
		 * Constructor
		 * 
		 * <P>
		 * This constructs the <code>ServiceProxy</code> class.
		 * 
		 * @param gateway the url of the gateway
		 * @param service the name of the service
		 */
		public function Service($gateway:String, $path:String) {
			if($gateway == null) {
				throw new Error("The gateway parameter is required in the Service class.");
			}
			this.strGateway = $gateway;
			this.strPath = $path;

			this.objConnection = new NetConnection();
			this.objConnection.client = this;
			this.objConnection.addEventListener(NetStatusEvent.NET_STATUS, this.onConnectionStatus);
			this.objConnection.addEventListener(IOErrorEvent.IO_ERROR, this.onConnectionError);
			this.objConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR , this.onConnectionError);
			this.objConnection.objectEncoding = Service.ENCODING_TYPE;
			try{
				this.objConnection.connect(this.strGateway);
				this.status("Connected to - " + this.strGateway)
			}catch($error:Error){
				this.status("Could not connect to remote service!", "warning")
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
		 * Dispatches a fault event on a connection error
		 */
		private function onConnectionError(event:ErrorEvent):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.CONNECTION_ERROR, this, {text:"Connection Error: " + event.text}));
		}		
		/**
		 * Dispatches a fault event on a connection error
		 */
		private function onConnectionStatus($event:NetStatusEvent):void {
			var objInfo:Object = $event.info;
			this.status("Connection Status - " + objInfo.code)
			switch(objInfo.code) {
				case "NetConnection.Connect.Failed":
					this.dispatchEvent(new ServiceEvent(ServiceEvent.CONNECTION_ERROR, this, {text:"Connection Error: " + $event.info.code}));
					break;
				default :
					this.dispatchEvent(new ServiceEvent(ServiceEvent.STATUS, this, objInfo));
					break;
			}
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