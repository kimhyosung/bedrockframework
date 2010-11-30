package com.bedrock.extension.view.misc
{
	
	import com.bedrock.extension.controller.ProjectController;
	import com.bedrock.extras.util.VariableUtil;
	
	import flash.events.Event;
	
	import mx.controls.CheckBox;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;

	public class FLACheckBox extends UIComponent implements IListItemRenderer
	{
		public var checkBox:CheckBox;
		private var _xmlData:XML;
		
		public function FLACheckBox()
		{
			this.createCheckBox();
		}
		private function createCheckBox( $selected:Boolean = false ):void
		{
			this.checkBox = new CheckBox();
			this.checkBox.x = 5;
			this.checkBox.y = 8;
			this.checkBox.selected = $selected;
			this.checkBox.addEventListener( Event.CHANGE, this._onChange );
			
			this.addChild( this.checkBox );
		}
		private function applyToolTip():void
		{
			if ( this.checkBox.selected ) {
					this.checkBox.toolTip = "Remove document from publish list.";
			} else {
					this.checkBox.toolTip = "Add document to publish list.";
			}
		}
		
		private function _onChange( $event:Event ):void
		{
			this.applyToolTip();
			this._xmlData.@publish = this.checkBox.selected;
			//VersionController.getInstance().project.saveProject();
		}
		
		public function set data( $data:Object ):void
		{
			if ( $data != null && $data.@type == ".fla" ) {
				
				this._xmlData = ProjectController.getInstance().projectXML..file.( @name == $data.@name )[ 0 ];
				this.checkBox.enabled = !( this._xmlData.@name == "shell" );
				this.checkBox.visible = true;
				this.checkBox.selected = VariableUtil.sanitize( this._xmlData.@publish );
				this.applyToolTip();
				
				if ( this._xmlData.@name == "shell" ) {
					this.checkBox.selected = true;
					this.checkBox.toolTip = "";
				}
			
			} else {
				this._xmlData = null;
				this.checkBox.visible = false;
			}
		}
		
		public function get data():Object
		{
			return this._xmlData;
		}
		
	}
}