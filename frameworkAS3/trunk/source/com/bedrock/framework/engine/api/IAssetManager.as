package com.bedrock.framework.engine.api
{
	import com.bedrock.framework.engine.data.*;
	
	public interface IAssetManager
	{
		function initialize( $data:XML ):void;
		function getAsset( $id:String ):BedrockAssetData;
		function hasAsset( $id:String ):Boolean;
		function filterAssets( $field:String, $value:* ):Array;
		function addGroup( $group:BedrockAssetGroupData ):void;
		function getGroup( $id:String ):BedrockAssetGroupData;
		function hasGroup( $id:String ):Boolean;
		function filterGroups( $field:String, $value:* ):Array;
		function addAssetToGroup( $groupID:String, $asset:BedrockAssetData ):void;
		function addAsset( $asset:BedrockAssetData ):void;
	}
}