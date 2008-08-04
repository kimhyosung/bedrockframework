/*

Delay


*/
import mx.utils.Delegate;
import com.bedrockframework.plugin.event.DelayEvent;
class com.bedrockframework.plugin.timer.Delay extends com.bedrockframework.core.base.DispatcherWidget
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "Delay";
	private var _bolRunning:Boolean;
	private var _numSeconds:Number;
	private var _numMilliseconds:Number;
	
	/*
	Constructor
	*/
	public function Delay($seconds:Number)
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
			_global["setTimeout"](Delegate.create(this, this.timerDelay), this._numMilliseconds);
			this.dispatchEvent(new DelayEvent(DelayEvent.START, this));
		}
	}
	public function stop():Void
	{
		output("Stop");
		this._bolRunning = false;
		this.dispatchEvent(new DelayEvent(DelayEvent.STOP, this));
	}
	private function timerDelay():Void
	{
		if (this._bolRunning) {
			this._bolRunning = false;
			this.dispatchEvent(new DelayEvent(DelayEvent.TRIGGER, this));
		}
	}
	/*
	Property Definitions
	*/
	public function get _delay():Number
	{
		return (this._numMilliseconds / 1000);
	}
	public function get _running():Boolean
	{
		return this._bolRunning;
	}
}