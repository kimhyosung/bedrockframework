package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.model.State;

	public class StateChangeCommand extends Command implements ICommand
	{
		public function StateChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			switch ($event.type) {
				case BedrockEvent.SET_QUEUE :
					State.change(State.UNAVAILABLE);
					break;
				case BedrockEvent.INITIALIZE_COMPLETE :
					State.change(State.AVAILABLE);
					break;
			}

		}
	}

}