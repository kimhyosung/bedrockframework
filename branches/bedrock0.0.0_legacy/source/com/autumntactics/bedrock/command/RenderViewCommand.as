package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.command.ICommand;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.manager.ContainerManager;
	import com.builtonbedrock.bedrock.factory.AssetFactory;

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