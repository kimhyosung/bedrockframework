package __template
{
	import com.bedrockframework.engine.BedrockBuilder;
	import com.bedrockframework.engine.IBedrockBuilder;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.plugin.tracking.BridgeTrack;
	import __template.command.*;
	import __template.event.*;
	import __template.model.*;
	import __template.view.*;
	
	
	public class SiteBuilder extends BedrockBuilder implements IBedrockBuilder
	{
		/*
		Variable Declarations
		*/
		/*
		Constructor
	 	*/
		public function SiteBuilder()
		{
			super();
		}
		public function loadModels():void
		{
			this.status("Loading Models");
			this.next();
		}
		public function loadCommands():void
		{
			this.status("Loading Commands");
			this.next();
		}
		public function loadViews():void
		{
			this.status("Loading Views");
			this.next();
		}
		public function loadTracking():void
		{
			this.status("Loading Tracking");			
			this.next();
		}
		public function loadCustomization():void
		{
			this.status("Loading Customization");
			this.next();
		}
	}
}