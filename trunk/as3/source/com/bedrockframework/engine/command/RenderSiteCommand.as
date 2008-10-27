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
			if (!BedrockEngine.bedrock::state.siteRendered) {
				var objPreloader:*  = new SitePreloader;
				var objContainer:DisplayObjectContainer = BedrockEngine.containerManager.getContainer("preloader");
				objContainer.addChild(objPreloader);
				BedrockEngine.bedrock::preloaderManager.container = objPreloader;
				BedrockEngine.bedrock::state.siteRendered = true;
			}
		}
	}
}