package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.dispatcher.BedrockDispatcher;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	import com.builtonbedrock.bedrock.manager.*;
	import com.builtonbedrock.bedrock.model.SectionStorage;
	import com.builtonbedrock.bedrock.model.State;

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