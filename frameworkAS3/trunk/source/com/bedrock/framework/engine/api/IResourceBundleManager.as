package com.bedrock.framework.engine.api
{
	public interface IResourceBundleManager
	{
		function parse( $data:String ):void;
		function getBundle( $id:String, $type:String = null ):*;
		function hasBundle( $id:String ):Boolean;
		function get data():XML;
	}
}