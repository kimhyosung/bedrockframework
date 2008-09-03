package com.yourdomain.project.template
{
	import com.bedrockframework.engine.BedrockBuilder;
	import com.bedrockframework.engine.IBedrockBuilder;
	import com.bedrockframework.engine.manager.*;
	import com.yourdomain.project.template.command.*;
	import com.yourdomain.project.template.event.*;
	import com.yourdomain.project.template.model.*;
	import com.yourdomain.project.template.view.*;
	
	
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