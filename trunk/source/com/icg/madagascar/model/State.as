package com.icg.madagascar.model
{
	import com.icg.madagascar.base.StaticWidget;
	
	import com.icg.madagascar.output.Outputter;
	import com.icg.storage.HashMap;
	import com.icg.util.*;
	public class State extends StaticWidget
	{

		private static  var OUTPUT:Outputter=new Outputter(State);
		private static  var STR_CURRENT:String;
		private static  var STR_PREVIOUS:String;
		public static  var INITIALIZED:String="initialized";
		public static  var AVAILABLE:String="available";
		public static  var UNAVAILABLE:String="unavailable";

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
					State.OUTPUT.output("Changing state to - " + State.STR_CURRENT);
				} else {
					State.OUTPUT.output("No stage change!","warning");
				}
			} catch ($e:Error) {
				State.OUTPUT.output("State does not exist!","error");
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