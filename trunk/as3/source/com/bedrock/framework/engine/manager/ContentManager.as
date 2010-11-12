package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.engine.api.IContentManager;
	import com.bedrock.framework.engine.data.BedrockData;

	import com.bedrock.framework.plugin.util.XMLUtil2;
	import com.bedrock.framework.plugin.util.ArrayUtil;

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
		}
		private function _parse( $data:XML ):void
		{
			this._contents = new Array;
			var contentObj:Object;
			var subContentObj:Object;
			for each( var contentXML:XML in $data.children() ) {
				contentObj = XMLUtil2.getAttributesAsObject( contentXML );
				contentObj.assets = new Array;
				contentObj.deeplink = "/" + contentObj.id + "/";
				for each( var assetXML:XML in contentXML..asset ) {
					contentObj.assets.push( XMLUtil2.getAttributesAsObject( assetXML ) );
				}
				contentObj.contents = new Array;
				for each( var subContentXML:XML in contentXML..content ) {
					subContentObj = XMLUtil2.getAttributesAsObject( subContentXML );
					subContentObj[ BedrockData.DEFAULT ] = false;
					contentObj.deeplink += subContentObj.id + "/";
					contentObj.contents.push( subContentObj );
					this._contents.push( subContentObj );
				}
				contentObj.contents.sortOn( "priority", Array.DESCENDING | Array.NUMERIC );
				
				if ( contentObj.id == BedrockData.SHELL ) {
					contentObj[ BedrockData.DEFAULT ] = false;
					contentObj.indexed= false;
				}
				this._contents.push( contentObj );
			}
			this._contents.sortOn( "priority", Array.DESCENDING | Array.NUMERIC );
		}
		
		public function addContent( $id:String, $data:Object ):void
		{
			$data.id = $id;
			this._contents.push( $data );
		}
		public function getContent( $id:String ):Object
		{
			return this._contents[ ArrayUtil.findIndex( this._contents, $id, "id" ) ];
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