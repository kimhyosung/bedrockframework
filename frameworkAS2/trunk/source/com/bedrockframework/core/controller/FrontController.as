﻿import com.bedrockframework.core.event.GenericEvent;
import com.bedrockframework.core.dispatcher.BedrockDispatcher;

class com.bedrockframework.core.controller.FrontController extends com.bedrockframework.core.base.StaticWidget
{
	/*
	Variable Decarations
	*/
	private var _strClassName:String = "FrontController";
	private static var __arrCommandCollection:Array;
	private static var __bolInitialized:Boolean;
	
	/*
	Initialize the FrontController
	*/
	public static function initialize():Void
	{
		if (!FrontController.__bolInitialized) {
			BedrockDispatcher.initialize();
			trace("[FrontController] : Initialized");
			FrontController.__arrCommandCollection = new Array();
			FrontController.__bolInitialized = true;
		}
	}

	public static function addCommand($type:String, $command):Void
	{
		if (FrontController.__bolInitialized) {
			FrontController.__arrCommandCollection.push({type:$type, command:$command});
			BedrockDispatcher.addEventListener($type,FrontController.executeCommand);
		} else {
			trace("[FrontController] [Error] : Controller has not been initialized!");
		}
	}
	public static function removeCommand($type:String, $command):Void
	{
		if (FrontController.__bolInitialized) {
			var numLength:Number = FrontController.__arrCommandCollection.length;
			for (var i:Number = 0; i < numLength; i++) {
				if (FrontController.__arrCommandCollection[i].command == $command) {
					FrontController.findAndRemove($command);
				}
			}
		} else {
			trace("[FrontController] [Error] : Controller has not been initialized!");
		}
	}
	
	private static function executeCommand($event:GenericEvent):Void
	{
		var arrResults:Array = FrontController.searchCommands($event.type);
		for (var i = 0; i < arrResults.length; i++) {
			var objCommand:Object = new arrResults[i].command();
			objCommand.execute($event);
		}
	}
	
	private static function searchCommands($type:String):Array
	{
		var arrResults:Array = new Array();
		var numLength:Number = FrontController.__arrCommandCollection.length;
		for (var i:Number = 0; i < numLength; i++) {
			if (FrontController.__arrCommandCollection[i].type == $type) {
				arrResults.push(FrontController.__arrCommandCollection[i]);
			}
		}
		return arrResults;
	}
	
	private static function findAndRemove($class):Void
		{
			var numIndex:Number;
			var numLength:Number = FrontController.__arrCommandCollection.length;
			for (var i:Number=0; i < numLength; i++) {
				if (FrontController.__arrCommandCollection[i].command === $class) {
					numIndex = i;
				}
			}
			FrontController.__arrCommandCollection.splice(numIndex,1)
		}
}