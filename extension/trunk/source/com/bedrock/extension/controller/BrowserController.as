package com.bedrock.extension.controller
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.extension.event.ExtensionEvent;
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import mx.collections.HierarchicalData;

	public class BrowserController
	{
		/*
		Variable Declarations
		*/
		[Bindable]
		public var fileHierarchy:HierarchicalData;
		public var files:XML;
		
		public var projectXML:XML;
		public var settingsXML:XML;
		public var delegate:JSFLDelegate;
		/*
		Constructor
	 	*/
	 	public function BrowserController()
		{
			super();
		}
		public function initialize( $settings:XML, $project:XML, $delegate:JSFLDelegate ):void
		{
			this.projectXML = $project;
			this.settingsXML = $settings;
			this.delegate = $delegate;
			
			Bedrock.dispatcher.addEventListener( ExtensionEvent.SETTINGS_SAVED, this._onSettingsSaved );
			
			this.refresh();
		}
		
		
		/*
		Projet Contents
		*/
		public function refresh():void
		{
			if ( VariableUtil.sanitize( this.projectXML.@generated ) ) {
				var path:String = this.projectXML.path.toString() + this.projectXML.sourceFolder.toString();
				this.files = new XML( this.delegate.refreshProjectStructure( path, this.settingsXML.includeSubFoldersInProjectBrowser ) );
				this.validateFLAs();
				this.processFLAs( this.files );
				Bedrock.dispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.SAVE_PROJECT, this ) );
				
				this.fileHierarchy = new HierarchicalData( new XMLList( this.files.children() ) );
				Bedrock.dispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.PROJECT_REFRESH, this ) );
			}
		}
		public function processFLAs( $data:XML ):void
		{
			for each( var xmlFLA:XML in $data.children().( @type == ".fla" ) ) {
				this.addFLA( xmlFLA );
			}
		}
		public function addFLA( $data:XML ):void
		{
			var xmlFLA:XML = this.projectXML.flas..file.( @name == $data.@name )[ 0 ];
			if ( xmlFLA == null ) {
				xmlFLA = new XML( $data.toXMLString() );
				xmlFLA.@publish = true;
				
				var strLocation:String = xmlFLA.@path;
				strLocation = strLocation.substring( strLocation.lastIndexOf( this.projectXML.sourceFolder.toString() ), strLocation.length );
				xmlFLA.@path = strLocation;
				
				this.projectXML.flas.appendChild( xmlFLA );
			}
		}
		private function validateFLAs():void
		{
			for each( var xmlFLA:XML in this.projectXML.flas.children() ) {
				if ( !this.delegate.fileExists( this.projectXML.path + "" + xmlFLA.@path ) ) {
					this.removeFLA( xmlFLA );
				}
			}
		}
		public function removeFLA( $data:XML ):void
		{
			delete this.projectXML.flas..file.( @name == $data.@name )[ 0 ];
		}
		
		
		
		
		public function openFLA( $path:String ):void
		{
			this.delegate.openFLA( this.projectXML.path.toString() + $path );
		}
		public function openScript( $path:String ):void
		{
			this.delegate.openScript( this.projectXML.path.toString() + $path );
		}
		
		
		public function publishProject():void
		{
			var publishList:XML = new XML( <publish/> );
			publishList.appendChild( this.projectXML.flas..file.( @publish == "true" ) );
			this.delegate.publishProject( this.projectXML, publishList );
		}
		public function publishShell():void
		{
			var shellXML:XML = this.projectXML.flas..file.( @name == "shell" )[ 0 ];
			this.exportSWF( shellXML );
		}
		public function exportSWF( $fla:XML ):void
		{
			this.delegate.exportSWF( this.projectXML, $fla );
		}
		/*
		Event Handlers
	 	*/
	 	private function _onSettingsSaved( $event:ExtensionEvent ):void
		{
			this.refresh();
		}
	 	/*
		Accessors
	 	*/
		
	}
}