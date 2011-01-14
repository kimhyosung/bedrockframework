package com.bedrock.extension.view.cells
{
	
	import com.bedrock.extension.controller.ProjectController;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.VariableUtil;
	import com.bedrock.framework.plugin.util.XMLUtil2;
	
	import mx.controls.listClasses.IListItemRenderer;

	public class ModuleInitialTransitionCell extends GenericCheckBoxCell implements IListItemRenderer
	{
		public function ModuleInitialTransitionCell()
		{
			
		}
		
		private function _applyToolTip():void
		{
			if ( this.checkBox.selected ) {
					this.checkBox.toolTip = "Remove from initial transition.";
			} else {
					this.checkBox.toolTip = "Add to initial transition.";
			}
		}
		
		public function update():void
		{
			this._applyToolTip();
			this.rawData.@[ BedrockData.INITIAL_TRANSITION ] = this.checkBox.selected;
			if ( this.checkBox.selected ) this.rawData.@[ BedrockData.INITIAL_LOAD ] = true;
		}
		public function populate( $data:Object ):void
		{
			this.checkBox.selected = VariableUtil.sanitize( this.rawData.@[ BedrockData.INITIAL_TRANSITION ] );
			if ( !this._isNested( this.rawData.@id ) ) {
				this.checkBox.visible = true;
				this.checkBox.enabled = true;
				this._applyToolTip();
			} else {
				this.checkBox.enabled = false;
				this.checkBox.selected = false;
				this.checkBox.toolTip = "Apply initial transition value to the parent module group.";
			}
		}
		
		private function _isNested( $id:String ):Boolean
		{
			return ( XMLUtil2.filterByAttribute( ProjectController.getInstance().config.modules.children(), "id", $id )[ 0 ] == null );
		}
		
	}
}