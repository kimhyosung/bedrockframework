package com.bedrock.extension.controller
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.extension.event.ExtensionEvent;
	import com.bedrock.extension.model.*;
	import com.bedrock.extension.view.popups.ProjectUpdateView;
	import com.bedrock.extras.util.StringUtil;
	import com.bedrock.framework.engine.Bedrock;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.bedrock.framework.plugin.util.VariableUtil;
	import com.bedrock.framework.plugin.util.XMLUtil2;
	import com.greensock.TweenLite;
	
	import flash.system.ApplicationDomain;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.modules.ModuleLoader;
	
	public class ExtensionController
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
		public var resourceXML:XML;
		[Bindable]
		public var configXML:XML;
		[Bindable]
		public var templateXML:XML;
		[Bindable]
		public var templates:Array;
		[Bindable]
		public var versions:Array;
		[Bindable]
		public var projects:Array;
		
		public var delegate:JSFLDelegate;
		[Bindable]
		public var namingConventions:NamingConventionModel;
		
		
		private var _projectUpdateView:ProjectUpdateView;
		private var _customTemplates:Array;
		
		
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
		public function setup( $root:UIComponent ):void
		{
			this.root = $root;
		}
		public function initialize():void
		{
			this._createDelegate();
			this._createModuleLoader();
			
			this.loadSettings();
			this.loadVersions();
			
			this._projectUpdateView = new ProjectUpdateView;
			this._projectUpdateView.initialize();
			
			this.namingConventions = new NamingConventionModel;
			this.namingConventions.initialize( this.delegate );
			
			Bedrock.dispatcher.addEventListener( ExtensionEvent.SAVE_PROJECT, this._onSaveProject );
			Bedrock.dispatcher.addEventListener( ExtensionEvent.PROJECT_UPDATE, this._onProjectUpdate );
			Bedrock.dispatcher.addEventListener( ExtensionEvent.RELOAD_CONFIG, this._onReloadConfig );
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
		private function _parseProjects():void
		{
			this.projects = new Array;
			for each ( var projectXML:XML in this.settingsXML.projects..project ) {
				this.projects.push( XMLUtil2.getAttributesAsObject( projectXML ) );
			}
			this.projects.reverse();
		}
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
			this._parseProjects();
			this._parseTemplates();
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
				<templates/>
			</settings> );

			this.saveSettings();
		}
		public function saveSettings():void
		{
			this.delegate.saveSettingsFile( this.settingsXML.toXMLString() );
			Bedrock.dispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.SETTINGS_SAVED, this ) );
			this.loadSettings();
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
			Bedrock.dispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.PROJECT_CREATED, this ) );
		}
		private function _createProjectXML():void
		{
			var today:Date = new Date();
			var creationDate:String = today.getDate() + "." + ( today.getMonth() + 1 ) + "." + today.getFullYear();
			this.projectXML = new XML( <project id={ new Date().getTime() } name="" generated="false">
				  <path />
				  <rootPackage/>
				  <template>beginner</template>
				  <frameworkVersion>{ this.versions[ 0 ] }</frameworkVersion>
				  <fps>30</fps>
				  <playerVersion>10</playerVersion>
				  <autoDeclareStageInstances>false</autoDeclareStageInstances>
				  <publishProject>true</publishProject>
				  <created>{ creationDate }</created>
				  <stageColor>0x333333</stageColor>
				  <flas></flas>
				</project> );
			this.loadTemplates();
			this.loadTemplate( this.projectXML.template.toString() );
		}
		public function loadTemplates():void
		{
			this.templates = new Array;
			this._loadVersionTemplates();
			this._loadCustomTemplates();
		}
		private function _loadVersionTemplates():void
		{
			var templatesXML:XML = new XML( this.delegate.getVersionTemplates( this.projectXML ) );
			var templateSettingsXML:XML;
			var path:String;
			for each ( var templateXML:XML in templatesXML..template ) {
				templateSettingsXML = this._openTemplate( templateXML.@path );
				
				path = StringUtil.replace( VariableUtil.sanitize( templateXML.@path ), "template.bedrock", "" );
				this.templates.push( { name:VariableUtil.sanitize( templateSettingsXML.name ), path:path } );
			}
		}
		private function _loadCustomTemplates():void
		{
			for each ( var templateObj:Object in this._customTemplates ) {
				if ( templateObj.versions.length == 0 ) {
					this.templates.push( templateObj );
				} else {
					if ( ArrayUtil.containsItem( templateObj.versions, this.projectXML.frameworkVersion ) ) {
						this.templates.push( templateObj );
					}
				}
			}
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
			var rawContent:String = this.delegate.openFile( $path + "project.bedrock" );
			if ( rawContent != "" && rawContent != null ) {
				this.projectXML = new XML( rawContent );
				this.projectXML.path = $path;
				
				this.setMostRecentProject( $path );
				
				if ( $clearFLAs ) {
					delete this.projectXML.flas;
					this.projectXML.appendChild( <flas/> );
				}
				
				this.configXML = new XML( this.delegate.openConfig( this.projectXML ) );
				this.resourceXML = new XML( this.delegate.getSelectedResourceBundle( this.projectXML ) );
				
				this.moduleLoader.unloadModule();
				this.moduleLoader.loadModule( this.delegate.getSelectedProjectPanelPath( this.projectXML ) );
				
				ProjectController.getInstance().initialize( this.resourceXML, this.settingsXML, this.projectXML, this.configXML );
				ExtrasController.getInstance().initialize( this.projectXML, this.delegate );
				
				Bedrock.dispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.PROJECT_LOADED, this ) );
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
			
			if ( VariableUtil.sanitize( this.projectXML.publishProject ) ) {
				ProjectController.getInstance().browser.publishProject();
			}
			
			this.saveProject();
		}
		public function generateProject():Boolean
		{
			if ( this.projectXML.rootPackage != "" && this.projectXML.path != "" && this.projectXML.@name != "") {
				this.projectXML.@generated = true;
				this.delegate.generateProject( this.projectXML, this.templateXML );
				this.saveProject();
				this.registerProject( this.projectXML );
				this.loadProject( this.projectXML.path );
				
				if ( VariableUtil.sanitize( this.projectXML.publishProject ) ) {
					TweenLite.delayedCall( 0.5, ProjectController.getInstance().browser.publishProject );
				}
				
				Bedrock.dispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.PROJECT_GENERATED, this ) );
				return true;
			} else {
				return false;
			}
			
		}
		
		/*
		Templates
		*/
		public function findTemplate():Boolean
		{
			var strLocation:String = this.delegate.selectTemplateFile();
			if ( strLocation != "" ) {
				this.registerTemplate( strLocation );
				return true;
			} else {
				return false;
			}
		}
		public function registerTemplate( $path:String ):void
		{
			var templateXML:XML = this._openTemplate( $path );
			if ( templateXML != null ) {
				this.settingsXML.templates.appendChild( <template name={ templateXML.name } path={ StringUtil.replace( $path, "template.bedrock", "" ) } versions={ templateXML.versions } /> );
			}
			this.saveSettings();
		}
		public function loadTemplate( $name:String ):void
		{
			var template:Object = ArrayUtil.findItem( this.templates, $name, "name" );
			if ( template != null ) {
				this.templateXML = this._openTemplate( template.path + "template.bedrock" );
				this.templateXML.path = template.path;
			}
		}
		public function removeTemplate( $name:String ):void
		{
			delete this.settingsXML.templates..template.( @name == $name )[ 0 ];
			this.saveSettings();
		}
		
		private function _openTemplate( $path:String ):XML
		{
			var strContent:String = this.delegate.openFile( $path );
			if ( strContent != "" && strContent != null ) {
				return new XML( strContent );
			}
			return null;
		}
		
		private function _parseTemplates():void
		{
			var templateObj:Object;
			this._customTemplates = new Array;
			for each( var templateXML:XML in this.settingsXML.templates..template ) {
				templateObj = XMLUtil2.getAttributesAsObject( templateXML );
				if ( templateObj.versions == "*" ) {
					templateObj.versions = new Array;
				} else {
					templateObj.versions = templateObj.versions.split( "," );
				}
				this._customTemplates.push( templateObj );
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
		
		private function _onProjectUpdate( $event:ExtensionEvent ):void
		{
			this.showUpdateProject();
		}
		private function _onSaveProject( $event:ExtensionEvent ):void
		{
			this.saveProject();
		}
		
		
		private function _onReloadConfig( $event:ExtensionEvent ):void
		{
			this.configXML = new XML( this.delegate.openConfig( this.projectXML ) );
			ProjectController.getInstance().update( this.resourceXML, this.settingsXML, this.projectXML, this.configXML );
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