package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.Config;
	import com.bedrockframework.engine.model.Queue;
	import com.bedrockframework.engine.model.State;

	public class URLChangeCommand extends Command implements ICommand
	{
		public function URLChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			if (State.current !=State.INITIALIZED && State.current != State.UNAVAILABLE ) {
				try {
					var strPath:String = $event.details.paths[0];
					var strCurrentAlias:String = Queue.current.alias;
					if (Config.getSection(strPath) != null) {
						if (strPath && strPath != strCurrentAlias) {
							BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE, this, {alias:strPath}));
						}
					}					
				} catch ($e:Error) {
				}
			}
		}
	}

}