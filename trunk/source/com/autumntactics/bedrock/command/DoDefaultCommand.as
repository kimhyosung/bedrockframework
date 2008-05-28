package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.dispatcher.BedrockDispatcher;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.manager.ContainerManager;
	import com.autumntactics.bedrock.manager.SectionManager;
	import com.autumntactics.bedrock.manager.URLManager;
	import com.autumntactics.bedrock.model.Config;
	import com.autumntactics.bedrock.model.Params;
	import com.autumntactics.loader.VisualLoader;

	public class DoDefaultCommand extends Command implements ICommand
	{
		public function DoDefaultCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			// Alex!
			// Have this class be the one that references other places to get the default value... hope that made sense.
			var strDefaultAlias:String;
			try {
				strDefaultAlias=$event.details.alias;
				this.status("Pulling from Event - " + strDefaultAlias);
			} catch ($e:Error) {
				if (Config.getSetting("deep_linking")){
					strDefaultAlias=URLManager.getCleanPath();
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
				SectionManager.container = ContainerManager.getContainer("section") as VisualLoader;
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strDefaultAlias}));
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,this));
			}
		}
	}

}