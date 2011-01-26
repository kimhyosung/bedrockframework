package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.engine.Bedrock;
	import com.bedrock.framework.engine.api.ITrackingManager;
	import com.bedrock.framework.plugin.storage.HashMap;
	import com.bedrock.framework.plugin.tracking.ITrackingService;
	import com.bedrock.framework.plugin.trigger.Trigger;
	import com.bedrock.framework.plugin.trigger.TriggerEvent;
	/**
	 * @private
	 */
	public class TrackingManager implements ITrackingManager
	{
		/*
		Variable Declarations
		*/
		private var _enabled:Boolean;
		private var _trigger:Trigger;
		private var _services:HashMap;
		private var _queue:Array;
		/*
		Constructor
		*/
		public function TrackingManager()
		{
			this._enabled = true;
		}
		/*
		Initialize
		*/
		public function initialize($enabled:Boolean = true):void
		{
			this._enabled = $enabled;
			if ( this._enabled ) {
				Bedrock.logger.status( "Tracking Enabled" );
			} else {
				Bedrock.logger.status( "Tracking Disabled" );
			}
			
			this._services = new HashMap();
			this._queue = new Array;
			
			this._createTrigger();
		}
		private function _createTrigger():void
		{
			this._trigger = new Trigger;
			this._trigger.addEventListener( TriggerEvent.TIMER_TRIGGER, this._onTrackTimer );
			this._trigger.silenceLogging = true;
		}
		/*
		Run Tracking
		*/
		public function track($id:String, $details:Object):void
		{
			if ( this.enabled ) {
				if ( this.hasService( $id ) ) {
					this._appendCall( $id, $details );
					this._executeNext();
				}
			}
		}
		/*
		Add/ Get Services
		*/
		public function addService($id:String, $service:ITrackingService):void
		{
			this._services.saveValue($id, $service);
		}
		public function getService($id:String):*
		{
			return this._services.getValue($id);
		}
		public function hasService( $id:String ):Boolean
		{
			return this._services.containsKey( $id );
		}
		/*
		Internal
		*/
		private function _execute($id:String, $details:Object):void
		{
			if ( this.hasService( $id ) ) {
				this.getService( $id ).track( $details );
			}
		}
		private function _startTimer():void
		{
			if ( !this._trigger.timerRunning ) {
				this._trigger.startTimer( 0.3 );
			}
		}
		
		/*
		Queue Functions 
		*/
		private function _appendCall($id:String, $details:Object):void
		{
			this._queue.push( { id:$id, details:$details } );
		}
		private function _executeNext():void
		{
			if ( this._queue.length > 0 ) {
				var queueData:Object = this._queue.shift();
				this._execute( queueData.id, queueData.details );
				if ( this._queue.length > 0 ) this._startTimer();
			}
		}
		/*
		Event Handlers
		*/
		private function _onTrackTimer( $event:TriggerEvent ):void
		{
			this._executeNext();
		}
		/*
		Property Definitions
		*/
		public function get enabled():Boolean
		{
			return this._enabled;
		}
	}
}