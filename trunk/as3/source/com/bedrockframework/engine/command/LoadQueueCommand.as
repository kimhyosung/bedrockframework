package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.*;

	public class LoadQueueCommand extends Command implements ICommand
	{
		public function LoadQueueCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objPage:Object=Queue.getQueue();
			if (objPage) {
				PageManager.setupPageLoad(objPage);
			}
			LoadManager.loadQueue();
		}
	}

}