/*

Trigger
- Manages a single interval.

*/
import mx.utils.Delegate;
import com.bedrockframework.plugin.event.TriggerEvent;
class com.bedrockframework.plugin.timer.Trigger extends com.bedrockframework.core.base.DispatcherWidget
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "Trigger";
	private var _numInterval:Number;
	private var _numSeconds:Number;
	private var _numMilliseconds:Number;
	private var _numIndex:Number;
	private var _numLoops:Number;
	private var _bolRunning:Boolean;
	/*
	Constructor
	*/
	public function Trigger($seconds:Number)
	{
		this._numSeconds = $seconds || 0.5;
		this._numLoops = -1;
		this._bolRunning = false;
	}
	/*
	Public Functions
	*/
	public function start($seconds:Number, $total:Number):Void
	{
		if (!this._bolRunning) {
			output("Start");
			this._bolRunning = true;
			this._numSeconds = $seconds || this._numSeconds;
			this._numMilliseconds = $seconds * 1000;
			this._numInterval = setInterval(Delegate.create(this, this.timerTrigger), this._numMilliseconds);
			this._numLoops = $total || -1;
			this._numIndex = 0;
			this.dispatchEvent(new TriggerEvent(TriggerEvent.START, this));
		}
	}
	public function stop():Void
	{
		output("Stop");
		this._numIndex = 0;
		this._bolRunning = false;
		clearInterval(this._numInterval);
		this.dispatchEvent(new TriggerEvent(TriggerEvent.STOP, this));
	}
	public function timerTrigger():Void
	{
		this.dispatchEvent(new TriggerEvent(TriggerEvent.TRIGGER, this, {index:this._numIndex}));
		this._numIndex++;
		if (this._numLoops > 0) {
			if (this._numIndex >= this._numLoops) {
				this.stop();
			}
		}
	}
	/*
	Property Definitions
	*/
	public function get _seconds():Number
	{
		return this._numSeconds;
	}
	public function get _milliseconds():Number
	{
		return this._numMilliseconds;
	}
	public function get _running():Boolean
	{
		return this._bolRunning;
	}
	public function get _elapsed():Number
	{
		return (this._numIndex * (this._numMilliseconds / 1000));
	}
}
