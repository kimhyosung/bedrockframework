package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.command.ICommand;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.manager.ContainerManager;
	import com.autumntactics.bedrock.factory.AssetFactory;

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