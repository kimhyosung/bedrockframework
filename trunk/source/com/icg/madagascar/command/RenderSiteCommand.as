package com.icg.madagascar.command
{
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.factory.AssetFactory;
	import com.icg.madagascar.manager.ContainerManager;
	import com.icg.madagascar.manager.LoadManager;
	import com.icg.madagascar.manager.PreloaderManager;
	import com.icg.madagascar.model.SectionStorage;
	import com.icg.madagascar.view.IPreloader;
	
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