package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.SectionStorage;
	import com.bedrockframework.engine.model.State;import com.bedrockframework.core.command.*;

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
						BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE, this, {alias:strPath}));
					}
				} catch ($e:Error) {
				}
			}
		}
	}

}