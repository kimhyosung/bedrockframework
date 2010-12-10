package com.bedrock.extension.view.cells
{
	
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import mx.controls.listClasses.IListItemRenderer;

	public class AssetGroupInitialLoadCell extends GenericCheckBoxCell implements IListItemRenderer
	{
		public function AssetGroupInitialLoadCell()
		{
		}
		private function _applyToolTip():void
		{
			if ( this.checkBox.selected ) {
					this.checkBox.toolTip = "Remove from initial load.";
			} else {
					this.checkBox.toolTip = "Add to initial load.";
			}
		}
		
		public function update():void
		{
			this._applyToolTip();
			this.rawData.@[ BedrockData.INITIAL_LOAD ] = this.checkBox.selected;
		}
		public function populate( $data:Object ):void
		{
			if ( this.rawData.name() == "assetGroup" ) {
				this.checkBox.visible = true;
				this.checkBox.selected = VariableUtil.sanitize( this.rawData.@[ BedrockData.INITIAL_LOAD ] );
				if ( this.rawData.@id == "shell" ) this.checkBox.enabled = false;
				this._applyToolTip();
			} else {
				this.checkBox.visible = false;
			}
		}
		
	}
}