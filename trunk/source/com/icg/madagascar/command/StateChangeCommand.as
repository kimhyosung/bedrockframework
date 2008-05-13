package com.icg.madagascar.command
{
	import com.icg.madagascar.command.ICommand;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.model.State;

	public class StateChangeCommand extends Command implements ICommand
	{
		public function StateChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			switch ($event.type) {
				case MadagascarEvent.SET_QUEUE :
					State.change(State.UNAVAILABLE);
					break;
				case MadagascarEvent.INITIALIZE_COMPLETE :
					State.change(State.AVAILABLE);
					break;
			}

		}
	}

}