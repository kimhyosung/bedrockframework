package com.bedrockframework.engine.api
{
	import flash.ui.ContextMenu;
	
	public interface IContextMenuManager
	{
		function initialize():void;
		function createItem( $id:String, $label:String, $handler:Function, $separatorBefore:Boolean = false, $enabled:Boolean = true, $visible:Boolean = true ):void;
		function removeItem( $id:String ):void;
		function get menu():ContextMenu;
	}
}