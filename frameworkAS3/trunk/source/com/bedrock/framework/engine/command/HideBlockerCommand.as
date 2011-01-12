package com.bedrock.framework.engine.command
{
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.event.GenericEvent;
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.data.BedrockData;

	public class HideBlockerCommand implements ICommand
	{
		public function HideBlockerCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			Bedrock.engine::containerManager.getContainer( BedrockData.OVERLAY ).getChildByName( BedrockData.BLOCKER ).hide();
		}
	}

}