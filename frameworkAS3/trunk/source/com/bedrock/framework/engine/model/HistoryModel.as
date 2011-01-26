package com.bedrock.framework.engine.model
{
	import com.bedrock.framework.engine.api.IHistoryModel;
	import com.bedrock.framework.engine.data.BedrockSequenceData;
	import com.bedrock.framework.plugin.storage.SuperArray;
	/**
	 * @private
	 */
	public class HistoryModel implements IHistoryModel
	{
		/*
		Variable Declarations
		*/
		private var _data:SuperArray;
		/*
		Constructor
		*/
		public function HistoryModel()
		{
			this._data = new SuperArray();
			this._data.wrapIndex = false;
		}

		
		public function appendItem( $queue:BedrockSequenceData ):void
		{
			this._data.unshift( $queue );
		}
		
		public function getItem( $index:Number ):BedrockSequenceData
		{
			return this._data.getItemAt( $index );
		}
		/*
		Get Current Queue
		*/
		public function get current():BedrockSequenceData
		{
			try {
				return this._data.getItemAt( 0 );
			} catch( $error:Error ) {				
			}
			return null;
		}
		/*
		Get Previous Queue
		*/
		public function get previous():BedrockSequenceData
		{
			try {
				return this._data.getItemAt( 1 );
			} catch( $error:Error ) {
			}
			return null;
		}
		/*
		Get History
		*/
		public function get data():Array
		{
			return this._data.source;
		}
		
	}
}