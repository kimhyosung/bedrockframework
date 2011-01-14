package com.bedrock.extension.view.cells
{
	
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import mx.controls.listClasses.IListItemRenderer;

	public class ModuleAutoDisposeAssetsCell extends GenericCheckBoxCell implements IListItemRenderer
	{
		
		public function ModuleAutoDisposeAssetsCell()
		{
			
		}
		
		public function update():void
		{
			this.rawData.@[ BedrockData.AUTO_DISPOSE_ASSETS ] = this.checkBox.selected;
		}
		public function populate( $data:Object ):void
		{
			if ( this.rawData.name() == "module" ) {
				this.checkBox.visible = true;
				this.checkBox.selected = VariableUtil.sanitize( this.rawData.@[ BedrockData.AUTO_DISPOSE_ASSETS ] );
				this.checkBox.toolTip = "Dispose assets on clear complete.";
			} else {
				this.checkBox.visible = false;
			}
		}
		
		
	}
}