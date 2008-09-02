package com.builtonbedrock.project.template
{
	import com.builtonbedrock.bedrock.BedrockBuilder;
	import com.builtonbedrock.bedrock.model.Config;
	import com.builtonbedrock.project.template.view.*;
	import com.builtonbedrock.project.template.model.*;
	import com.builtonbedrock.project.template.command.*;
	import com.builtonbedrock.project.template.events.*;
	import com.builtonbedrock.bedrock.manager.*;
	
	
	public class SiteBuilder extends BedrockBuilder
	{
		public function SiteBuilder()
		{
			super();
		}
		override public function loadModels():void
		{
			this.status("Loading Models");
			this.next();
		}
		override public function loadCommands():void
		{
			this.addCommand(SiteEvent.DATA_REQUEST, DataRequestCommand)
			this.status("Loading Commands");
			this.next();
		}
		override public function loadViews():void
		{
			this.status("Loading Views");
			this.addToQueue(Config.getValue("swf_path") + "navigation.swf",ContainerManager.getContainer("navigation"));
			this.next();
		}
	}
}