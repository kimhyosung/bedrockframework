package com.bedrock.framework.engine.command
{
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.event.GenericEvent;
	import com.bedrock.framework.engine.data.BedrockData;

	public class HideBlockerCommand implements ICommand
	{
		public function HideBlockerCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			Bedrock.api.getContainer( BedrockData.OVERLAY ).getChildByName( BedrockData.BLOCKER ).hide();
		}
	}

}