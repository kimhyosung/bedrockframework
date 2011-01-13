package com.bedrock.framework.engine.data
{
	import com.bedrock.framework.plugin.util.ArrayUtil;
	
	dynamic public class BedrockAssetGroupData extends GenericData
	{
		public var id:String;
		public var initialLoad:Boolean;
		public var assets:Array;
		
		public function BedrockAssetGroupData( $data:Object )
		{
			super( $data );
			this.assets = new Array;
		}
		public function addAsset( $asset:BedrockAssetData ):void
		{
			this.assets.push( $asset );
		}
		public function filterAssets( $value:*, $field:String ):Array
		{
			return ArrayUtil.filter( this.assets, $value, $field );
		}
		public function hasAsset( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this.assets, $id, "id" );
		}
		public function getAsset( $id:String ):BedrockAssetData
		{
			return ArrayUtil.findItem( this.assets, $id, "id" );
		}
	}
}