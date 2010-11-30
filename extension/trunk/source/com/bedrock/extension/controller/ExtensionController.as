package com.bedrock.extension.controller
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.extension.event.ExtensionEvent;
	import com.bedrock.extension.model.*;
	import com.bedrock.extension.view.ExtensionSettingsView;
	import com.bedrock.extension.view.ProjectCreationView;
	import com.bedrock.extension.view.ProjectUpdateView;
	import com.bedrock.extras.util.StringUtil;
	import com.bedrock.extras.util.VariableUtil;
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	
	import flash.system.ApplicationDomain;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.modules.ModuleLoader;
	
	public class ExtensionController extends StandardBase
	{
		/*
		Variable Delcarations
		*/
		
		private static var __objInstance:ExtensionController;
		
		public var root:UIComponent;
		
		public var moduleLoader:ModuleLoader;
		[Bindable]
		public var settingsXML:XML;
		[Bindable]
		public var projectXML:XML;
		[Bindable]
		public var templates:Array;
		[Bindable]
		public var versions:Array;
		
		public var delegate:JSFLDelegate;
		[Bindable]
		public var namingConventions:NamingConventionModel;
		
		private var _projectCreationView:ProjectCreationView;
		private var _projectUpdateView:ProjectUpdateView;
		private var _extensionSettingsView:ExtensionSettingsView;
		/*
		Constructor
		*/
		public function ExtensionController($singletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():ExtensionController
		{
			if (ExtensionController.__objInstance == null) {
				ExtensionController.__objInstance = new ExtensionController(new SingletonEnforcer);
			}
			return ExtensionController.__objInstance;
		}
		public function initialize( $root:UIComponent ):void
		{
			this.root = $root;
			
			this._createDelegate();
			this._createModuleLoader();
			
			this.loadSettings();
			this.loadVersions();
			
			this._projectCreationView = new ProjectCreationView;
			this._projectCreationView.initialize();
			this._projectUpdateView = new ProjectUpdateView;
			this._projectUpdateView.initialize();
			this._extensionSettingsView = new ExtensionSettingsView;
			this._extensionSettingsView.initialize();
			
			this.namingConventions = new NamingConventionModel;
			this.namingConventions.initialize( this.delegate );
			
			BedrockDispatcher.addEventListener( ExtensionEvent.PROJECT_UPDATE, this._onProjectUpdate );
			
			this.loadMostRecentProject();
		}
		private function _createDelegate():void
		{
			this.delegate = new JSFLDelegate();
			this.delegate.initialize( "Bedrock Framework/BedrockBridge.jsfl" );
			this.delegate.initializeBedrockPanel();
		}
		private function _createModuleLoader():void
		{
			this.moduleLoader = new ModuleLoader();
			this.moduleLoader.applicationDomain = ApplicationDomain.currentDomain;
			this.moduleLoader.id = "projectPanelLoader";
			this.moduleLoader.percentWidth = 100;
			this.moduleLoader.percentHeight = 100;
		}
		
		/*
		Settings Functions
		*/
		/*
		Load Versions
		*/
	 	public function loadVersions():void
		{
			this.versions = this.delegate.getBedrockVersions().split( "," );
		}
		/*
		Load/ Save Settings
		*/
	 	public function loadSettings():void
		{
			var strContent:String = this.delegate.openRelativeFile( "settings.bedrock" );
			if ( strContent != "" ) {
				this.settingsXML = new XML( strContent );
			} else {
				this.createSettings();
			}
		}
	 	public function createSettings():void
		{
			this.settingsXML = new XML( <settings>
				<autoLoadMostRecentProject >false</autoLoadMostRecentProject>
				<mostRecentProjectPath/>
				<autoSaveConfigChanges>true</autoSaveConfigChanges>
				<addBedrockToClassPaths>false</addBedrockToClassPaths>
				<includeSubFoldersInProjectBrowser>true</includeSubFoldersInProjectBrowser>
				<projects/>
			</settings> );

			this.saveSettings();
		}
		public function saveSettings():void
		{
			this.delegate.saveSettingsFile( this.settingsXML.toXMLString() );
		}
		
		/*
		Add/ Remove Projects
		*/
		public function registerProject( $data:XML ):void
		{
			var xmlSearchResult:XML = this.settingsXML.projects..project.( @name == $data.@name )[ 0 ];
			if ( xmlSearchResult == null ) {
				var xmlProject:XML = new XML( <project id={ $data.@id } name={ $data.@name } path={ $data.path } frameworkVersion={ $data.frameworkVersion } created={ $data.created } /> );
				this.settingsXML.projects.appendChild( xmlProject );
				this.saveSettings();
			}
		}
		public function removeProject( $id:String ):void
		{
			delete this.settingsXML.projects..project.( @id == $id )[ 0 ];
			this.saveSettings();
		}
		/*
		Class Path Functions
		*/
		public function createClassPath( $version:String ):void
		{
			this.delegate.changeBedrockClassPath( $version );
		}
		public function deleteClassPath():void
		{
			this.delegate.deleteBedrockClassPath();
		}
	 	/*
	 	Recent Project Function
	 	*/
		public function setMostRecentProject( $path:String ):void
		{
			this.settingsXML.mostRecentProjectPath = $path;
			this.saveSettings();
		}
		/*
		Project Functions
		*/
		
		public function selectProjectFolder():String
		{
			this.projectXML.path = this.delegate.selectProjectFolder() + "/";
			return this.projectXML.path;
		}
		public function createProject():void
		{
			this._createProjectXML();
			this.loadTemplates();
			BedrockDispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.PROJECT_CREATED, this ) );
		}
		private function _createProjectXML():void
		{
			var today:Date = new Date();
			var creationDate:String = today.getDate() + "." + today.getMonth() + "." + today.getFullYear();
			this.projectXML = new XML( <project id={ new Date().getTime() } name="" generated="false">
				  <path />
				  <rootPackage/>
				  <template>beginner</template>
				  <frameworkVersion>3.0.3</frameworkVersion>
				  <width>900</width>
				  <height>600</height>
				  <fps>30</fps>
				  <playerVersion>10</playerVersion>
				  <autoDeclareStageInstances>false</autoDeclareStageInstances>
				  <publishFiles>true</publishFiles>
				  <created>{ creationDate }</created>
				  <stageColor>0x333333</stageColor>
				  <assetsFolder>assets/</assetsFolder>
				  <sourceFolder>source/</sourceFolder>
				  <deployFolder>wwwroot/</deployFolder>
				  <flas></flas>
				</project> );
		}
		public function loadTemplates():void
		{
			this.templates = this.delegate.getTemplates( this.projectXML ).split( "," );
			ArrayUtil.findAndRemove( this.templates, "classes" );
		}
		public function findProject():Boolean
		{
			var strLocation:String = this.delegate.selectProjectFile();
			if ( strLocation != "" ) {
				this.loadProject( StringUtil.replace( strLocation, "project.bedrock", "" ), true );
				this.registerProject( this.projectXML );
				return true;
			} else {
				return false;
			}
		}
		public function loadProject( $path:String, $clearFLAs:Boolean = false ):Boolean
		{
			var strContent:String = this.delegate.openFile( $path + "project.bedrock" );
			if ( strContent != "" && strContent != null ) {
				this.projectXML = new XML( strContent );
				this.projectXML.path = $path;
				
				this.setMostRecentProject( $path );
				
				if ( $clearFLAs ) {
					delete this.projectXML.flas;
					this.projectXML.appendChild( <flas/> );
				}
				
				var configXML:XML = new XML( this.delegate.openConfig( this.projectXML ) );
				var resourceXML:XML = new XML( this.delegate.getSelectedResourceBundle( this.projectXML ) );
				
				this.moduleLoader.loadModule( this.delegate.getSelectedProjectPanelPath( this.projectXML ) );
				
				ProjectController.getInstance().initialize( resourceXML, this.settingsXML, this.projectXML, configXML );
				ExtrasController.getInstance().initialize( this.projectXML, this.delegate );
				
				BedrockDispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.PROJECT_LOADED, this ) );
				return true;
			} else { 
				return false;
			}
		}
		public function loadMostRecentProject( $force:Boolean = false ):Boolean
		{
			if ( VariableUtil.sanitizeBoolean( this.settingsXML.autoLoadMostRecentProject ) ) {
				if ( this.settingsXML.projects.children().length() > 0 ) {
					if ( this.loadProject( this.settingsXML.mostRecentProjectPath ) ) {
						return true;
					} else {
						Alert.show( "Failed to open most recent project!", "Attention!" );
						this.settingsXML.mostRecentProjectPath = "";
					}
				}
			} else {
				this._createProjectXML();
			}
			return false;
		}
		public function saveProject():void
		{
			this.delegate.saveProjectFile( this.projectXML );
		}
		
		
		
		public function updateProject( $switchFrameworkVersion:Boolean = false ):void
		{
			var xmlSearchResult:XML = this.settingsXML.projects..project.( @id == this.projectXML.@id )[ 0 ];
			if ( xmlSearchResult != null ) {
				xmlSearchResult.@name = this.projectXML.@name;
				xmlSearchResult.@version = this.projectXML.frameworkVersion;
				this.saveSettings();
			}
			
			this.delegate.updateProject( this.projectXML, $switchFrameworkVersion );
			this.saveProject();
		}
		public function generateProject():Boolean
		{
			if ( this.projectXML.rootPackage != "" && this.projectXML.path != "" && this.projectXML.@name != "") {
				this.projectXML.@generated = true;
				this.delegate.generateProject( this.projectXML );
				this.saveProject();
				this.registerProject( this.projectXML );
				this.loadProject( this.projectXML.path );
				BedrockDispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.PROJECT_GENERATED, this ) );
				return true;
			} else {
				return false;
			}
			
		}
		/*
		Popup Functions
		*/
		public function showUpdateProject():void
		{
			this._projectUpdateView.populate();
			
			PopUpManager.addPopUp( this._projectUpdateView, this.root, true );
			PopUpManager.centerPopUp( this._projectUpdateView );
		}
		public function showCreateProject():void
		{
			this.createProject();
			
			this._projectCreationView.populate();
			
			PopUpManager.addPopUp( this._projectCreationView, this.root, true );
			PopUpManager.centerPopUp( this._projectCreationView );
		}
		public function showSettings():void
		{
			this._extensionSettingsView.populate();
			
			PopUpManager.addPopUp( this._extensionSettingsView, this.root, true );
			PopUpManager.centerPopUp( this._extensionSettingsView );
		}
		/*
		Event Handlers
		*/
		private function _onProjectUpdate( $event:ExtensionEvent ):void
		{
			this.showUpdateProject();
		}
		/*
		Property Definitions
		*/
	}
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}