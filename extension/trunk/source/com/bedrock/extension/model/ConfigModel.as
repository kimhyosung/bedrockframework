package com.bedrock.extension.model
{
	import com.bedrock.extension.data.OptionData;
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.extension.event.ExtensionEvent;
	import com.bedrock.framework.engine.Bedrock;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalData;
	import mx.controls.Alert;

	public class ConfigModel
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
		public var containerParentArray:ArrayCollection;
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
		public var contentAssetGroupsArray:ArrayCollection;
		[Bindable]
		public var assets:XMLList;
		[Bindable]
		public var assetGroupsArray:ArrayCollection;
		[Bindable]
		public var assetHierarchy:HierarchicalData;
		[Bindable]
		public var environments:XMLList;
		[Bindable]
		public var environmentsArray:ArrayCollection;
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
			this.refreshEnvironmentsArray();
			this._storePaths();
			
			Bedrock.dispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.CONFIG_LOADED, this ) );
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
			this.updateBytes( xmlData );
			
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
			this.contentAssetGroupsArray = new ArrayCollection;
			this.assetGroupsArray = new ArrayCollection;
			this.contentAssetGroupsArray.addItem( OptionData.NONE );
			
			var assetXML:XML;
			for each( assetXML in this.assets.children() ) {
				this.contentAssetGroupsArray.addItem( VariableUtil.sanitize( assetXML.@id ) );
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
			this.containerParentArray = new ArrayCollection;
			this.containerArray.addItem( OptionData.NONE );
			this.containerArray.addItem( OptionData.ROOT );
			this.containerParentArray.addItem( OptionData.ROOT );
			for each( var containerXML:XML in this.containers..container ) {
				this.containerArray.addItem( VariableUtil.sanitize( containerXML.@id ) );
				this.containerParentArray.addItem( VariableUtil.sanitize( containerXML.@id ) );
			}
		}
		public function refreshContainerHierarchy():void
		{
			this.containerHierarchy = new HierarchicalData( this.containers.children() );
		}
		/*
		*/
		private function refreshEnvironmentsArray():void
		{
			this.environmentsArray = new ArrayCollection;
			for each( var environmentXML:XML in this.environments..environment ) {
				this.environmentsArray.addItem( VariableUtil.sanitize( environmentXML.@id ) );
			}
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
		Audit File Size
		*/
		
		public function updateBytes( $target:XML ):void
		{
			var filePath:String;
			var defaultEnvironment:XML = this.configXML.environments..environment.( @id == BedrockData.DEFAULT )[ 0 ];
			var pathXML:XML;
			
			switch ( $target.name().toString() ) {
				case "asset" :
					if ( $target.@path != BedrockData.NONE ) {
						pathXML = defaultEnvironment..path.( @id == $target.@path )[ 0 ];
						filePath = pathXML.@value;
						filePath +=  $target.@defaultURL;
					} else {
						filePath = VariableUtil.sanitize( $target.@defaultURL );
					}
					break;
				case "content" :
					pathXML = defaultEnvironment..path.( @id == "swfPath" )[ 0 ];
					filePath = pathXML.@value;
					filePath +=  $target.@id + ".swf";
					break;
			} 
			
			filePath = VariableUtil.sanitize( projectXML.path ) + VariableUtil.sanitize( projectXML.deployFolder ) + filePath;
			filePath = filePath.split( "../" ).join( "assets/" );
			
			$target.@estimatedBytes = this.delegate.getSize( filePath );
		}
		public function updateAssetBytes():void
		{
			for each ( var assetXML:XML in this.configXML.assets..asset ) {
				this.updateBytes( assetXML );
			}
			this.autoSaveConfig();
		}
		public function updateContentBytes():void
		{
			for each ( var contentXML:XML in this.configXML.contents..content ) {
				this.updateBytes( contentXML );
			}
			this.autoSaveConfig();
		}
		/*
		Event Handlers
		*/
		
		/*
		Property Definitions
		*/
	}
}
