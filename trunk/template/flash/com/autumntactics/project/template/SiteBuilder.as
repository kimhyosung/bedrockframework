package com.autumntactics.project.template
{
	import com.autumntactics.bedrock.MadagascarBuilder;
	import com.autumntactics.project.template.view.*;
	import com.autumntactics.project.template.model.*;
	import com.autumntactics.project.template.command.*;
	import com.autumntactics.project.template.events.*;
	import com.autumntactics.bedrock.manager.*;
	
	
	public class SiteBuilder extends MadagascarBuilder
	{
		public function SiteBuilder()
		{
			super();
		}
		override public function loadModels():void
		{
			this.output("Loading Models");
			this.next();
		}
		override public function loadCommands():void
		{
			this.addCommand(SiteEvent.DATA_REQUEST, DataRequestCommand)
			this.output("Loading Commands");
			this.next();
		}
		override public function loadViews():void
		{
			this.output("Loading Views");
			this.addToQueue("navigation.swf",ContainerManager.getContainer("navigation"));
			this.next();
		}
	}
}