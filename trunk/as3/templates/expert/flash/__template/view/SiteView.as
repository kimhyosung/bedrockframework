package __template.view
{
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.view.BedrockView;
	import com.bedrockframework.plugin.view.IView;
	
	public class SiteView extends BedrockView implements IView
	{
		/*
		Variable Declarations
		*/
		/*
		Constructor
	 	*/
		public function SiteView()
		{
		}
		/*
		Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			//BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_DEFAULT,this));
			this.introComplete();
		}
		public function outro($properties:Object=null):void
		{
			this.outroComplete();
		}
		public function clear():void
		{
		}
	}
}