package __template
{
	import __template.command.DataRequestCommand;
	import __template.event.SiteEvent;
	
	import com.bedrockframework.engine.BedrockBuilder;
	import com.bedrockframework.engine.manager.ContainerManager;
	import com.bedrockframework.engine.model.Config;
	
	
	public class SiteBuilder extends BedrockBuilder
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
			this.addCommand(SiteEvent.DATA_REQUEST, DataRequestCommand)
			this.status("Loading Commands");
			this.next();
		}
		public function loadViews():void
		{
			this.status("Loading Views");
			this.addToQueue(Config.getValue("swf_path") + "navigation.swf",ContainerManager.getContainer("navigation"));
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