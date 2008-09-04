
package com.autumntactics.remoting
{

	import com.autumntactics.bedrock.base.DispatcherWidget;
	import com.autumntactics.events.CallEvent;
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.*;


	/**
	 * Operation
	 */
	public class Call extends DispatcherWidget
	{
		/*
		Variable Declarations
	 	*/
		public static  var TIMEOUT:Number = 60000; // 1 minute
		
		private var objConnection:NetConnection;
		private var strPath:String;
		private var strCall:String;
		private var objRemoteResponder:Responder;
		private var arrArguments:Array;
		private var numID:uint;
		private var objService:Service;
		private var objLocalResponder:IResponder;
		public var result:Function;
		public var fault:Function;
		/**
		 * Contains the information to be performed
		 */
		public function Call($call:String, $service:Service, $result:Function=null, $fault:Function=null)
		{
			super(false);
			this.strCall = $call;
			this.setup($service);
			if ($result != null) this.result = $result;
			if ($fault != null) this.fault = $fault;
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
		Clear Everything
	 	*/
	 	public function clear():void
		{
			this.objLocalResponder = null;
			this.result = null;
			this.fault = null;
		}
		/*
		Execute the call
		*/
		public function execute(... $arguments:Array):void
		{
			this.arrArguments = $arguments;
			this.status("Calling - "+ this.strPath + "." + this.strCall);
			this.objRemoteResponder = new Responder(this.onResult, this.onFault);
			var arrTemp:Array = new Array(this.strPath + "." + this.strCall, this.objRemoteResponder);
			this.objConnection.call.apply(this.objConnection, arrTemp.concat(this.arrArguments));
			this.numID = setTimeout(this.onTimeout, Call.TIMEOUT);
		}		
		/*
		Call External Targets
	 	*/
	 	private function callResult($data:Object):void
		{
			if (this.responder != null) this.responder.result($data);
			if (this.result != null) this.result($data);
			this.dispatchEvent(new CallEvent(CallEvent.RESULT, this, objResult));			
		}
		private function callFault($data:Object):void
		{
			if (this.responder != null) this.responder.fault($data);		
			if (this.fault != null) this.fault($data);	
			this.dispatchEvent(new CallEvent(CallEvent.FAULT, this, $data));
		}
		/*
		Event Handlers
	 	*/
		private function onResult($data:Object):void
		{
			this.status("Call successful!");
			clearTimeout(this.numID);
			var objResult:Object = $data || {};
			objResult.call = this.strCall;
			this.callResult(objResult);
		}
		private function onFault($data:Object):void
		{
			this.status("Call failed!", "warning");
			clearTimeout(this.numID);
			var objResult:Object = $data || {};
			objResult.call = this.strCall;
			this.callFault(objResult);
		}
		private function onTimeout():void
		{
			this.status("Connection Error - Call timed out!", "warning");
			this.callFault({text:"Connection Error: Call timed out!"});
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