package com.autumntactics.project.template.command
{
	import com.autumntactics.bedrock.command.*;
	import com.autumntactics.bedrock.events.GenericEvent;
	import com.autumntactics.bedrock.dispatcher.MadagascarDispatcher;
	import com.autumntactics.project.template.events.SiteEvent;

	public class DataRequestCommand extends Command implements ICommand
	{
		public function DataRequestCommand()
		{
		}
		public function execute($event:GenericEvent):void
		{
			output("Pull data from model...");
			trace($event.type);
			trace($event.origin);
			trace($event.details.form);
			var strData:String="Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";
			MadagascarDispatcher.dispatchEvent(new SiteEvent(SiteEvent.DATA_RESPONSE,this,{data:strData}));
		}
	}

}