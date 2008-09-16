package com.bedrockframework.plugin.storage
{
	import com.bedrockframework.core.base.StandardWidget;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class Cookie extends StandardWidget
	{
		/*
		Variable Declarations
		*/
		private var _objShared:SharedObject;
		private var _strName:String;
		/*
		Constructor
		*/
		public function Cookie($name:String)
		{
			this._strName = $name;
			this._objShared = SharedObject.getLocal(this._strName);
		}
		/*
		Clear Object
		*/
		public function clear():void
		{
			this._objShared.clear();
		}
		/*
		Getter and Setter
		*/
		public function set($name:String, $value:*):Boolean
		{
			this._objShared.data[$name] = $value;
			try {
				return this.processResult(this._objShared.flush());
			} catch($error:Error){
				this.warning("Cannot save!");
			}
			return false;
		}
		public function get($name:String):*
		{
			return this._objShared.data[$name];
		}
		/*
		Process Flush Result
		*/
		private function processResult($result:String):Boolean
		{
			var bolStatus:Boolean
			switch($result){
				case SharedObjectFlushStatus.FLUSHED:
					bolStatus = true;
					break;
				case SharedObjectFlushStatus.PENDING:
					bolStatus = false;
					break;
			}
			return bolStatus;
		}
	}
}