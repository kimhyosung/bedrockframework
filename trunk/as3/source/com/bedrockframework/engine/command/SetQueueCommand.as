package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	
	import com.bedrockframework.engine.bedrock;

	public class SetQueueCommand extends Command implements ICommand
	{
		public function SetQueueCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objBedrockEngine:BedrockEngine = BedrockEngine.getInstance()
			objBedrockEngine.bedrock::pageManager.setQueue(objBedrockEngine.config.getPage($event.details.alias));
		}
	}

}