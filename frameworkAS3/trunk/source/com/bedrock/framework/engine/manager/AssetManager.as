package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.storage.HashMap;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.bedrock.framework.plugin.util.XMLUtil2;

	public class AssetManager
	{
		/*
		Variable Declarations
		*/
		private var _assetGroups:HashMap;
		private var _assets:Array;
		/*
		Constructor
	 	*/
	 	public function AssetManager()
		{
			super();
		}
		public function initialize( $data:XML ):void
		{
			this._parse( $data );
		}
		private function _parse( $data:XML ):void
		{
			var data:BedrockAssetData;
			this._assetGroups = new HashMap;
			this._assets = new Array;
			var assetGroupData:BedrockAssetGroupData;
			for each( var assetGroupXML:XML in $data.children() ) {
				assetGroupData = new BedrockAssetGroupData( XMLUtil2.getAttributesAsObject( assetGroupXML ) );
				for each( var assetXML:XML in assetGroupXML.children() ) {
					data = new BedrockAssetData( XMLUtil2.getAttributesAsObject( assetXML ) );
					assetGroupData.addAsset( data );
					this._assets.push( data );
				}
				this.addGroup( assetGroupData );
			}
		}
		public function getAsset( $id:String ):BedrockAssetData
		{
			return ArrayUtil.findItem( this._assets, $id, "id" );
		}
		public function hasAsset( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this._assets, $id, "id" );
		}
		public function filterAssets( $field:String, $value:* ):Array
		{
			return ArrayUtil.filter( this._assets, $value, $field );
		}
		
		public function addGroup( $group:BedrockAssetGroupData ):void
		{
			this._assetGroups.saveValue( $group.id, $group );
		}
		public function getGroup( $id:String ):BedrockAssetGroupData
		{
			return this._assetGroups.getValue( $id );
		}
		public function hasGroup( $id:String ):Boolean
		{
			return this._assetGroups.containsKey( $id );
		}
		public function filterGroups( $field:String, $value:* ):Array
		{
			return ArrayUtil.filter( this._assetGroups.getValues(), $value, $field );
		}
		
		public function addAssetToGroup( $groupID:String, $asset:BedrockAssetData ):void
		{
			var group:BedrockAssetGroupData;
			if ( this.hasGroup( $groupID ) ) {
				group = this.getGroup( $groupID );
			} else {
				group = new BedrockAssetGroupData( { id:$groupID } );
				this.addGroup( group );
			}
			if ( group != null && !group.hasAsset( $asset.id ) ) {
				group.addAsset( $asset );
				this._assets.push( $asset );
			}
		}
		public function addAsset( $asset:BedrockAssetData ):void
		{
			if ( !this.hasAsset( $asset.id ) ) {
				this.addAssetToGroup( BedrockData.SHELL, $asset );
			}
		}
	}
}