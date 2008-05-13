package com.icg.madagascar.command
{
	import com.icg.madagascar.command.ICommand;
	import com.icg.madagascar.events.GenericEvent;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.manager.SectionManager;
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.model.SectionStorage;
	
	public class DoChangeCommand extends Command implements ICommand
	{
		public function DoChangeCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			var strAlias:String = $event.details.alias
			if (SectionStorage.getSection(strAlias)){
				output("Transitioning to - " + strAlias);
				MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.SHOW_BLOCKER,this));
				MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.SET_QUEUE,this,{alias:strAlias}));
				SectionManager.outro();
			}
		}
	}

}