package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.*;
	import com.bedrockframework.plugin.loader.VisualLoader;

	public class LoadQueueCommand extends Command implements ICommand
	{
		public function LoadQueueCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objSection:Object=Queue.loadQueue();
			
			if (objSection) {
				if (objSection.files != null) {
					var numLength:Number=objSection.files.length;
					for (var i:Number=0; i < numLength; i++) {
						LoadManager.addToQueue(objSection.files[i]);
					}
				} else {
					this.status("No additional files to load!");
				}
				var strPath:String;
				if (objSection.url != null) {
					strPath = objSection.url;
				} else {
					if (Config.getSetting("environment") == "local") {
						strPath = objSection.alias + ".swf";
					} else {
						strPath = Config.getValue("swf_path") + objSection.alias + ".swf";
					}		
				}						
				LoadManager.addToQueue(strPath,ContainerManager.getContainer("section"));
				TransitionManager.sectionLoader = ContainerManager.getContainer("section") as VisualLoader;
			}
			LoadManager.loadQueue();
		}
	}

}