package com.icg.madagascar.controller
{
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.events.GenericEvent;
	import flash.events.Event;
	import com.icg.storage.ArrayCollection;
	import com.icg.madagascar.base.StandardWidget;
	import com.icg.madagascar.command.ICommand;
	import com.icg.util.ClassUtil;

	public class Controller extends StandardWidget implements IController
	{
		/*
		Variable Declarations
		*/
		private var arrCommandsCollection:Array;
		/*
		Constructor
		*/
		public function Controller()
		{
			this.arrCommandsCollection=new ArrayCollection  ;
		}
		public function initialize():void
		{

		}
		public function addCommand($type:String,$command:Class):void
		{
			this.arrCommandsCollection.push({type:$type,command:$command});
			MadagascarDispatcher.addEventListener($type,this.executeCommand);
		}
		private function executeCommand($event:GenericEvent):void
		{
			var arrResults:Array=this.arrCommandsCollection.search($event.type,"type");
			for (var i=0; i < arrResults.length; i++) {
				var objCommand:ICommand=new arrResults[i].command;
				objCommand.execute($event);
			}
		}
		public function removeCommand($type:String,$command:Class):void
		{
			var arrResults:Array=this.arrCommandsCollection.search($type,"type");
			for (var i=0; i < arrResults.length; i++) {
				if (arrResults[i].command === $command) {
					this.arrCommandsCollection.findAndRemove(ClassUtil.getDisplayClassName($command),"command");
					MadagascarDispatcher.removeEventListener($type,this.executeCommand);
				}
			}

		}
	}
}