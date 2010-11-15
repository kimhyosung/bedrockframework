package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.engine.api.IContentManager;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.bedrock.framework.plugin.util.CoreUtil;
	import com.bedrock.framework.plugin.util.XMLUtil2;

	public class ContentManager extends StandardBase implements IContentManager
	{
		/*
		Variable Declarations
		*/
		private var _contents:Array;
		/*
		Constructor
		*/
		public function ContentManager()
		{
		}
		
		public function initialize( $data:XML ):void
		{
			this._parse( $data );
			this._prepareShell();
		}
		private function _parse( $data:XML ):void
		{
			this._contents = new Array;
			var contentObj:Object;
			var subContentObj:Object;
			for each( var contentXML:XML in $data.children() ) {
				contentObj = this._getContentAsObject( contentXML );
				
				for each( var subContentXML:XML in contentXML..content ) {
					subContentObj = this._getContentAsObject( subContentXML, true );
					contentObj.deeplink += subContentObj.id + "/";
					
					contentObj.contents.push( subContentObj );
					this._contents.push( subContentObj );
				}
				contentObj.contents.sortOn( "priority", Array.DESCENDING | Array.NUMERIC );
				this._contents.push( contentObj );
			}
			this._contents.sortOn( "priority", Array.DESCENDING | Array.NUMERIC );
		}
		private function _prepareShell():void
		{
			var shell:Object = this.getContent( BedrockData.SHELL );
			if ( shell.id == BedrockData.SHELL ) {
				shell[ BedrockData.DEFAULT ] = false;
				shell.indexed= false;
			}
		}
		private function _getContentAsObject( $content:XML, $child:Boolean = false ):Object
		{
			var contentObj:Object = XMLUtil2.getAttributesAsObject( $content );
			contentObj.assets = new Array;
			contentObj.deeplink = "/" + contentObj.id + "/";
			for each( var assetXML:XML in $content..asset ) {
				contentObj.assets.push( XMLUtil2.getAttributesAsObject( assetXML ) );
			}
			contentObj.contents = new Array;
			if ( $child ) {
				contentObj[ BedrockData.DEFAULT ] = false;
			}
			return contentObj;
		}
		public function addContent( $id:String, $data:Object ):void
		{
			$data.id = $id;
			this._contents.push( $data );
		}
		public function addAssetToContent( $contentID:String, $asset:Object ):void
		{
			if ( this.hasContent( $contentID ) && CoreUtil.objectHasValues( $asset, [ "id", "path", "file", "type" ] ) ) {
				var content:Object = this.getContent( $contentID );
				content.assets.push( $asset );
			}  else {
				this.warning( "Content \"" + $contentID + "\" does not exist!" );
			}
		}
		public function getContent( $id:String ):Object
		{
			return this._contents[ ArrayUtil.findIndex( this._contents, $id, "id" ) ];
		}
		public function hasContent( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this._contents, $id, "id" );
		}
		public function filterContent( $field:String, $value:* ):Array
		{
			return ArrayUtil.filter( this._contents, $value, $field );
		}
		
		public function get data():Array
		{
			return this._contents;
		}
		
	}
}