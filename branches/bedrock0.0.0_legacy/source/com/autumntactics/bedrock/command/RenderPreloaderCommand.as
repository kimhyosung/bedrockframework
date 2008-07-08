package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.command.ICommand;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.manager.ContainerManager;
	import com.autumntactics.bedrock.manager.LoadManager;
	import com.autumntactics.bedrock.manager.PreloaderManager;
	import com.autumntactics.bedrock.view.IPreloader;
	import com.autumntactics.bedrock.factory.AssetFactory;
	import com.autumntactics.bedrock.model.SectionStorage;
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