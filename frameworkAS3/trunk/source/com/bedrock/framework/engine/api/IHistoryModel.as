package com.bedrock.framework.engine.api
{
	import com.bedrock.framework.engine.data.BedrockSequenceData;
	
	public interface IHistoryModel
	{
		function appendItem( $queue:BedrockSequenceData ):void;
		function getItem( $index:Number ):BedrockSequenceData;
		function get current():BedrockSequenceData;
		function get previous():BedrockSequenceData;
		function get data():Array;
	}
}