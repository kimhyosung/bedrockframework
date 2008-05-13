package com.icg.madagascar.model
{
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.madagascar.output.Outputter;
	import com.icg.storage.HashMap;
	import com.icg.util.*;
	public class SectionStorage extends StaticWidget
	{
		private static  var OBJ_HASH:HashMap=new HashMap();
		private static  var OUTPUT:Outputter=new Outputter(SectionStorage);
		private static  var OBJ_CURRENT:Object;
		private static  var OBJ_PREVIOUS:Object;

		/*
		Save the page information for later use.
		*/
		public static function save($sections:Array):void
		{
			var numLength:Number=$sections.length;
			for (var i:Number=0; i < numLength; i++) {
				var objSection:Object=$sections[i];
				SectionStorage.OBJ_HASH.saveValue(objSection.alias,objSection);
			}
		}
		/*
		Pull the information for a specific page.
		*/
		public static function getSection($identifier:String):Object
		{
			var objSection:Object=SectionStorage.OBJ_HASH.getValue($identifier);
			if (objSection == null) {
				SectionStorage.OUTPUT.output("Section \'" + $identifier + "\' does not exist!","warning");
			}
			return objSection;
		}
		/*
		Set Queue
		*/
		public static function setQueue($identifier:String):void
		{
			var objSection:Object=SectionStorage.getSection($identifier);
			if (objSection) {
				if (objSection != SectionStorage.OBJ_CURRENT) {
					SectionStorage.OBJ_PREVIOUS=SectionStorage.OBJ_CURRENT;
					SectionStorage.OBJ_CURRENT=objSection;
				} else {
					SectionStorage.OUTPUT.output("Section already in queue!","warning");
				}
			} else {
				SectionStorage.OUTPUT.output("Section is not storage!","warning");
			}
		}
		/*
		Get Section Names
		*/
		public static function getSectionProperties($property:String):Array {
			var arrResult:Array = new Array()
			var arrKeys:Array = SectionStorage.OBJ_HASH.getKeys()
			var numLength:Number =  arrKeys.length
			for (var i:Number=0; i < numLength; i ++) { 
				arrResult.push(SectionStorage.OBJ_HASH.getValue(arrKeys[i])[$property])
			}
			return arrResult;
		}
		/*
		Load Queue
		*/
		public static function loadQueue():Object
		{
			var objTemp:Object=SectionStorage.current;
			if (objTemp == null) {
				SectionStorage.OUTPUT.output("Queue is empty!","warning");
			}
			return objTemp;
		}
		/*
		Clear Queue
		*/
		public static function clearQueue():void
		{
			SectionStorage.OBJ_CURRENT=null;
			SectionStorage.OBJ_PREVIOUS=null;
		}
		/*
		Get Current Queue
		*/
		public static function get current():Object
		{
			return SectionStorage.OBJ_CURRENT;
		}
		/*
		Get Previous Queue
		*/
		public static function get previous():Object
		{
			return SectionStorage.OBJ_PREVIOUS;
		}
		
		public static function get sections():Array
		{
			return SectionStorage.OBJ_HASH.getValues().sortOn("order", Array.NUMERIC);
		}
	}
}