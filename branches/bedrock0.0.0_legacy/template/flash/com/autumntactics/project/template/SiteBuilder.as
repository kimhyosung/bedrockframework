package com.autumntactics.project.template
{
	import com.autumntactics.bedrock.BedrockBuilder;
	import com.autumntactics.bedrock.model.Config;
	import com.autumntactics.project.template.view.*;
	import com.autumntactics.project.template.model.*;
	import com.autumntactics.project.template.command.*;
	import com.autumntactics.project.template.events.*;
	import com.autumntactics.bedrock.manager.*;
	
	
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