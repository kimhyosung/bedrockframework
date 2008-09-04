package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.command.ICommand;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.model.State;

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