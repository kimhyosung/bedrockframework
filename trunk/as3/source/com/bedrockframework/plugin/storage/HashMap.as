﻿package com.bedrockframework.plugin.storage{	import flash.utils.Dictionary;	public class HashMap	{		/*		Variable Declarations		*/		private var _objDictionary:Dictionary;		/*		Constructor		*/		public function HashMap($weakReferences:Boolean = true)		{			this._objDictionary = new Dictionary($weakReferences);		}				public function importObject($keyValue:String, $data:Object):void		{			for (var i:String in $data) {				this.saveValue($data[i][$keyValue], $data[i]);			}		}		public function importObjectArray($keyValue:String, $data:Array):void		{			var numLength:int = $data.length;			for (var i:int = 0 ; i < numLength; i++) {				this.saveValue($data[i][$keyValue], $data[i]);			}		}				public function saveValue($key:*, $value:*):void		{			this._objDictionary[$key] = $value;		}		public function pullValue($key:*):*		{			var tmpReturn:* = this.getValue($key);			this.removeValue($key);			return tmpReturn;		}		public function removeValue($key:*):void		{			delete this._objDictionary[$key];		}		public function containsKey($key:*):Boolean		{			return this._objDictionary[$key] != null;		}		public function containsValue($value:*):Boolean		{			var bolResult:Boolean = false;			for (var k:* in this._objDictionary) {				if ( this._objDictionary[k] == $value ) {					bolResult = true;					break;				}			}			return bolResult;		}		public function getKey($value:*):String		{			var tmpKey:* = null;			for (var k:* in this._objDictionary) {				if ( this._objDictionary[k] == $value ) {					tmpKey = k;					break;				}			}			return tmpKey;		}		public function getKeys():Array		{			var arrKeys:Array = [];			for (var k:* in this._objDictionary) {				arrKeys.push(k);			}			return arrKeys;		}		public function getValue($key:*):*		{			if (this.containsKey($key)) {				return this._objDictionary[$key];			}		}		public function getValues():Array		{			var arrValues:Array = [];			for (var k:* in this._objDictionary) {				arrValues.push( this._objDictionary[k] );			}			return arrValues;		}						public function get isEmpty():Boolean		{			return this.size <= 0;		}		public function reset():void		{			for (var k:* in this._objDictionary) {				this._objDictionary[k] = null;			}		}		public function clear():void		{			for (var k:* in this._objDictionary) {				this.removeValue(k);			}		}		/*		Creates a brand new duplicate Hashmap.		*/		public function clone():HashMap		{			var mapClone:HashMap = new HashMap();			var arrKeys:Array = this.getKeys();			var numLength:int = arrKeys.length;			for (var i:int = 0 ; i < numLength; i++) {				mapClone.saveValue(arrKeys[i], this.getValue(arrKeys[i]))			}			return mapClone;		}		/*		Accessor Definitions	 	*/		public function get size():int		{			var numLength:int = 0;			for (var k:* in this._objDictionary) {				numLength++;			}			return numLength;		}	}}