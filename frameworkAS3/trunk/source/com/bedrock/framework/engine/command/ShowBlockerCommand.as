package com.bedrock.framework.engine.command
{
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.event.GenericEvent;
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.data.BedrockData;

	public class ShowBlockerCommand implements ICommand
	{
		public function ShowBlockerCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			Bedrock.engine::containerManager.getContainer( BedrockData.OVERLAY ).getChildByName( BedrockData.BLOCKER ).show();
		}
	}

}