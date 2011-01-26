package com.bedrock.framework.engine.api
{
	import com.bedrock.framework.engine.view.IPreloader;
	
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	
	public interface ILibraryManager
	{
		function initialize( $applicationDomain:ApplicationDomain ):void;
		function registerPreloader( $id:String, $linkage:String ):void;
		function getPreloader( $id:String ):IPreloader;
		function hasPreloader($id:String):Boolean;
		function registerView($id:String, $linkage:String ):void;
		function getView($id:String):*;
		function hasView( $id:String ):Boolean;
		function getViews( $includeIDs:Boolean = false ):Array;
		function registerBitmap( $id:String, $linkage:String ):void;
		function getBitmap( $id:String ):BitmapData;
		function hasBitmap( $id:String ):Boolean;
		function getBitmaps( $includeIDs:Boolean = false ):Array;
		function registerSound( $id:String, $linkage:String ):void;
		function getSound( $id:String ):Sound;
		function hasSound( $id:String ):Boolean;
		function getSounds( $includeIDs:Boolean = false ):Array;
	}
}