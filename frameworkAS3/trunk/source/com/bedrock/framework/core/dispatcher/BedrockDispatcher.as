/**
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
package com.bedrock.framework.core.dispatcher
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class BedrockDispatcher extends EventDispatcher implements IEventDispatcher
	{
		/*
		Variable Declarations
		*/
		private static var __instance:BedrockDispatcher;
		/*
		Constructor
		*/
		public function BedrockDispatcher( $singletonEnforcer:SingletonEnforcer )
		{
		}
		public static function get instance():BedrockDispatcher
		{
			if ( BedrockDispatcher.__instance == null ) {
				BedrockDispatcher.__instance = new BedrockDispatcher( new SingletonEnforcer );
			}
			return BedrockDispatcher.__instance;
		}
		/*
		Overrides adding additional functionality
		*/
		override public  function dispatchEvent($event:Event):Boolean
		{
			return super.dispatchEvent($event);
		}
		override public  function addEventListener($type:String,$listener:Function,$capture:Boolean=false,$priority:int=0,$weak:Boolean=true):void
		{
			super.addEventListener($type,$listener,$capture,$priority,$weak);
		}
	}
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}