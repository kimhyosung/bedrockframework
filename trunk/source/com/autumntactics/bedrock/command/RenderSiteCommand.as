package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.factory.AssetFactory;
	import com.autumntactics.bedrock.manager.ContainerManager;
	import com.autumntactics.bedrock.manager.LoadManager;
	import com.autumntactics.bedrock.manager.PreloaderManager;
	import com.autumntactics.bedrock.model.SectionStorage;
	import com.autumntactics.bedrock.view.IPreloader;
	
	public class RenderSiteCommand extends Command implements ICommand
	{
		public function RenderSiteCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objPreloader:*  = new SitePreloader;
			ContainerManager.buildContainer("preloader",objPreloader);
			PreloaderManager.set(objPreloader);
		}
	}
}