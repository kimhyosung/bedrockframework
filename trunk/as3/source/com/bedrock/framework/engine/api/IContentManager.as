package com.bedrock.framework.engine.api
{

	public interface IContentManager
	{
		function initialize( $data:XML ):void;
		function addContent( $id:String, $data:Object ):void;
		function getContent( $id:String ):Object;
		function filterContent( $field:String, $value:* ):Array;
		function get data():Array;
		
	}
}