package com.bedrock.extension.model
{
	import com.bedrock.extension.data.OptionData;
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.extension.event.ExtensionEvent;
	import com.bedrock.extras.util.VariableUtil;
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.engine.data.BedrockData;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalData;

	public class ConfigModel extends StandardBase
	{
		/*
		Variable Delcarations
		*/
		public var delegate:JSFLDelegate;
		[Bindable]
		public var settingsXML:XML;
		[Bindable]
		public var projectXML:XML;
		[Bindable]
		public var configXML:XML;
		[Bindable]
		public var settings:XMLList;
		[Bindable]
		public var locales:XMLList;
		[Bindable]
		public var localeHierarchy:HierarchicalData;
		[Bindable]
		public var containers:XMLList;
		[Bindable]
		public var containerArray:ArrayCollection;
		[Bindable]
		public var containerHierarchy:HierarchicalData;
		[Bindable]
		public var contents:XMLList;
		[Bindable]
		public var contentHierarchy:HierarchicalData;
		[Bindable]
		public var contentTemplateArray:ArrayCollection;
		[Bindable]
		public var contentGroupsArray:ArrayCollection;
		[Bindable]
		public var contentContainerArray:ArrayCollection;
		[Bindable]
		public var assets:XMLList;
		[Bindable]
		public var assetGroupsArray:ArrayCollection;
		[Bindable]
		public var assetHierarchy:HierarchicalData;
		[Bindable]
		public var environments:XMLList;
		[Bindable]
		public var pathArray:ArrayCollection;
		
		/*
		Constructor
		*/
		public function ConfigModel()
		{
		}
		
		public function initialize( $settings:XML, $project:XML, $config:XML, $delegate:JSFLDelegate ):void
		{
			this.settingsXML = $settings;
			this.projectXML = $project;
			this.configXML = $config;
			this.delegate = $delegate;
			
			this.loadConfig();
		}
		public function loadConfig():void
		{
			XML.ignoreWhitespace = true;
			XML.ignoreComments = false;
			
			this.settings = this.configXML.settings;
			this.locales = this.configXML.locales;
			this.localeHierarchy = new HierarchicalData( this.configXML.locales.children() );
			this.containers = this.configXML.containers;
			this.refreshContainerArray();
			this.refreshContainerHierarchy();
			this.contents = this.configXML.contents;
			this.refreshContentArrays();
			this.refreshContentHierarchy();
			this.assets = this.configXML.assets;
			this.refreshAssetArrays();
			this.refreshAssetHierarchy();
			this.environments = this.configXML.environments;
			this._storePaths();
			
			BedrockDispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.CONFIG_LOADED, this ) );
		}
		
		public function saveConfig():void
		{
			this.delegate.saveConfig( this.projectXML, this.configXML );
			this.loadConfig();
		}
		public function autoSaveConfig():void
		{
			if ( VariableUtil.sanitizeBoolean( this.settingsXML.autoSaveConfigChanges ) ) {
				this.saveConfig();
			}
		}
		/*
		Creation Functions
		*/
		public function createContent( $data:XML, $parent:String, $template:String ):Boolean
		{
			var xmlData:XML = $data;
			
			if ( $parent != OptionData.NONE && $parent != OptionData.ROOT ) {
				var xmlParent:XML = this.contents.children().( @id == $parent )[ 0 ] as XML;
	        	xmlParent.appendChild( xmlData );
			} else {
	        	this.contents.appendChild( xmlData );
			}
			
			if ( $template != OptionData.NONE ) {
				var xmlTemplate:XML = this.contents..content.( @id == $template )[ 0 ] as XML;
				this.delegate.copyContent( this.projectXML, xmlData, xmlTemplate );
			}
			
			this.saveConfig();
			
			return true;
		}
		/*
		Content
		*/
		public function reorderContent( $contents:String ):void
		{
			for each ( var xmlItem:XML in this.configXML.contents.children() ) {
				delete this.configXML.contents..content.( @id == xmlItem.@id )[ 0 ];
			}
			
			this.configXML.contents.appendChild( new XMLList( $contents ) );
			this.refreshContentHierarchy();
			
			this.autoSaveConfig();
		}
		public function refreshContentArrays():void
		{
			this.contentGroupsArray = new ArrayCollection;
			this.contentGroupsArray.addItem( OptionData.NONE );
			
			var contentXML:XML;
			for each( contentXML in this.contents..contentGroup ) {
				this.contentGroupsArray.addItem( VariableUtil.sanitize( contentXML.@id ) );
			}
			
			this.contentTemplateArray = new ArrayCollection;
			for each( contentXML in this.contents..content ) {
				if ( VariableUtil.sanitize( contentXML.@id ) != BedrockData.SHELL ) this.contentTemplateArray.addItem( VariableUtil.sanitize( contentXML.@id ) );
			}
		}
		public function refreshContentHierarchy():void
		{
			this.contentHierarchy = new HierarchicalData( this.contents.children() );
		}
		/*
		Assets
		*/
		public function refreshAssetArrays():void
		{
			this.assetGroupsArray = new ArrayCollection;
			this.assetGroupsArray.addItem( OptionData.NONE );
			
			var assetXML:XML;
			for each( assetXML in this.assets.children() ) {
				this.assetGroupsArray.addItem( VariableUtil.sanitize( assetXML.@id ) );
			}
		}
		public function refreshAssetHierarchy():void
		{
			this.assetHierarchy = new HierarchicalData( this.assets.children() );
		}
		/*
		Containers
		*/
		public function reorderContainers( $containers:String ):void
		{
			for each ( var xmlItem:XML in this.configXML.containers.children() ) {
				delete this.configXML.containers..container.( @id == xmlItem.@id )[ 0 ];
			}
			
			this.configXML.containers.appendChild( new XMLList( $containers ) );
			this.refreshContainerHierarchy();
			
			this.autoSaveConfig();
		}
		public function refreshContainerArray():void
		{
			this.containerArray = new ArrayCollection;
			this.containerArray.addItem( OptionData.ROOT );
			for each( var containerXML:XML in this.containers..container ) {
				this.containerArray.addItem( VariableUtil.sanitize( containerXML.@id ) );
			}
		}
		public function refreshContainerHierarchy():void
		{
			this.containerHierarchy = new HierarchicalData( this.containers.children() );
		}
		/*
		Paths
		*/
		private function _storePaths():void
		{
			this.pathArray = new ArrayCollection;
			this.pathArray.addItem( "none" );
			for each( var pathXML:XML in this.environments..path ) {
				this.pathArray.addItem( pathXML.@id.toString() );
			}
		}
		/* 
		Settings
		*/
		public function setSettingValue( $id:String, $value:* ):void
		{
			var xmlResult:XML = this.settings..setting.(@id == $id )[ 0 ];
			xmlResult.@value = $value;
		}
		public function getSettingValue( $id:String ):*
		{
			try {
				return VariableUtil.sanitize( this.settings.children().( @id == $id )[ 0 ].@value );
			} catch( $error:Error ) {
				this.warning( "Failed to pull setting \"" + $id + "\"!" );
			}
		}
		/*
		Event Handlers
		*/
		
		/*
		Property Definitions
		*/
	}
}
