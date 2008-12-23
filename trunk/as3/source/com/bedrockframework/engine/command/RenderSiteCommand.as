package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.manager.*;
	
	import flash.display.DisplayObjectContainer;
	
	public class RenderSiteCommand extends Command implements ICommand
	{
		public function RenderSiteCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			if (!BedrockEngine.bedrock::state.siteRendered) {
				var objPreloader:*  = new SitePreloader;
				var objContainer:DisplayObjectContainer = BedrockEngine.containerManager.getContainer(BedrockData.PRELOADER_CONTAINER);
				objContainer.addChild(objPreloader);
				BedrockEngine.bedrock::preloaderManager.scope = objPreloader;
				BedrockEngine.bedrock::state.siteRendered = true;
			}
		}
	}
}