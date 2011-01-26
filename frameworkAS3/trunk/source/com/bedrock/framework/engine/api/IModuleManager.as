package com.bedrock.framework.engine.api
{
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	
	public interface IModuleManager
	{
		function initialize( $data:XML ):void;
		function addModule( $data:BedrockModuleData ):void;
		function addAssetToModule( $moduleID:String, $asset:BedrockAssetData ):void;
		function getModule( $id:String ):BedrockModuleData;
		function hasModule( $id:String ):Boolean;
		function filterModules( $field:String, $value:* ):Array;
	}
}