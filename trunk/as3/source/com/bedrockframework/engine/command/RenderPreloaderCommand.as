package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.engine.data.BedrockData;
	
	import flash.display.DisplayObjectContainer;
	
	public class RenderPreloaderCommand extends Command implements ICommand
	{
		public function RenderPreloaderCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objPreloader:*;
			if (BedrockEngine.assetManager.hasPreloader(BedrockEngine.bedrock::pageManager.current.alias)) {
				objPreloader=BedrockEngine.assetManager.getPreloader(BedrockEngine.bedrock::pageManager.current.alias);
			} else {
				objPreloader=BedrockEngine.assetManager.getPreloader(BedrockData.DEFAULT_PRELOADER);
			}
			var objContainer:DisplayObjectContainer = BedrockEngine.containerManager.getContainer(BedrockData.PRELOADER_CONTAINER);
			objContainer.addChild(objPreloader);
			BedrockEngine.bedrock::preloaderManager.scope = objPreloader;
		}
	}
}