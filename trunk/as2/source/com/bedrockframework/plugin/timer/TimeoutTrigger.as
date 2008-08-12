/*

TimeoutTrigger


*/
import mx.utils.Delegate;
import com.bedrockframework.plugin.event.TimeoutTriggerEvent;
class com.bedrockframework.plugin.timer.TimeoutTrigger extends com.bedrockframework.core.base.DispatcherWidget
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "TimeoutTrigger";
	private var _bolRunning:Boolean;
	private var _numSeconds:Number;
	private var _numMilliseconds:Number;
	
	/*
	Constructor
	*/
	public function TimeoutTrigger($seconds:Number)
	{
		this._numSeconds = $seconds || 0.5;
		this._bolRunning = false;
	}
	/*
	Public Functions
	*/
	public function start($seconds:Number, $callback:Object):Void
	{
		if (!this._bolRunning) {
			output("Start");
			this._bolRunning = true;
			this._numSeconds = $seconds || 0.5;
			this._numMilliseconds = $seconds * 1000;
			_global["setTimeout"](Delegate.create(this, this.timerTimeoutTrigger), this._numMilliseconds);
			this.dispatchEvent(new TimeoutTriggerEvent(TimeoutTriggerEvent.START, this));
		}
	}
	public function stop():Void
	{
		output("Stop");
		this._bolRunning = false;
		this.dispatchEvent(new TimeoutTriggerEvent(TimeoutTriggerEvent.STOP, this));
	}
	private function timerTimeoutTrigger():Void
	{
		if (this._bolRunning) {
			this._bolRunning = false;
			this.dispatchEvent(new TimeoutTriggerEvent(TimeoutTriggerEvent.TRIGGER, this));
		}
	}
	/*
	Property Definitions
	*/
	public function get delay():Number
	{
		return (this._numMilliseconds / 1000);
	}
	public function get running():Boolean
	{
		return this._bolRunning;
	}
}