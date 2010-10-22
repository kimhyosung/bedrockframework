﻿/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@builtonbedrock.com
 * website: http://www.builtonbedrock.com/
 * blog: http://blog.builtonbedrock.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.core.controller
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.core.util.ClassUtil;

	public class FrontController extends BasicWidget implements IFrontController
	{
		/*
		Variable Declarations
		*/
		private var _arrCommandsCollection:Array;
		/*
		Constructor
		*/
		public function FrontController()
		{
			this._arrCommandsCollection=new Array  ;
		}
		
		public function initialize():void
		{
		}
		
		public function addCommand($type:String,$command:Class):void
		{
			this._arrCommandsCollection.push({type:$type,command:$command});
			BedrockDispatcher.addEventListener($type,this.executeCommand);
		}
		
		private function executeCommand($event:GenericEvent):void
		{
			var arrResults:Array=this.findCommands($event.type);
			for (var i:int=0; i < arrResults.length; i++) {
				var objCommand:ICommand=new arrResults[i].command;
				objCommand.execute($event);
			}
		}
		
		public function removeCommand($type:String,$command:Class):void
		{
			var arrResults:Array=this.findCommands($type);
			for (var i:int=0; i < arrResults.length; i++) {
				if (arrResults[i].command === $command) {
					this.findAndRemove( ClassUtil.getDisplayClassName( $command ) );
					BedrockDispatcher.removeEventListener($type,this.executeCommand);
				}
			}
		}
		
		private function findCommands($type:String):Array
		{
			var arrResults:Array=new Array;
			var numLength:Number=this._arrCommandsCollection.length;
			
			for (var i:int=0; i < numLength; i++) {
				if (this._arrCommandsCollection[i].type == $type) {
					arrResults.push(this._arrCommandsCollection[i]);
				}
			}
			
			return arrResults;
		}
		
		private function findAndRemove($className:String):void
		{
			var numIndex:uint;
			var numLength:uint = this._arrCommandsCollection.length;
			for (var i:int=0; i < numLength; i++) {
				if (this._arrCommandsCollection[i].command === $className) {
					numIndex = i;
				}
			}
			this._arrCommandsCollection.splice(numIndex,1)
		}
	}
}