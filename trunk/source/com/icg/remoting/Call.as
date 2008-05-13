
package com.icg.remoting
{

	import com.icg.events.CallEvent;
	import com.icg.madagascar.base.DispatcherWidget;
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.*;


	/**
	 * Operation
	 */
	public class Call extends DispatcherWidget
	{

		public static  var TIMEOUT:Number = 60000; // 1 minute
		private var objConnection:NetConnection;
		private var strPath:String;
		private var strCall:String;
		private var objRemoteResponder:Responder;
		private var arrArguments:Array;
		private var numID:uint;
		private var objService:Service;
		private var objLocalResponder:IResponder;

		/**
		 * Contains the information to be performed
		 */
		public function Call($call:String, $service:Service, $result:Function=null, $fault:Function=null)
		{
			super(true);
			this.strCall = $call;
			this.setup($service);
			if ($result != null) {
				this.addEventListener(CallEvent.RESULT, $result);
			}		
			if ($fault != null) {
				this.addEventListener(CallEvent.FAULT, $fault);
			}
		}
		/*
		Setup the info the call will need
		*/
		public function setup($service:Service):void
		{
			this.objService = $service;
			this.objConnection = this.objService.connection;
			this.strPath = this.objService.path;
		}
		/*
		Execute the call
		*/
		public function execute(... $arguments:Array):void
		{
			this.arrArguments = $arguments;
			this.output("Calling - "+ this.strPath + "." + this.strCall);
			this.objRemoteResponder = new Responder(this.onResult, this.onFault);
			var arrTemp:Array = new Array(this.strPath + "." + this.strCall, this.objRemoteResponder);
			this.objConnection.call.apply(this.objConnection, arrTemp.concat(this.arrArguments));
			this.numID = setTimeout(this.onTimeout, Call.TIMEOUT);
		}
		private function onResult($result:Object):void
		{
			this.output("Call successful!");
			clearTimeout(this.numID);
			var objResult:Object = $result || {};
			objResult.call = this.strCall;
			this.dispatchEvent(new CallEvent(CallEvent.RESULT, this, objResult));
			if (this.responder != null) this.responder.result(objResult);
		}
		private function onFault($fault:Object):void
		{
			this.output("Call failed!", "warning");
			clearTimeout(this.numID);
			var objResult:Object = $fault;
			objResult.call = this.strCall;
			this.dispatchEvent(new CallEvent(CallEvent.FAULT, this, objResult));
			if (this.responder != null) this.responder.fault(objResult);
		}
		private function onTimeout():void
		{
			this.output("Connection Error - Call timed out!", "warning");
			if (this.responder != null) this.responder.fault({}); 
			this.dispatchEvent(new CallEvent(CallEvent.CONNECTION_ERROR, this, {text:"Connection Error: Call timed out!"}));
		}	
		/*
		Property Definitions
		*/
		public function set responder($responder:IResponder):void
		{
			this.objLocalResponder = $responder;
		}
		public function get responder():IResponder
		{
			return this.objLocalResponder;
		}
		public static function set timeout($milliseconds:uint):void
		{
			Call.TIMEOUT = $milliseconds;
		}
		public function get call():String
		{
			return this.strCall;
		}
		
	}
}