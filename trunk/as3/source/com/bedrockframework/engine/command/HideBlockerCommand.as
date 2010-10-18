﻿package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.data.BedrockData;

	public class HideBlockerCommand extends Command implements ICommand
	{
		public function HideBlockerCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			BedrockEngine.containerManager.getContainer(BedrockData.BLOCKER_CONTAINER).hide();
		}
	}

}