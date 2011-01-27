package com.bedrock.framework.engine.command
{
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.event.GenericEvent;
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.Bedrock;

	public class DeeplinkChangeCommand implements ICommand
	{
		public function DeeplinkChangeCommand()
		{
			super();
		}
		
		public function execute($event:GenericEvent):void
		{
			Bedrock.engine::transitionController.prepareDeeplinkTransition( $event.details );
		}
		
	}
}