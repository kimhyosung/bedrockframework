package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.*;

	public class DoDefaultCommand extends Command implements ICommand
	{
		public function DoDefaultCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			if (!Config.getSetting(BedrockData.AUTO_DEFAULT_ENABLED)) {
				if (!State.doneDefault) {
					var strDefaultAlias:String = SectionManager.getDefaultSection($event.details);
					this.status("Transitioning to - " + strDefaultAlias);
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strDefaultAlias}));
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,this));
					State.doneDefault = true;
				}
			} else {
				State.doneDefault = true;
			}
		}
	}

}