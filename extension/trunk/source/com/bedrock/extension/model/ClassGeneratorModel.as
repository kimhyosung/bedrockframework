package com.bedrock.extension.model
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.framework.core.base.StandardBase;
	
	public class ClassGeneratorModel extends StandardBase
	{
		/*
		Variable Delcarations
		*/
		public var delegate:JSFLDelegate;
		[Bindable]
		public var data:XML;
		public var projectXML:XML;
		/*
		Constructor
		*/
		public function ClassGeneratorModel()
		{
		}
		public function initialize( $project:XML, $delegate:JSFLDelegate ):void
		{
			this.projectXML = $project;
			this.delegate = $delegate;
			
			this._createData();
		}
		/*
		Creation Functions
		*/
		public function reset():void
		{
			this._createData();
		}
		private function _createData():void
		{
			this.data = new XML( <data openClasses="false"><files/></data>);
			this.data.frameworkVersion = this.projectXML.frameworkVersion;
		}
		
		public function addFile( $prefix:String, $type:String, $inherit:String = "", $singleton:Boolean = false ):void
		{
			var xmlFile:XML = new XML( <file/> );
			xmlFile.@className = ( $prefix + $type );
			xmlFile.@classPackage = this.projectXML.rootPackage + "." + $type.toLowerCase();
			xmlFile.@destination = this.projectXML.path.toString() + this.projectXML.sourceFolder.toString() + xmlFile.@classPackage.split( "." ).join( "/" ) + "/";
			
			xmlFile.@template = $type;
			if ( $inherit != "" && $inherit != null ) xmlFile.@template += "_" + $inherit;
			if ( $singleton ) xmlFile.@template += "_Singleton";
			xmlFile.@template += ".as";
			
			this.data.files.appendChild( xmlFile );
		}
		
		public function generateClasses():Boolean
		{
			this.delegate.generateClasses( this.projectXML, this.data );
			return true;
		}
		/*
		Event Handlers
		*/
		
		/*
		Property Definitions
		*/
	}
}
