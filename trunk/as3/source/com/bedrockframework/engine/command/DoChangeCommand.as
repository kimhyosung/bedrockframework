package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.event.BedrockEvent;
	
	import com.bedrockframework.engine.bedrock;
	
	public class DoChangeCommand extends Command implements ICommand
	{
		public function DoChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var strAlias:String = $event.details.alias;
			var objBedrockEngine:BedrockEngine = BedrockEngine.getInstance();
			
			if (objBedrockEngine.config.getPage(strAlias)){
				if (objBedrockEngine.bedrock::pageManager.current == null || objBedrockEngine.bedrock::pageManager.current.alias != strAlias) {
					this.status("Transitioning to - " + strAlias);
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SHOW_BLOCKER,this));
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strAlias}));
					objBedrockEngine.bedrock::transitionManager.pageView.outro();
				} else {
					this.warning("Page '" + strAlias + "' is currently loaded!");
				}
			}
		}
	}

}