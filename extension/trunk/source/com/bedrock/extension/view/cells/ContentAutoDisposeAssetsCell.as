package com.bedrock.extension.view.cells
{
	
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import mx.controls.listClasses.IListItemRenderer;

	public class ContentAutoDisposeAssetsCell extends GenericCheckBoxCell implements IListItemRenderer
	{
		
		public function ContentAutoDisposeAssetsCell()
		{
			
		}
		
		public function update():void
		{
			this.rawData.@[ BedrockData.AUTO_DISPOSE_ASSETS ] = this.checkBox.selected;
		}
		public function populate( $data:Object ):void
		{
			if ( this.rawData.name() == "content" ) {
				this.checkBox.visible = true;
				this.checkBox.selected = VariableUtil.sanitize( this.rawData.@[ BedrockData.AUTO_DISPOSE_ASSETS ] );
				this.checkBox.toolTip = "Dispose assets on clear complete.";
			} else {
				this.checkBox.visible = false;
			}
		}
		
		
	}
}