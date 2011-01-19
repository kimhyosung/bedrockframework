package com.bedrock.framework.engine.data
{
	import com.bedrock.framework.plugin.util.ArrayUtil;
	
	dynamic public class BedrockAssetGroupData extends GenericData
	{
		public var id:String;
		public var initialLoad:Boolean;
		public var contents:Array;
		
		public function BedrockAssetGroupData( $data:Object )
		{
			super( $data );
			this.contents = new Array;
		}
		public function addAsset( $asset:BedrockAssetData ):void
		{
			this.contents.push( $asset );
		}
		public function filterAssets( $field:String, $value:* ):Array
		{
			return ArrayUtil.filter( this.contents, $value, $field );
		}
		public function filterAssetsByType( $type:String ):Array
		{
			return this.filterAssets( $type, BedrockData.TYPE );
		}
		public function hasAsset( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this.contents, $id, "id" );
		}
		public function getAsset( $id:String ):BedrockAssetData
		{
			return ArrayUtil.findItem( this.contents, $id, "id" );
		}
	}
}