package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.dispatcher.BedrockDispatcher;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.manager.ContainerManager;
	import com.builtonbedrock.bedrock.manager.SectionManager;
	import com.builtonbedrock.bedrock.manager.URLManager;
	import com.builtonbedrock.bedrock.model.Config;
	import com.builtonbedrock.bedrock.model.Params;
	import com.builtonbedrock.bedrock.model.State;
	import com.builtonbedrock.loader.VisualLoader;

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
				State.doneDefault = true;
			}
		}
	}

}