package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.State;
	
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