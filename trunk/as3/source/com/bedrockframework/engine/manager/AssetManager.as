﻿package com.bedrockframework.engine.manager
{
	/*
	Imports
	*/
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.engine.api.IAssetManager;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.ArrayUtil;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	/*
	Class Declaration
	*/
	public class AssetManager extends BasicWidget implements IAssetManager
	{
		/*
		* Variable Declarations
		*/
		public static var VIEWS:String = "views";
		public static var PRELOADERS:String = "preloaders";
		public static var BITMAPS:String = "bitmaps";
		public static var SOUNDS:String = "sounds";
		
		private var _arrViews:Array;
		private var _arrPreloaders:Array;
		private var _arrBitmaps:Array;
		private var _arrSounds:Array;
		private var _mapCollections:HashMap;
		private var _objApplicationDomain:ApplicationDomain;
		/*
		Initialize the class
		*/
		public function AssetManager()
		{
			this._arrViews = new Array;
			this._arrPreloaders = new Array;
			this._arrBitmaps = new Array;
			this._arrSounds = new Array;
			
			this._mapCollections = new HashMap;
			this._mapCollections.saveValue(AssetManager.VIEWS, this._arrViews);
			this._mapCollections.saveValue(AssetManager.PRELOADERS, this._arrPreloaders);
			this._mapCollections.saveValue(AssetManager.BITMAPS, this._arrBitmaps);
			this._mapCollections.saveValue(AssetManager.SOUNDS, this._arrSounds);
		}
		public function initialize( $applicationDomain:ApplicationDomain ):void
		{
			this._objApplicationDomain = $applicationDomain;
		}
		/*
		Manage Classes
		*/
		private function registerAsset($type:String, $id:String, $linkage:String ):void
		{
			this.getCollection( $type ).push( { id:$id, linkage:$linkage } );
		}
		private function getAsset( $type:String, $id:String ):Class
		{
			var objData:Object = ArrayUtil.findItem( this.getCollection( $type ), $id, "id" );
			return this._objApplicationDomain.getDefinition( objData.linkage ) as Class;
		}
		private function getCollection( $type:String ):Array
		{
			return this._mapCollections.getValue( $type );
		}
		private function getInstanceCollection($type:String, $creator:Function, $includeAliases:Boolean = false ):Array
		{
			var arrReturn:Array = new Array;
			var arrCollection:Array = this.getCollection($type);
			var numLength:int = arrCollection.length;
			var objData:Object;
			for (var i:int = 0 ; i < numLength; i++) {
				objData= arrCollection[ i ];
				if ( $includeAliases ) {
					arrReturn.push( { id:objData.id, value:$creator( objData.id ) } );
				} else {
					arrReturn.push( $creator( objData.id ) );
				}
			}
			return arrReturn;
		}
		/*
		Add/ Return new preloader instance
		*/
		public function addPreloader( $id:String, $linkage:String ):void
		{
			this.registerAsset( AssetManager.PRELOADERS, $id, $linkage );
		}
		public function getPreloader( $id:String ):MovieClip
		{
			var ClassReference:Class = this.getAsset( AssetManager.PRELOADERS, $id );
			return new ClassReference;
		}
		public function hasPreloader($id:String):Boolean
		{
			return ArrayUtil.containsItem( this.getCollection( AssetManager.PRELOADERS ), $id, "id" );
		}
		/*
		Add/ Return new view instance
		*/
		public function addView($id:String, $linkage:String ):void
		{
			this.registerAsset( AssetManager.VIEWS, $id, $linkage );
		}
		public function getView($id:String):*
		{
			var ClassReference:Class = this.getAsset( AssetManager.VIEWS, $id );
			return new ClassReference;
		}
		public function hasView( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this.getCollection(AssetManager.VIEWS), $id, "id" );
		}
		public function getViews( $includeAliases:Boolean = false ):Array
		{
			return this.getInstanceCollection(AssetManager.VIEWS, this.getView, $includeAliases );
		}
		/*
		Add/ Return new bitmap instance
		*/
		public function addBitmap( $id:String, $linkage:String ):void
		{
			this.registerAsset( AssetManager.BITMAPS, $id, $linkage );
		}
		public function getBitmap( $id:String ):BitmapData
		{
			var ClassReference:Class = this.getAsset(AssetManager.BITMAPS, $id);
			return new ClassReference(0, 0);
		}
		public function hasBitmap( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this.getCollection(AssetManager.BITMAPS), $id, "id" );
		}
		public function getBitmaps( $includeAliases:Boolean = false ):Array
		{
			return this.getInstanceCollection(AssetManager.BITMAPS, this.getBitmap, $includeAliases );
		}
		/*
		Add/ Return new sound instance
		*/
		public function addSound( $id:String, $linkage:String ):void
		{
			this.registerAsset( AssetManager.SOUNDS, $id, $linkage );
		}
		public function getSound( $id:String ):Sound
		{
			var ClassReference:Class = this.getAsset( AssetManager.SOUNDS, $id );
			return new ClassReference;
		}
		public function hasSound( $id:String ):Boolean
		{
			return ArrayUtil.containsItem(this.getCollection(AssetManager.SOUNDS), $id, "id" );
		}
		public function getSounds( $includeAliases:Boolean = false ):Array
		{
			return this.getInstanceCollection( AssetManager.SOUNDS, this.getSound, $includeAliases );
		}
	}

}