package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.engine.api.IModuleManager;
	import com.bedrock.framework.engine.data.BedrockAssetData;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.engine.data.BedrockModuleGroupData;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.bedrock.framework.plugin.util.XMLUtil2;
	/**
	 * @private
	 */
	public class ModuleManager implements IModuleManager
	{
		/*
		Variable Declarations
		*/
		private var _modules:Array;
		/*
		Constructor
		*/
		public function ModuleManager()
		{
		}
		
		public function initialize( $data:XML ):void
		{
			this._parse( $data );
		}
		private function _parse( $data:XML ):void
		{
			this._modules = new Array;
			var moduleData:BedrockModuleData;
			for each( var moduleXML:XML in $data..module ) {
				moduleData = new BedrockModuleData( XMLUtil2.getAttributesAsObject( moduleXML ) );
				this.addModule( moduleData );
			}
			
			var moduleGroupData:BedrockModuleGroupData;
			var subModuleData:BedrockModuleData;
			for each ( var moduleGroupXML:XML in $data..moduleGroup ) {
				moduleGroupData = new BedrockModuleGroupData( XMLUtil2.getAttributesAsObject( moduleGroupXML ) );
				for each( var subModuleXML:XML in moduleGroupXML..module ) {
					subModuleData = this.getModule( subModuleXML.@id );
					subModuleData[ BedrockData.INITIAL_TRANSITION ] = false;
					moduleGroupData.modules.push ( subModuleData ); 
				}
				moduleGroupData.modules.sortOn( BedrockData.PRIORITY, Array.DESCENDING | Array.NUMERIC );
				this.addModule( moduleGroupData );
			}
			
			this._modules.sortOn( BedrockData.PRIORITY, Array.DESCENDING | Array.NUMERIC );
		}
		public function addModule( $data:BedrockModuleData ):void
		{
			if ( $data.id != null && !this.hasModule( $data.id ) ) {
				this._modules.push( $data );
			} else {
				Bedrock.logger.error( "Module missing id!" );
			}
		}
		public function addAssetToModule( $moduleID:String, $asset:BedrockAssetData ):void
		{
			if ( this.hasModule( $moduleID ) ) {
				$asset.parentModule = $moduleID;
				var module:BedrockModuleData = this.getModule( $moduleID );
				var assetGroupID:String = module.assetGroup || module.id;
				if ( Bedrock.engine::assetManager.hasGroup( assetGroupID ) ) {
					Bedrock.engine::assetManager.addAssetToGroup( assetGroupID, $asset );
				} else {
					var assetGroup:BedrockAssetGroupData = new BedrockAssetGroupData( { id:assetGroupID } );
					assetGroup.addAsset( $asset );
					Bedrock.engine::assetManager.addGroup( assetGroup );
				}
			}  else {
				Bedrock.logger.warning( "Module \"" + $moduleID + "\" does not exist!" );
			}
		}
		public function getModule( $id:String ):BedrockModuleData
		{
			if ( this.hasModule( $id ) ) {
				return this._modules[ ArrayUtil.findIndex( this._modules, $id, "id" ) ];
			} else {
				Bedrock.logger.warning( "Module \"" + $id + "\" does not exist!" );
				return null;
			}
		}
		public function hasModule( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this._modules, $id, "id" );
		}
		public function filterModules( $field:String, $value:* ):Array
		{
			return ArrayUtil.filter( this._modules, $value, $field );
		}
		
	}
}