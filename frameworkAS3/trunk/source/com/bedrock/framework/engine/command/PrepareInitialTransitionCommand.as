package com.bedrock.framework.engine.command
{
	import com.bedrock.framework.core.command.Command;
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.core.event.GenericEvent;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.event.BedrockEvent;

	public class PrepareInitialTransitionCommand extends Command implements ICommand
	{
		public function PrepareInitialTransitionCommand()
		{
			super();
		}
		
		public function execute($event:GenericEvent):void
		{
			var details:Object = $event.details || new Object;k
			if ( BedrockEngine.config.getSettingValue( BedrockData.DEEPLINKING_ENABLED ) && BedrockEngine.config.getSettingValue( BedrockData.DEEPLINK_CONTENT ) ) {
				details.path = BedrockEngine.deeplinkingManager.getPath();
			}
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.INITIAL_TRANSITION, this, details ) );
		}
		
	}
}