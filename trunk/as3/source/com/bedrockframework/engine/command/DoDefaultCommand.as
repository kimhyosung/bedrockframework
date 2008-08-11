package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.*;
	import com.bedrockframework.plugin.loader.VisualLoader;

	public class DoDefaultCommand extends Command implements ICommand
	{
		public function DoDefaultCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			if (!State.doneDefault) {
				// Alex!
				// Have this class be the one that references other places to get the default value... hope that made sense.
				var strDefaultAlias:String;
				try {
					strDefaultAlias=$event.details.alias;
					this.status("Pulling from Event - " + strDefaultAlias);
				} catch ($e:Error) {
					if (Config.getSetting("deep_linking")){
						strDefaultAlias=DeepLinkManager.getCleanPath();
						this.status("Pulling from URL - " + strDefaultAlias);
					}
				} finally {
					if (strDefaultAlias == null) {
						if (Params.getValue("default") == null) {
							strDefaultAlias=Config.getSetting("default_section");
							this.status("Pulling from Config - " + strDefaultAlias);
						} else {
							strDefaultAlias=Params.getValue("default");
							this.status("Pulling from Params - " + strDefaultAlias);
						}
					}
					this.status("Transitioning to - " + strDefaultAlias);
					TransitionManager.sectionLoader = ContainerManager.getContainer("section") as VisualLoader;
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strDefaultAlias}));
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,this));
				}
				State.doneDefault = true;
			}
		}
	}

}