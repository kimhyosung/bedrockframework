package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.model.Config;
	import com.bedrockframework.engine.model.Queue;

	public class SetQueueCommand extends Command implements ICommand
	{
		public function SetQueueCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			Queue.setQueue(Config.getPage($event.details.alias));
		}
	}

}