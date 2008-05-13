package com.icg.madagascar.command
{
	import com.icg.madagascar.command.ICommand;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.manager.ContainerManager;
	import com.icg.madagascar.manager.LoadManager;
	import com.icg.madagascar.manager.PreloaderManager;
	import com.icg.madagascar.view.IPreloader;
	import com.icg.madagascar.factory.AssetFactory;
	import com.icg.madagascar.model.SectionStorage;
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
			PreloaderManager.set(objPreloader);
		}
	}
}