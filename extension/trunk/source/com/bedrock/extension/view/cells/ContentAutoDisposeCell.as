package com.bedrock.extension.view.cells
{
	
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import mx.controls.listClasses.IListItemRenderer;

	public class ContentAutoDisposeCell extends GenericCheckBoxCell implements IListItemRenderer
	{
		
		public function ContentAutoDisposeCell()
		{
			
		}
		
		public function update():void
		{
			this.rawData.@[ BedrockData.AUTO_DISPOSE ] = this.checkBox.selected;
		}
		public function populate( $data:Object ):void
		{
			if ( this.rawData.name() == "content" ) {
				this.checkBox.visible = true;
				this.checkBox.selected = VariableUtil.sanitize( this.rawData.@[ BedrockData.AUTO_DISPOSE ] );
				this.checkBox.toolTip = "Dispose content on clear complete.";
			} else {
				this.checkBox.visible = false;
			}
		}
		
		
	}
}