package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.data.BedrockData;
	
	import com.bedrockframework.engine.bedrock;
	
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
			BedrockEngine.containerManager.replaceContainer(BedrockData.PRELOADER_CONTAINER,objPreloader);
			BedrockEngine.bedrock::preloaderManager.container = objPreloader;
		}
	}
}