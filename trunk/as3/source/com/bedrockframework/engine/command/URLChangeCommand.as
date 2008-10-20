package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.model.State;
	
	import com.bedrockframework.engine.bedrock;
	
	public class URLChangeCommand extends Command implements ICommand
	{
		public function URLChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objBedrockEngine:BedrockEngine = BedrockEngine.getInstance();
			
			if (objBedrockEngine.bedrock::state.current != State.INITIALIZED && objBedrockEngine.bedrock::state.current != State.UNAVAILABLE ) {
				try {
					var strPath:String = $event.details.paths[0];
					var strCurrentAlias:String = objBedrockEngine.bedrock::pageManager.current.alias;
					if (objBedrockEngine.config.getPage(strPath) != null) {
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