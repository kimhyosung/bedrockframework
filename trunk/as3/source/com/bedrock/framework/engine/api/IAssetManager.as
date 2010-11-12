package com.bedrock.framework.engine.api
{
	import com.bedrock.framework.engine.view.IPreloader;
	
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	
	public interface IAssetManager
	{
		function initialize( $applicationDomain:ApplicationDomain ):void;
		/*
		Add/ Return new preloader instance
		*/
		function addPreloader( $id:String, $linkage:String ):void;
		function getPreloader( $id:String ):IPreloader;
		function hasPreloader( $id:String ):Boolean;
		/*
		Add/ Return new view instance
		*/
		function addView( $id:String, $linkage:String ):void;
		function getView( $id:String ):*;
		function hasView( $id:String ):Boolean;
		function getViews( $includeIDs:Boolean = false ):Array;
		/*
		Add/ Return new bitmap instance
		*/
		function addBitmap( $id:String, $linkage:String ):void;
		function getBitmap( $id:String ):BitmapData;
		function hasBitmap( $id:String ):Boolean;
		function getBitmaps( $includeIDs:Boolean = false ):Array;
		/*
		Add/ Return new sound instance
		*/
		function addSound( $id:String, $linkage:String ):void;
		function getSound( $id:String ):Sound;
		function hasSound( $id:String ):Boolean;
		function getSounds( $includeIDs:Boolean = false ):Array;
	}
}