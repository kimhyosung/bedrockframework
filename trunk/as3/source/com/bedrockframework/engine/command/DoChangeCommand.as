﻿package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.TransitionManager;
	import com.bedrockframework.engine.model.Config;
	import com.bedrockframework.engine.model.Queue;
	
	public class DoChangeCommand extends Command implements ICommand
	{
		public function DoChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var strAlias:String = $event.details.alias;
			
			if (Config.getPage(strAlias)){
				if (Queue.current == null || Queue.current.alias != strAlias) {
					this.status("Transitioning to - " + strAlias);
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SHOW_BLOCKER,this));
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strAlias}));
					TransitionManager.pageView.outro();
				} else {
					this.warning("Page '" + strAlias + "' is currently loaded!");
				}
			}
		}
	}

}