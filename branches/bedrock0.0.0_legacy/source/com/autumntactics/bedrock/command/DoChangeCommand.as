package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.command.ICommand;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	import com.builtonbedrock.bedrock.manager.SectionManager;
	import com.builtonbedrock.bedrock.dispatcher.BedrockDispatcher;
	import com.builtonbedrock.bedrock.model.SectionStorage;
	
	public class DoChangeCommand extends Command implements ICommand
	{
		public function DoChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var strAlias:String = $event.details.alias
			if (SectionStorage.getSection(strAlias)){
				this.status("Transitioning to - " + strAlias);
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SHOW_BLOCKER,this));
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strAlias}));
				SectionManager.outro();
			}
		}
	}

}