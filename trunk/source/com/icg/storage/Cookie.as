package com.icg.storage
{
	import com.icg.madagascar.base.StandardWidget;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class Cookie extends StandardWidget
	{
		/*
		Variable Declarations
		*/
		private var objShared:SharedObject;
		private var strName:String;
		/*
		Constructor
		*/
		public function Cookie($name:String)
		{
			this.strName = $name;
			this.objShared = SharedObject.getLocal(this.strName);
		}
		/*
		Clear Object
		*/
		public function clear():void
		{
			this.objShared.clear();
		}
		/*
		Getter and Setter
		*/
		public function set($name:String, $value:*):Boolean
		{
			this.objShared.data[$name] = $value;
			try {
				return this.processResult(this.objShared.flush());
			} catch($error:Error){
				output("Cannot save!", "warning");
			}
			return false;
		}
		public function get($name:String):*
		{
			return this.objShared.data[$name];
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