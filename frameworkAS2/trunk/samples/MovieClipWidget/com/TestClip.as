import com.TestEvent;
import caurina.transitions.Tweener;
import caurina.transitions.properties.DisplayShortcuts;
class com.TestClip extends com.bedrockframework.core.base.MovieClipWidget
{
	public function TestClip()
	{
		trace("TestClip Created!");
	}
	
	public function initialize():Void
	{
		DisplayShortcuts.init();
		this.applyActions();
	}
	
	public function applyActions():Void
	{
		this.onRelease = this.sendEvent;
	}
	
	public function sendEvent():Void
	{
		this.dispatchEvent(new TestEvent(TestEvent.TEST, this));
	}
}