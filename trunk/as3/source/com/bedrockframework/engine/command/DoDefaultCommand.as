package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.*;
	
	import com.bedrockframework.engine.bedrock;

	public class DoDefaultCommand extends Command implements ICommand
	{
		public function DoDefaultCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objBedrockEngine:BedrockEngine = BedrockEngine.getInstance()
			if (!objBedrockEngine.config.getSetting(BedrockData.AUTO_DEFAULT_ENABLED)) {
				if (!objBedrockEngine.bedrock::state.doneDefault) {
					var strDefaultAlias:String = objBedrockEngine.bedrock::pageManager.getDefaultPage($event.details);
					this.status("Transitioning to - " + strDefaultAlias);
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strDefaultAlias}));
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,this));
					objBedrockEngine.bedrock::state.doneDefault = true;
				}
			} else {
				objBedrockEngine.bedrock::state.doneDefault = true;
			}
		}
	}

}