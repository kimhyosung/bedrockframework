package com.builtonbedrock.project.template.command
{
	import com.builtonbedrock.bedrock.command.*;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import com.builtonbedrock.bedrock.dispatcher.BedrockDispatcher;
	import com.builtonbedrock.project.template.events.SiteEvent;

	public class DataRequestCommand extends Command implements ICommand
	{
		public function DataRequestCommand()
		{
		}
		public function execute($event:GenericEvent):void
		{
			this.status("Pull data from model...");
			trace($event.type);
			trace($event.origin);
			trace($event.details.form);
			var strData:String="Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";
			BedrockDispatcher.dispatchEvent(new SiteEvent(SiteEvent.DATA_RESPONSE,this,{data:strData}));
		}
	}

}