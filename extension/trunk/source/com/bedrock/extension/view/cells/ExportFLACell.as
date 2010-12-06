package com.bedrock.extension.view.cells
{
	
	import com.bedrock.extension.controller.ProjectController;
	import com.bedrock.framework.plugin.util.ButtonUtil;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;

	public class ExportFLACell extends UIComponent implements IListItemRenderer
	{
		private var _xmlData:XML;
		
		private var _dummy:Sprite;
		private var _normalLoader:Loader;
		private var _overLoader:Loader;
		
		public function ExportFLACell()
		{
			this.toolTip = "Export SWF";
			this.createButton();
		}
		private function createButton():void
		{
			this._overLoader = new Loader;
			this._overLoader.visible = false;
			this._overLoader.name = "over";
			this._overLoader.load( new URLRequest( "assets/ExportIconOver.png" ) );
			this._normalLoader = new Loader;
			this._normalLoader.name = "normal";
			this._normalLoader.load( new URLRequest( "assets/ExportIconNormal.png" ) );
			
			
			this._dummy = new Sprite;
			this._dummy.x = 5;
			this._dummy.y = 2;
			this.addChild( this._dummy );
			this._dummy.addChild( this._overLoader );
			this._dummy.addChild( this._normalLoader );
			ButtonUtil.addListeners( this._dummy, { down:this._onExportFLA, out:this._onRollOut, over:this._onRollOver }, false );
		}
		private function _onRollOut( $event:MouseEvent ):void
		{
			this._dummy.getChildByName( "over" ).visible = false;
			this._dummy.getChildByName( "normal" ).visible = true;
		}
		private function _onRollOver( $event:MouseEvent ):void
		{
			this._dummy.getChildByName( "normal" ).visible = false;
			this._dummy.getChildByName( "over" ).visible = true;
		}
		private function _onExportFLA( $event:MouseEvent ):void
		{
			ProjectController.getInstance().browser.exportSWF( this._xmlData );
		}
		public function set data( $data:Object ):void
		{
			if ( $data != null && $data.@type == ".fla" ) {
				this._xmlData = ProjectController.getInstance().projectXML..file.( @name == $data.@name )[ 0 ];
				this._dummy.visible = true;
			} else {
				this._xmlData = null;
				this._dummy.visible = false;
			}
		}
		
		public function get data():Object
		{
			return this._xmlData;
		}
		
	}
}