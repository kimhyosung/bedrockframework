package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.command.ICommand;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	import com.builtonbedrock.bedrock.model.State;

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