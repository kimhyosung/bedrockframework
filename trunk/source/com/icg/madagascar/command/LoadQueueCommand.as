package com.icg.madagascar.command
{
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.manager.*;
	import com.icg.madagascar.model.Config;
	import com.icg.madagascar.model.SectionStorage;
	import com.icg.tools.VisualLoader;

	public class LoadQueueCommand extends Command implements ICommand
	{
		public function LoadQueueCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var objSection:Object=SectionStorage.loadQueue();
			if (objSection) {
				if (objSection.files != null) {
					var numLength:Number=objSection.files.length;
					for (var i:Number=0; i < numLength; i++) {
						LoadManager.addToQueue(objSection.files[i]);
					}
				} else {
					output("No additional files to load!");
				}
				var strPath:String;
				if (Config.getSetting("environment") == "local") {
					strPath = objSection.alias + ".swf";
				} else {
					strPath = Config.getValue("swf_path") + objSection.alias + ".swf"
				}				
				LoadManager.addToQueue(strPath,ContainerManager.getContainer("section"));
				SectionManager.set(ContainerManager.getContainer("section") as VisualLoader);
			}
			LoadManager.loadQueue();
		}
	}

}