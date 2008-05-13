package com.icg.madagascar.command
{
	import com.icg.madagascar.command.ICommand;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.manager.ContainerManager;
	import com.icg.madagascar.factory.AssetFactory;

	public class RenderViewCommand extends Command implements ICommand
	{
		public function RenderViewCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objEvent:GenericEvent = $event;
			var objView:* = AssetFactory.getView($event.details.name);
			ContainerManager.buildContainer($event.details.container,objView, $event.details.properties);
		}
	}
}