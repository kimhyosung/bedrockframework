package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.model.State;
	
	import com.bedrockframework.engine.bedrock;

	public class StateChangeCommand extends Command implements ICommand
	{
		public function StateChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			switch ($event.type) {
				case BedrockEvent.SET_QUEUE :
					BedrockEngine.getInstance().bedrock::state.change(State.UNAVAILABLE);
					break;
				case BedrockEvent.INITIALIZE_COMPLETE :
					BedrockEngine.getInstance().bedrock::state.change(State.AVAILABLE);
					break;
			}

		}
	}

}