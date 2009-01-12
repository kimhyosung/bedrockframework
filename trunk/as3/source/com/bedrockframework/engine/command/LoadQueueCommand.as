package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.*;
	
	import com.bedrockframework.engine.bedrock;
	
	public class LoadQueueCommand extends Command implements ICommand
	{
		public function LoadQueueCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objPage:Object=BedrockEngine.bedrock::pageManager.loadQueue();
			if (objPage) {
				BedrockEngine.bedrock::pageManager.setupPageLoad(objPage);
			}
			BedrockEngine.loadManager.loadQueue();
		}
	}

}