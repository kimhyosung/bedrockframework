package com.bedrock.extension.model
{
	import com.bedrock.extension.controller.ProjectController;
	import com.bedrock.extension.data.OptionData;
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.extension.event.ExtensionEvent;
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalData;

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
		public var modules:XMLList;
		[Bindable]
		public var moduleHierarchy:HierarchicalData;
		[Bindable]
		public var moduleTemplateArray:ArrayCollection;
		[Bindable]
		public var moduleGroupsArray:ArrayCollection;
		[Bindable]
		public var moduleContainerArray:ArrayCollection;
		[Bindable]
		public var moduleAssetGroupsArray:ArrayCollection;
		[Bindable]
		public var assets:XMLList;
		[Bindable]
		public var assetGroupsArray:ArrayCollection;
		[Bindable]
		public var assetHierarchy:HierarchicalData;
		[Bindable]
		public var environments:XMLList;
		[Bindable]
		public var environmentIDs:ArrayCollection;
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
			this.modules = this.configXML.modules;
			this.refreshModuleArrays();
			this.refreshModuleHierarchy();
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
		public function createModule( $data:XML, $parent:String, $template:String ):Boolean
		{
			var xmlData:XML = $data;
			this.updateBytes( xmlData );
			
			if ( $parent != OptionData.NONE && $parent != OptionData.ROOT ) {
				var xmlParent:XML = this.modules.children().( @id == $parent )[ 0 ] as XML;
	        	xmlParent.appendChild( xmlData );
			} else {
	        	this.modules.appendChild( xmlData );
			}
			
			if ( $template != OptionData.NONE ) {
				var xmlTemplate:XML = this.modules..module.( @id == $template )[ 0 ] as XML;
				this.delegate.copyModule( this.projectXML, xmlData, xmlTemplate );
			}
			
			
			this.saveConfig();
			ProjectController.getInstance().browser.refresh();
			
			return true;
		}
		public function deleteModule( $details:XML ):void
		{
			delete this.modules..module.( @id == $details.@id )[ 0 ];
			this.delegate.deleteModule( this.projectXML, $details );
			ProjectController.getInstance().browser.refresh();
		}
		/*
		Content
		*/
		public function reorderModules( $modules:String ):void
		{
			for each ( var xmlItem:XML in this.configXML.modules.children() ) {
				delete this.configXML.modules..module.( @id == xmlItem.@id )[ 0 ];
			}
			
			this.configXML.modules.appendChild( new XMLList( $modules ) );
			this.refreshModuleHierarchy();
			
			this.autoSaveConfig();
		}
		public function refreshModuleArrays():void
		{
			this.moduleGroupsArray = new ArrayCollection;
			this.moduleGroupsArray.addItem( OptionData.NONE );
			
			var moduleXML:XML;
			for each( moduleXML in this.modules..moduleGroup ) {
				this.moduleGroupsArray.addItem( VariableUtil.sanitize( moduleXML.@id ) );
			}
			
			this.moduleTemplateArray = new ArrayCollection;
			for each( moduleXML in this.modules..module ) {
				if ( VariableUtil.sanitize( moduleXML.@id ) != BedrockData.SHELL ) this.moduleTemplateArray.addItem( VariableUtil.sanitize( moduleXML.@id ) );
			}
		}
		public function refreshModuleHierarchy():void
		{
			this.moduleHierarchy = new HierarchicalData( this.modules.children() );
		}
		/*
		Assets
		*/
		public function refreshAssetArrays():void
		{
			this.moduleAssetGroupsArray = new ArrayCollection;
			this.assetGroupsArray = new ArrayCollection;
			this.moduleAssetGroupsArray.addItem( OptionData.NONE );
			
			var assetXML:XML;
			for each( assetXML in this.assets.children() ) {
				this.moduleAssetGroupsArray.addItem( VariableUtil.sanitize( assetXML.@id ) );
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
			this.environmentIDs = new ArrayCollection;
			for each( var environmentXML:XML in this.environments..environment ) {
				this.environmentIDs.addItem( VariableUtil.sanitize( environmentXML.@id ) );
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
			this.autoSaveConfig();
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
			var fileName:String;
			var defaultEnvironment:XML = this.configXML.environments..environment.( @id == BedrockData.DEFAULT )[ 0 ];
			var pathXML:XML;
			
			switch ( $target.name().toString() ) {
				case "asset" :
					fileName = VariableUtil.sanitize( $target.@defaultURL );
					break;
				case "module" :
					fileName = $target.@id + ".swf";
					break;
			} 
			
			$target.@estimatedBytes = this.delegate.findFileAndGetSize( this.projectXML, fileName )
		}
		public function updateAssetBytes():void
		{
			for each ( var assetXML:XML in this.configXML.assets..asset ) {
				this.updateBytes( assetXML );
			}
			this.autoSaveConfig();
		}
		public function updateModuleBytes():void
		{
			for each ( var moduleXML:XML in this.configXML.modules..module ) {
				this.updateBytes( moduleXML );
			}
			this.autoSaveConfig();
		}
		
		
		public function generateSpecialAsset( $assetXML:XML, $copy:Boolean ):void
		{
			var groupXML:XML = this.assets..assetGroup.( @id == BedrockData.SHELL )[ 0 ];
			groupXML.appendChild( $assetXML );
			if ( $copy ) this.delegate.generateSpecialAsset( this.projectXML, $assetXML );
		}
		/*
		Event Handlers
		*/
		
		/*
		Property Definitions
		*/
	}
}
