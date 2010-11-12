package com.bedrock.framework.engine.manager
{
	/*
	Imports
	*/
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.engine.api.IAssetManager;
	import com.bedrock.framework.engine.view.IPreloader;
	import com.bedrock.framework.plugin.storage.HashMap;
	
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import com.bedrock.framework.plugin.util.ArrayUtil;

	/*
	Class Declaration
	*/
	public class AssetManager extends StandardBase implements IAssetManager
	{
		/*
		* Variable Declarations
		*/
		public static var VIEWS:String = "views";
		public static var PRELOADERS:String = "preloaders";
		public static var BITMAPS:String = "bitmaps";
		public static var SOUNDS:String = "sounds";
		
		private var _collections:HashMap;
		private var _applicationDomain:ApplicationDomain;
		/*
		Initialize the class
		*/
		public function AssetManager()
		{
			this._collections = new HashMap;
			this._collections.saveValue(AssetManager.VIEWS, new Array);
			this._collections.saveValue(AssetManager.PRELOADERS, new Array );
			this._collections.saveValue(AssetManager.BITMAPS, new Array );
			this._collections.saveValue(AssetManager.SOUNDS, new Array );
		}
		public function initialize( $applicationDomain:ApplicationDomain ):void
		{
			this._applicationDomain = $applicationDomain;
		}
		/*
		Add/ Return new preloader instance
		*/
		public function addPreloader( $id:String, $linkage:String ):void
		{
			this._registerAsset( AssetManager.PRELOADERS, $id, $linkage );
		}
		public function getPreloader( $id:String ):IPreloader
		{
			var ClassReference:Class = this._getAsset( AssetManager.PRELOADERS, $id );
			return new ClassReference;
		}
		public function hasPreloader($id:String):Boolean
		{
			return ArrayUtil.containsItem( this._getCollection( AssetManager.PRELOADERS ), $id, "id" );
		}
		/*
		Add/ Return new view instance
		*/
		public function addView($id:String, $linkage:String ):void
		{
			this._registerAsset( AssetManager.VIEWS, $id, $linkage );
		}
		public function getView($id:String):*
		{
			var ClassReference:Class = this._getAsset( AssetManager.VIEWS, $id );
			return new ClassReference;
		}
		public function hasView( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this._getCollection(AssetManager.VIEWS), $id, "id" );
		}
		public function getViews( $includeIDs:Boolean = false ):Array
		{
			return this._getInstanceCollection(AssetManager.VIEWS, this.getView, $includeIDs );
		}
		/*
		Add/ Return new bitmap instance
		*/
		public function addBitmap( $id:String, $linkage:String ):void
		{
			this._registerAsset( AssetManager.BITMAPS, $id, $linkage );
		}
		public function getBitmap( $id:String ):BitmapData
		{
			var ClassReference:Class = this._getAsset(AssetManager.BITMAPS, $id);
			return new ClassReference(0, 0);
		}
		public function hasBitmap( $id:String ):Boolean
		{
			return ArrayUtil.containsItem( this._getCollection(AssetManager.BITMAPS), $id, "id" );
		}
		public function getBitmaps( $includeIDs:Boolean = false ):Array
		{
			return this._getInstanceCollection(AssetManager.BITMAPS, this.getBitmap, $includeIDs );
		}
		/*
		Add/ Return new sound instance
		*/
		public function addSound( $id:String, $linkage:String ):void
		{
			this._registerAsset( AssetManager.SOUNDS, $id, $linkage );
		}
		public function getSound( $id:String ):Sound
		{
			var ClassReference:Class = this._getAsset( AssetManager.SOUNDS, $id );
			return new ClassReference;
		}
		public function hasSound( $id:String ):Boolean
		{
			return ArrayUtil.containsItem(this._getCollection(AssetManager.SOUNDS), $id, "id" );
		}
		public function getSounds( $includeIDs:Boolean = false ):Array
		{
			return this._getInstanceCollection( AssetManager.SOUNDS, this.getSound, $includeIDs );
		}
		/*
		Manage Classes
		*/
		private function _registerAsset($type:String, $id:String, $linkage:String ):void
		{
			this._getCollection( $type ).push( { id:$id, linkage:$linkage } );
		}
		private function _getAsset( $type:String, $id:String ):Class
		{
			var objData:Object = ArrayUtil.findItem( this._getCollection( $type ), $id, "id" );
			return this._applicationDomain.getDefinition( objData.linkage ) as Class;
		}
		private function _getCollection( $type:String ):Array
		{
			return this._collections.getValue( $type );
		}
		private function _getInstanceCollection($type:String, $creator:Function, $includeIDs:Boolean = false ):Array
		{
			var arrReturn:Array = new Array;
			var arrCollection:Array = this._getCollection($type);
			var numLength:int = arrCollection.length;
			var objData:Object;
			for (var i:int = 0 ; i < numLength; i++) {
				objData= arrCollection[ i ];
				if ( $includeIDs ) {
					arrReturn.push( { id:objData.id, value:$creator( objData.id ) } );
				} else {
					arrReturn.push( $creator( objData.id ) );
				}
			}
			return arrReturn;
		}
		
	}

}