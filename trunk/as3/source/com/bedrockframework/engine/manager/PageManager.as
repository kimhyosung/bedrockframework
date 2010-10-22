package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.IPageManager;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.view.ContainerView;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.util.ArrayUtil;
	import com.bedrockframework.plugin.util.XMLUtil2;

	public class PageManager extends BasicWidget implements IPageManager
	{
		/*
		Variable Declarations
		*/
		private var _arrPages:Array;
		/*
		Constructor
		*/
		public function PageManager()
		{
		}
		
		public function initialize( $data:XML ):void
		{
			this.parse( $data );
		}
		private function parse( $data:XML ):void
		{
			this._arrPages = new Array;
			for each( var xmlItem:XML in $data.children() ) {
				
				var objPage:Object = XMLUtil2.getAttributesAsObject( xmlItem );
				objPage.assets = new Array;
				for each( var xmlAsset:XML in xmlItem ) {
					objPage.assets.push( XMLUtil2.getAttributesAsObject( xmlAsset ) );
				}
				this._arrPages.push( objPage );
			}
		}
		/*
		*/
		public function getDefaultPage( $details:Object = null ):Object
		{
			var strDefaultID:String;
			try {
				strDefaultID=$details.id;
				this.status("Pulling from Event - " + strDefaultID);
			} catch ($e:Error) {
				if (BedrockEngine.config.getSettingValue( BedrockData.DEEP_LINKING_ENABLED ) ){
					strDefaultID = BedrockEngine.deeplinkManager.getPathHierarchy()[0];
					this.status("Pulling from URL - " + strDefaultID);
				}
			} finally {
				strDefaultID = BedrockEngine.config.getSettingValue( BedrockData.DEFAULT_PAGE );
				this.status("Pulling from Settings - " + strDefaultID);
			}
			return this.getPage( strDefaultID );
		}
		
		public function getPage( $id:String ):Object
		{
			return ArrayUtil.findItem( this._arrPages, $id, "id" );
		}
		public function addPage($id:String, $data:Object ):void
		{
			$data.id = $id;
			this._arrPages.push( $data );
		}
		
		public function get pages():Array
		{
			return this._arrPages;
		}
		
	}
}