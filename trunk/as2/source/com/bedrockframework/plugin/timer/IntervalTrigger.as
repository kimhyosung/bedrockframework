/*

IntervalTrigger
- Manages a single interval.

*/
import mx.utils.Delegate;
import com.bedrockframework.plugin.event.IntervalTriggerEvent;
class com.bedrockframework.plugin.timer.IntervalTrigger extends com.bedrockframework.core.base.DispatcherWidget
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "IntervalTrigger";
	private var _numInterval:Number;
	private var _numSeconds:Number;
	private var _numMilliseconds:Number;
	private var _numIndex:Number;
	private var _numLoops:Number;
	private var _bolRunning:Boolean;
	/*
	Constructor
	*/
	public function IntervalTrigger($seconds:Number)
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
			this._numInterval = setInterval(Delegate.create(this, this.timerIntervalTrigger), this._numMilliseconds);
			this._numLoops = $total || -1;
			this._numIndex = 0;
			this.dispatchEvent(new IntervalTriggerEvent(IntervalTriggerEvent.START, this));
		}
	}
	public function stop():Void
	{
		output("Stop");
		this._numIndex = 0;
		this._bolRunning = false;
		clearInterval(this._numInterval);
		this.dispatchEvent(new IntervalTriggerEvent(IntervalTriggerEvent.STOP, this));
	}
	public function timerIntervalTrigger():Void
	{
		this.dispatchEvent(new IntervalTriggerEvent(IntervalTriggerEvent.TRIGGER, this, {index:this._numIndex}));
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
	public function get seconds():Number
	{
		return this._numSeconds;
	}
	public function get milliseconds():Number
	{
		return this._numMilliseconds;
	}
	public function get running():Boolean
	{
		return this._bolRunning;
	}
	public function get elapsed():Number
	{
		return (this._numIndex * (this._numMilliseconds / 1000));
	}
}
