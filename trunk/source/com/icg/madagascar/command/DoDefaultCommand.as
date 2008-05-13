package com.icg.madagascar.command
{
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.manager.ContainerManager;
	import com.icg.madagascar.manager.SectionManager;
	import com.icg.madagascar.manager.URLManager;
	import com.icg.madagascar.model.Config;
	import com.icg.madagascar.model.Params;
	import com.icg.tools.VisualLoader;

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
				output("Pulling from Event - " + strDefaultAlias);
			} catch ($e:Error) {
				if (Config.getSetting("deep_linking")){
					strDefaultAlias=URLManager.getCleanPath();
					output("Pulling from URL - " + strDefaultAlias);
				}
			} finally {
				if (strDefaultAlias == null) {
					if (Params.getValue("default") == null) {
						strDefaultAlias=Config.getSetting("default_section");
						output("Pulling from Config - " + strDefaultAlias);
					} else {
						strDefaultAlias=Params.getValue("default");
						output("Pulling from Params - " + strDefaultAlias);
					}
				}
				output("Transitioning to - " + strDefaultAlias);
				SectionManager.set(ContainerManager.getContainer("section") as VisualLoader);
				MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.SET_QUEUE,this,{alias:strDefaultAlias}));
				MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.RENDER_PRELOADER,this));
			}
		}
	}

}