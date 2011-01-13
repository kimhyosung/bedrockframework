package com.bedrock.extension.model
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	
	public class SampleBrowserModel
	{
		/*
		Variable Delcarations
		*/
		public var delegate:JSFLDelegate;
		[Bindable]
		public var data:XML;
		public var project:XML;
		/*
		Constructor
		*/
		public function SampleBrowserModel()
		{
		}
		public function initialize( $project:XML, $delegate:JSFLDelegate ):void
		{
			this.project = $project;
			this.delegate = $delegate;
			
			this.loadSamples();
		}
		/*
		Creation Functions
		*/
		private function loadSamples():void
		{
			this.data = new XML( this.delegate.getSampleFolders( this.project ) );
		}
		
		public function getSample( $data:XML ):XML
		{
			return new XML( this.delegate.loadSample( $data ) );
		}
		
		public function generateSample():void
		{
			this.delegate.generateSample( this.data );
		}
		/*
		Event Handlers
		*/
		
		/*
		Property Definitions
		*/
	}
}