package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.manager.ContainerManager;
	import com.builtonbedrock.bedrock.manager.PreloaderManager;
	import com.builtonbedrock.bedrock.model.State;
	
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