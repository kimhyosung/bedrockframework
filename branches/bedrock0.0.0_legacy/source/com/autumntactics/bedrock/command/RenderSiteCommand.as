package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.manager.ContainerManager;
	import com.autumntactics.bedrock.manager.PreloaderManager;
	import com.autumntactics.bedrock.model.State;
	
	import flash.display.DisplayObjectContainer;
	
	public class RenderSiteCommand extends Command implements ICommand
	{
		public function RenderSiteCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			if (!State.siteRendered) {
				var objPreloader:*  = new SitePreloader;
				var objContainer:DisplayObjectContainer = ContainerManager.getContainer("preloader");
				objContainer.addChild(objPreloader);
				PreloaderManager.container = objPreloader;
				State.siteRendered = true;
			}		
		}
	}
}