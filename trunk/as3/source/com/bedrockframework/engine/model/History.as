package com.bedrockframework.engine.model
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.engine.api.IHistory;
	import com.bedrockframework.plugin.storage.SuperArray;

	public class History extends BasicWidget implements IHistory
	{
		/*
		Variable Declarations
		*/
		private var _objCurrent:Object;
		private var _arrHistory:SuperArray;
		/*
		Constructor
		*/
		public function History()
		{
			this._arrHistory = new SuperArray();
			this._arrHistory.wrapIndex = false;
		}

		
		public function addHistoryItem($info:Object):void
		{
			this._arrHistory.unshift($info);
		}
		
		public function getHistoryItem($index:Number):Object
		{
			return this._arrHistory.getItemAt($index);
		}
		/*
		Get Current Queue
		*/
		public function get current():Object
		{
			try {
				return this._arrHistory[0];
			} catch($e:Error) {				
			}
			return null;
		}
		/*
		Get Previous Queue
		*/
		public function get previous():Object
		{
			try {
				return this._arrHistory[1];
			} catch($e:Error) {
			}
			return null;
		}
		/*
		Get History
		*/
		public function get list():Array
		{
			return this._arrHistory.data;
		}
		
	}
}