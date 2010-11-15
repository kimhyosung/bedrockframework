package com.bedrock.framework.engine.api
{

	public interface IContentManager
	{
		function initialize( $data:XML ):void;
		function addContent( $id:String, $data:Object ):void;
		function addAssetToContent( $contentID:String, $asset:Object ):void;
		function getContent( $id:String ):Object;
		function hasContent( $id:String ):Boolean;
		function filterContent( $field:String, $value:* ):Array;
		function get data():Array;
		
	}
}