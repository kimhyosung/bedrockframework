package com.bedrockframework.engine.model
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.plugin.util.*;
	public class State extends StaticWidget
	{

		private static  var __strCurrent:String;
		private static  var __strPrevious:String;
		public static const INITIALIZED:String="initialized";
		public static const AVAILABLE:String="available";
		public static const UNAVAILABLE:String="unavailable";
		
		public static var siteRendered:Boolean = false;
		public static var siteInitialized:Boolean = false;
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
				if (strState != State.__strCurrent) {
					State.__strPrevious=State.__strCurrent;
					State.__strCurrent=strState;
					Logger.status(State, "Changing state to - " + State.__strCurrent);
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
			State.__strCurrent=null;
			State.__strPrevious=null;
		}
		/*
		Get Current 
		*/
		public static  function get current():String
		{
			return State.__strCurrent;
		}
		/*
		Get Previous 
		*/
		public static  function get previous():String
		{
			return State.__strPrevious;
		}
	}
}