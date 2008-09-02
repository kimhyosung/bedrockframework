package com.builtonbedrock.bedrock.model
{
	import com.builtonbedrock.bedrock.base.StaticWidget;
	import com.builtonbedrock.bedrock.logging.LogLevel;
	import com.builtonbedrock.bedrock.logging.Logger;
	import com.builtonbedrock.util.*;
	public class State extends StaticWidget
	{

		private static  var STR_CURRENT:String;
		private static  var STR_PREVIOUS:String;
		public static const INITIALIZED:String="initialized";
		public static const AVAILABLE:String="available";
		public static const UNAVAILABLE:String="unavailable";
		
		public static var siteRendered:Boolean = false;
		public static var doneDefault:Boolean = false;
		
		Logger.log(State, LogLevel.CONSTRUCTOR, "Constructed");
		
		public static  function initialize():void
		{
			State.clear();
			State.change(State.INITIALIZED);
		}
		/*
		Set 
		*/
		public static  function change($identifier:String):void
		{
			try {
				var strState:String=$identifier;
				if (strState != State.STR_CURRENT) {
					State.STR_PREVIOUS=State.STR_CURRENT;
					State.STR_CURRENT=strState;
					Logger.status(State, "Changing state to - " + State.STR_CURRENT);
				} else {
					Logger.warning(State, "No stage change!");
				}
			} catch ($e:Error) {
				Logger.error("State does not exist!");
			}
		}
		/*
		Clear 
		*/
		public static  function clear():void
		{
			State.STR_CURRENT=null;
			State.STR_PREVIOUS=null;
		}
		/*
		Get Current 
		*/
		public static  function get current():String
		{
			return State.STR_CURRENT;
		}
		/*
		Get Previous 
		*/
		public static  function get previous():String
		{
			return State.STR_PREVIOUS;
		}
	}
}