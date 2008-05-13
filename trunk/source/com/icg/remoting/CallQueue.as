package com.icg.remoting
{
	import com.icg.madagascar.base.DispatcherWidget;
	import com.icg.events.CallQueueEvent;
	import com.icg.events.CallEvent;

	public class CallQueue extends DispatcherWidget
	{
		/*
		Variable Delarations
		*/
		private var numCallIndex:int;
		private var numTotalCalls:int;
		private var arrQueue:Array;
		private var bolComplete:Boolean;
		private var bolRunning:Boolean;
		private var numPercentage:Number;
		/*
		Constructor
		*/
		public function CallQueue()
		{
			this.arrQueue = new Array();
			this.numTotalCalls = 0;
			this.numCallIndex = 0;
			this.bolRunning=false;
			this.bolComplete=false;
		}
		
		public function reset():void
		{
			this.arrQueue = new Array();
			this.numTotalCalls = 0;
			this.numCallIndex = 0;
			this.bolRunning=false;
			this.bolComplete=false;
			this.numPercentage = 0;
			this.output("Reset");
			this.dispatchEvent(new CallQueueEvent(CallQueueEvent.RESET,this));
		}
		/*
		Add Listeners
		*/
		private function addListeners($target:*):void
		{
			$target.addEventListener(CallEvent.RESULT,this.onResult);
			$target.addEventListener(CallEvent.FAULT,this.onFault);
			
		}
		private function removeListeners($target:*):void
		{
			$target.removeEventListener(CallEvent.RESULT,this.onResult);
			$target.removeEventListener(CallEvent.FAULT,this.onFault);
		}
		/*
		Add a call to the queue, needs service, function name and parameters
		*/
		public function addToQueue($call:Call, ...$arguments:Array):void
		{
			if (this.bolComplete) {
				this.reset();
			}
			if (! this.bolRunning) {
				this.arrQueue.push({call:$call, arguments:$arguments});
				this.numTotalCalls=this.arrQueue.length;
			} else {
				this.output("Cannot add to queue while loading!","warning");
			}
		}
		/*
		
		*/
		public function runQueue():void
		{
			if (this.arrQueue.length > 0) {
				this.recalculate();
				this.begin();
			} else {
				output("Unable to call, queue is empty!","warning");
			}
		}
		/*
		
		*/
		private function begin():void
		{
			if (! this.bolRunning) {
				this.bolRunning=true;
				this.output("Begin Calling");
				this.doCall(0);
				this.dispatchEvent(new CallQueueEvent(CallQueueEvent.BEGIN,this,{total:this.numTotalCalls}));
			}
		}
		/*
		
		*/
		private  function doCall($index:int):void
		{
			this.recalculate();
			this.numCallIndex = $index;
			var objItem:Object = this.getItem($index);
			var objCall:Call = objItem.call;
			this.addListeners(objCall);
			objCall.execute.apply(this, objItem.arguments);
		}
		
		private function getItem($index:int):Object
		{
			return this.arrQueue[$index];	
		}
		
		private function callsComplete():void
		{
			this.bolComplete = true;
			this.dispatchEvent(new CallQueueEvent(CallQueueEvent.COMPLETE,this, {results:this.getResultArray(), result:this.getResultObject()}));
			this.output("Complete")
		}
		
		public function getResultArray():Array
		{
			var arrResults:Array = new Array();
			var numLength:int = this.arrQueue.length;
			for (var i = 0; i < numLength; i ++){
				arrResults.push(this.arrQueue[i].result)
			}
			return arrResults;
		}
		public function getResultObject():Object
		{
			var objResult:Object = new Object();
			var numLength:int = this.arrQueue.length;
			for (var i = 0; i < numLength; i ++){
				objResult[this.arrQueue[i].call] = this.arrQueue[i].result;
			}
			return objResult;
		}
		
		private function callNext():void
		{
			if (this.bolRunning) {
				var numTempIndex:Number=this.numCallIndex + 1;
				if (numTempIndex != this.numTotalCalls) {
					this.doCall(numTempIndex);
					var objDetails:Object = {call:this.getItem(numTempIndex).call.call,total:this.numTotalCalls, index:this.numCallIndex}
					this.dispatchEvent(new CallQueueEvent(CallQueueEvent.NEXT,this, objDetails));
				} else {
					this.callsComplete();
				}
			}
		}
		/*
		
		*/
		private function recalculate():void
		{
			this.numPercentage=Math.round(this.numCallIndex / this.numTotalCalls * 100);
		}
		/*
		Event Handlers
		*/
		private function onResult($event:CallEvent):void
		{
			var objItem:Object = this.getItem(this.numCallIndex);
			objItem.result = $event.details;
			this.removeListeners(objItem.call);
			this.callNext();
		}
		private function onFault($event:CallEvent):void
		{
			this.reset();
			this.dispatchEvent(new CallQueueEvent(CallQueueEvent.ERROR, this, $event.details));
		}
		
	}
}