package com.bedrock.framework.engine.api
{
	import com.bedrock.framework.engine.data.*;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public interface ILoadController
	{
		function initialize( $builder:*, $applicationDomain:ApplicationDomain ):void;
		function load():void;
		function pause():void;
		function resume():void;
		function appendLoader( $loader:* ):void;
		function appendModule( $module:BedrockModuleData ):void;
		function disposeModule( $id:String ):void;
		function hasLoader( $nameOrURL:String ):Boolean;
		function appendAssetGroup( $assetGroup:BedrockAssetGroupData ):void;
		function appendAsset( $asset:BedrockAssetData ):void;
		function getLoader( $nameOrURL:String ):*;
		function getLoaderContent( $nameOrURL:String ):*;
		function getRawLoaderContent( $nameOrURL:String ):*;
		function getLoaderContext():LoaderContext;
		function set maxConnections( $count:uint ):void;
		function get maxConnections():uint;
		function get empty():Boolean;
	}
}