package com.bedrock.framework.engine.manager
{
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.plugin.storage.HashMap;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	
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
			this.createContentItems();
		}
		private function createMenu():void
		{
			this._menu = new ContextMenu();
			this._menu.hideBuiltInItems();
            this._menu.builtInItems.print = true;
		}
		private function createContentItems():void
		{
			var contents:Array = Bedrock.engine::contentManager.filterContent( true, "indexed" );
			for ( var p:int = 0; p < contents.length; p ++ ) {
				this.createItem( contents[ p ].id, contents[ p ].label, this._onContentSelected, ( p == 0 ) );
			}
		}
		
		private function createItem( $id:String, $label:String, $handler:Function, $separatorBefore:Boolean = false, $enabled:Boolean = true, $visible:Boolean = true ):void
		{
			var objItem:ContextMenuItem = new ContextMenuItem( $label, $separatorBefore, $enabled, $visible );
			objItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, $handler );
			this._menu.customItems.push( objItem );
			this._items.saveValue( $label, $id );
		}
		private function removeItem( $id:String ):void
		{
			this._menu.customItems.splice( ArrayUtil.findIndex( this._menu.customItems, this._items.getValue( $id ), "caption" ), 1 );
		}
		/*
		Event Handlers
		*/
		private function _onContentSelected( $event:ContextMenuEvent ):void
		{
			Bedrock.api.transition( this._items.getValue( $event.target.caption ) );
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