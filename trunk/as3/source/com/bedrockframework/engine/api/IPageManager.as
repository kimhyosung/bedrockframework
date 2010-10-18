package com.bedrockframework.engine.api
{
	import com.bedrockframework.engine.view.ContainerView;
	
	public interface IPageManager
	{
		function initialize( $data:XML ):void;
		
		function getDefaultPage($details:Object = null):Object;
		
		function getPage( $id:String ):Object;
		
		function get pages():Array;
		
	}
}