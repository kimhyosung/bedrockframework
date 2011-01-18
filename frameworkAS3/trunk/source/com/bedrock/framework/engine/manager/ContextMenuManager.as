package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.storage.HashMap;
	
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class ContextMenuManager
	{
		private var _menu:ContextMenu;
		private var _items:HashMap;
		
		public function ContextMenuManager()
		{
		}
		public function initialize():void
		{
			Bedrock.logger.status( "Initialized" );
			this._items = new HashMap;
			this.createMenu();
			this._createModuleItems();
		}
		private function createMenu():void
		{
			this._menu = new ContextMenu();
			this._menu.hideBuiltInItems();
            this._menu.builtInItems.print = true;
		}
		private function _createModuleItems():void
		{
			var modules:Array = Bedrock.engine::moduleManager.filterModules( BedrockData.INDEXED, true );
			for ( var p:int = 0; p < modules.length; p ++ ) {
				this._createItem( modules[ p ].id, modules[ p ].label, this._onModuleSelected, ( p == 0 ) );
			}
		}
		
		private function _createItem( $id:String, $label:String, $handler:Function, $separatorBefore:Boolean = false, $enabled:Boolean = true, $visible:Boolean = true ):void
		{
			var objItem:ContextMenuItem = new ContextMenuItem( $label, $separatorBefore, $enabled, $visible );
			objItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, $handler );
			this._menu.customItems.push( objItem );
			this._items.saveValue( $label, $id );
		}
		/*
		Event Handlers
		*/
		private function _onModuleSelected( $event:ContextMenuEvent ):void
		{
			Bedrock.engine::transitionController.transition( this._items.getValue( $event.target.caption ) );
		}
		/*
		Property Definitions
		*/
		public function get menu():ContextMenu
		{
			return this._menu;
		}
	}
}