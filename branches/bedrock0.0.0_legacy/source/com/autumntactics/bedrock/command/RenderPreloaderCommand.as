package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.command.ICommand;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	import com.builtonbedrock.bedrock.manager.ContainerManager;
	import com.builtonbedrock.bedrock.manager.LoadManager;
	import com.builtonbedrock.bedrock.manager.PreloaderManager;
	import com.builtonbedrock.bedrock.view.IPreloader;
	import com.builtonbedrock.bedrock.factory.AssetFactory;
	import com.builtonbedrock.bedrock.model.SectionStorage;
	public class RenderPreloaderCommand extends Command implements ICommand
	{
		public function RenderPreloaderCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objPreloader:*;
			try {
				objPreloader=AssetFactory.getPreloader(SectionStorage.current.alias);
			} catch ($e:Error) {
				objPreloader=AssetFactory.getPreloader("default");
			}
			ContainerManager.buildContainer("preloader",objPreloader);
			PreloaderManager.container = objPreloader;
		}
	}
}