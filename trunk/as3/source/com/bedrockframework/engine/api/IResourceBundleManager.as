package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.loader.DataLoader;
	import com.bedrockframework.plugin.storage.HashMap;
	
	public interface IResourceBundleManager
	{
		function initialize():void;
		function parse( $data:String ):void;
		
		function getBundleAsXML( $id:String ):XML;
		function getBundleAsObject( $id:String ):Object;
		function getBundleAsHashMap( $id:String ):HashMap;
		function getBundleAsArray( $id:String ):Array;
		
		function load( $path:String ):void;
		function get loader():DataLoader;
		function get data():XML;
	}
}