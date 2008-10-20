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
			var objBedrockEngine:BedrockEngine = BedrockEngine.getInstance();
			var objPreloader:*;
			if (objBedrockEngine.assetManager.hasPreloader(objBedrockEngine.bedrock::pageManager.current.alias)) {
				objPreloader=objBedrockEngine.assetManager.getPreloader(objBedrockEngine.bedrock::pageManager.current.alias);
			} else {
				objPreloader=objBedrockEngine.assetManager.getPreloader(BedrockData.DEFAULT_PRELOADER);
			}
			objBedrockEngine.containerManager.buildContainer(BedrockData.PRELOADER_CONTAINER,objPreloader);
			objBedrockEngine.bedrock::preloaderManager.container = objPreloader;
		}
	}
}