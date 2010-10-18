package com.bedrockframework.engine.api
{
	import com.bedrockframework.engine.view.IPreloader;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.view.IView;
	
	public interface ITransitionManger
	{
		function initialize():void;
		function reset():void;
		/*
		Set the current container to load content into
	 	*/
	 	function set siteLoader($loader:VisualLoader):void;
		function get siteLoader():VisualLoader;
		function set pageLoader($loader:VisualLoader):void;
		function get pageLoader():VisualLoader;
		function get siteView():IView;
		function get pageView():IView;
		function set preloaderView($preloader):void;
		function get preloaderView():IPreloader;
		/*
		Set Queue
		*/
		function setQueue( $id:String ):Boolean;
		/*
		Load Queue
		*/
		function loadQueue():Object;
		/*
		Clear Queue
		*/
		function clearQueue():void;
		/*
		Get Queued Page
		*/
		function get queue():Object;
		/*
		Get Current Page
		*/
		function get current():Object;
		/*
		Get Previous Page
		*/
		function get previous():Object;
		
		function setupPageLoad($page:Object):void;
		function loadDefaultPage():void;
	}
}