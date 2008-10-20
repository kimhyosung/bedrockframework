package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.manager.*;
	
	import flash.display.DisplayObjectContainer;
	import com.bedrockframework.engine.bedrock;
	
	public class RenderSiteCommand extends Command implements ICommand
	{
		public function RenderSiteCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objBedrockEngine:BedrockEngine =  BedrockEngine.getInstance()
			if (!objBedrockEngine.bedrock::state.siteRendered) {
				var objPreloader:*  = new SitePreloader;
				var objContainer:DisplayObjectContainer = objBedrockEngine.containerManager.getContainer("preloader");
				objContainer.addChild(objPreloader);
				objBedrockEngine.bedrock::preloaderManager.container = objPreloader;
				objBedrockEngine.bedrock::state.siteRendered = true;
			}
		}
	}
}