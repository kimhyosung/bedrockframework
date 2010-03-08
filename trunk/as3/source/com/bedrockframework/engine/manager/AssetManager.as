﻿package com.bedrockframework.engine.manager{	/*	Imports	*/	import com.bedrockframework.core.base.StandardWidget;	import com.bedrockframework.engine.api.IAssetManager;	import com.bedrockframework.plugin.storage.HashMap;	import com.bedrockframework.plugin.util.ArrayUtil;		import flash.display.BitmapData;	import flash.display.MovieClip;	import flash.media.Sound;	import flash.system.ApplicationDomain;	/*	Class Declaration	*/	public class AssetManager extends StandardWidget implements IAssetManager	{		/*		* Variable Declarations		*/		public static var VIEWS:String = "views";		public static var PRELOADERS:String = "preloaders";		public static var BITMAPS:String = "bitmaps";		public static var SOUNDS:String = "sounds";				private var _arrViews:Array;		private var _arrPreloaders:Array;		private var _arrBitmaps:Array;		private var _arrSounds:Array;		private var _mapCollections:HashMap;		private var _objApplicationDomain:ApplicationDomain;		/*		Initialize the class		*/		public function AssetManager()		{			this._arrViews = new Array;			this._arrPreloaders = new Array;			this._arrBitmaps = new Array;			this._arrSounds = new Array;						this._mapCollections = new HashMap;			this._mapCollections.saveValue(AssetManager.VIEWS, this._arrViews);			this._mapCollections.saveValue(AssetManager.PRELOADERS, this._arrPreloaders);			this._mapCollections.saveValue(AssetManager.BITMAPS, this._arrBitmaps);			this._mapCollections.saveValue(AssetManager.SOUNDS, this._arrSounds);		}		public function initialize( $applicationDomain:ApplicationDomain ):void		{			this._objApplicationDomain = $applicationDomain;		}		/*		Manage Classes		*/		private function registerAsset($type:String, $alias:String, $linkage:String ):void		{			this.getCollection( $type ).push( { alias:$alias, linkage:$linkage } );		}		private function getAsset( $type:String, $alias:String ):Class		{			var objData:Object = ArrayUtil.findItem( this.getCollection( $type ), $alias, "alias" );			return this._objApplicationDomain.getDefinition( objData.linkage ) as Class;		}		private function getCollection( $type:String ):Array		{			return this._mapCollections.getValue( $type );		}		private function getInstanceCollection($type:String, $creator:Function):Array		{			var arrReturn:Array = new Array;			var arrCollection:Array = this.getCollection($type);						var numLength:int = arrCollection.length;			for (var i:int = 0 ; i < numLength; i++) {				arrReturn.push( { alias:arrCollection[ i ], value:$creator( arrCollection[ i ] ) } );			}			return arrReturn;		}		/*		Add/ Return new preloader instance		*/		public function addPreloader( $alias:String, $linkage:String ):void		{			this.registerAsset( AssetManager.PRELOADERS, $alias, $linkage );		}		public function getPreloader( $alias:String ):MovieClip		{			var ClassReference:Class = this.getAsset( AssetManager.PRELOADERS, $alias );			return new ClassReference;		}		public function hasPreloader($alias:String):Boolean		{			return ArrayUtil.containsItem( this.getCollection( AssetManager.PRELOADERS ), $alias, "alias" );		}		/*		Add/ Return new view instance		*/		public function addView($alias:String, $linkage:String ):void		{			this.registerAsset( AssetManager.VIEWS, $alias, $linkage );		}		public function getView($alias:String):*		{			var ClassReference:Class = this.getAsset( AssetManager.VIEWS, $alias );			return new ClassReference;		}		public function hasView( $alias:String ):Boolean		{			return ArrayUtil.containsItem( this.getCollection(AssetManager.VIEWS), $alias, "alias" );		}		public function getViews():Array		{			return this.getInstanceCollection(AssetManager.VIEWS, this.getView);		}		/*		Add/ Return new bitmap instance		*/		public function addBitmap( $alias:String, $linkage:String ):void		{			this.registerAsset( AssetManager.BITMAPS, $alias, $linkage );		}		public function getBitmap( $alias:String ):BitmapData		{			var ClassReference:Class = this.getAsset(AssetManager.BITMAPS, $alias);			return new ClassReference(0, 0);		}		public function hasBitmap( $alias:String ):Boolean		{			return ArrayUtil.containsItem( this.getCollection(AssetManager.BITMAPS), $alias, "alias" );		}		public function getBitmaps():Array		{			return this.getInstanceCollection(AssetManager.BITMAPS, this.getBitmap );		}		/*		Add/ Return new sound instance		*/		public function addSound( $alias:String, $linkage:String ):void		{			this.registerAsset( AssetManager.SOUNDS, $alias, $linkage );		}		public function getSound( $alias:String ):Sound		{			var ClassReference:Class = this.getAsset( AssetManager.SOUNDS, $alias );			return new ClassReference;		}		public function hasSound( $alias:String ):Boolean		{			return ArrayUtil.containsItem(this.getCollection(AssetManager.SOUNDS), $alias, "alias" );		}		public function getSounds():Array
		{
			return this.getInstanceCollection(AssetManager.SOUNDS, this.getSound);
		}	}}