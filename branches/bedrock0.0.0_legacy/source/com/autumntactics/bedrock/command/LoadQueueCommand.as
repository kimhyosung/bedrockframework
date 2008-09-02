package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.manager.*;
	import com.builtonbedrock.bedrock.model.Config;
	import com.builtonbedrock.bedrock.model.SectionStorage;
	import com.builtonbedrock.loader.VisualLoader;

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
				SectionManager.container = ContainerManager.getContainer("section") as VisualLoader;
			}
			LoadManager.loadQueue();
		}
	}

}