package com.yourdomain.project.template
{
	import com.yourdomain.bedrock.engine.BedrockBuilder;
	import com.yourdomain.bedrock.engine.manager.*;
	import com.yourdomain.bedrock.engine.model.Config;
	import com.yourdomain.project.template.command.*;
	import com.yourdomain.project.template.event.*;
	import com.yourdomain.project.template.model.*;
	import com.yourdomain.project.template.view.*;
	
	
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