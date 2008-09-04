package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.dispatcher.BedrockDispatcher;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.manager.*;
	import com.autumntactics.bedrock.model.SectionStorage;
	import com.autumntactics.bedrock.model.State;

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