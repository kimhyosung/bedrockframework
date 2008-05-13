package com.icg.madagascar.command
{
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.manager.*;
	import com.icg.madagascar.model.SectionStorage;
	import com.icg.madagascar.model.State;

	public class URLChangeCommand extends Command implements ICommand
	{
		public function URLChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			if (State.current !=State.INITIALIZED && State.current != State.UNAVAILABLE ) {
				try {
					var strPath:String = $event.details.path;
					var strCurrentAlias:String = SectionStorage.current.alias;
					if (strPath && strPath != strCurrentAlias) {
						MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.DO_CHANGE, this, {alias:strPath}));
					}
				} catch ($e:Error) {
				}
			}
		}
	}

}