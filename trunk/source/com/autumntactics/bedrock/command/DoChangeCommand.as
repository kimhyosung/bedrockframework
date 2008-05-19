package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.command.ICommand;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.manager.SectionManager;
	import com.autumntactics.bedrock.dispatcher.BedrockDispatcher;
	import com.autumntactics.bedrock.model.SectionStorage;
	
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