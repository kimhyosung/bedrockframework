package com.builtonbedrock.bedrock.controller
{
	import com.builtonbedrock.bedrock.dispatcher.BedrockDispatcher;
	import com.builtonbedrock.bedrock.events.GenericEvent;
	import flash.events.Event;
	import com.builtonbedrock.storage.ArrayCollection;
	import com.builtonbedrock.bedrock.base.StandardWidget;
	import com.builtonbedrock.bedrock.command.ICommand;
	import com.builtonbedrock.util.ClassUtil;

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
			BedrockDispatcher.addEventListener($type,this.executeCommand);
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
					BedrockDispatcher.removeEventListener($type,this.executeCommand);
				}
			}

		}
	}
}