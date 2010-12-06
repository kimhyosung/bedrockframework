package com.bedrock.extension.controller
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.extension.model.ConfigModel;
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.engine.manager.DataBundleManager;
	import com.greensock.TweenMax;
	
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	public class ProjectController extends StandardBase
	{
		/*
		Variable Delcarations
		*/
		private static var __objInstance:ProjectController;
		
		public var settingsXML:XML;
		public var projectXML:XML;
		public var configXML:XML;
		public var resourcesXML:XML;
		
		public var root:UIComponent;
		
		public var delegate:JSFLDelegate;
		[Bindable]
		public var config:ConfigModel;
		
		[Bindable]
		public var resources:DataBundleManager;
		[Bindable]
		public var browser:BrowserController;
		/*
		Constructor
		*/
		public function ProjectController($singletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():ProjectController
		{
			if (ProjectController.__objInstance == null) {
				ProjectController.__objInstance = new ProjectController(new SingletonEnforcer);
			}
			return ProjectController.__objInstance;
		}
		public function setup( $root:UIComponent ):void
		{
			this.root = $root;
		}
		public function initialize( $resources:XML, $settings:XML, $project:XML, $config:XML ):void
		{
			this.createDelegate();
			
			this.browser = new BrowserController;
			this.resources = new DataBundleManager();
			this.config = new ConfigModel;
			
			this.update( $resources, $settings, $project, $config );
		}
		public function update( $resources:XML, $settings:XML, $project:XML, $config:XML ):void
		{
			this.settingsXML = $settings;
			this.projectXML = $project;
			this.resourcesXML = $resources;
			this.configXML = $config;
			this.browser.initialize( this.settingsXML, this.projectXML, this.delegate );
			this.resources.parse( this.resourcesXML.toXMLString() );
			this.config.initialize( this.settingsXML, this.projectXML, this.configXML, this.delegate );
		}
		private function createDelegate():void
		{
			this.delegate = new JSFLDelegate;
			this.delegate.initialize( "Bedrock Framework/BedrockBridge.jsfl" );
		}
		public function wait( $time:Number = 0 ):void
		{
			//PopUpManager.addPopUp( this._objPopup, this._objRoot, true );
			CursorManager.setBusyCursor();
			if ( $time != 0 ) TweenMax.delayedCall( $time, this.done );
		}
		public function done():void
		{
			CursorManager.removeBusyCursor();
			//PopUpManager.removePopUp( this._objPopup );
		}
		
		
		
		/*
		Creation Functions
		*/
		
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