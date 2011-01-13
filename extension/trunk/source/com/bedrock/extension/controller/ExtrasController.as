package com.bedrock.extension.controller
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.extension.model.ClassGeneratorModel;
	import com.bedrock.extension.model.SampleBrowserModel;

	public class ExtrasController
	{
		/*
		Variable Delcarations
		*/
		private static var __objInstance:ExtrasController;
		[Bindable]
		public var classGenerator:ClassGeneratorModel;
		[Bindable]
		public var sampleBrowser:SampleBrowserModel;
		
		public function ExtrasController($singletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():ExtrasController
		{
			if (ExtrasController.__objInstance == null) {
				ExtrasController.__objInstance = new ExtrasController(new SingletonEnforcer);
			}
			return ExtrasController.__objInstance;
		}
		
		public function initialize( $projectXML:XML, $delegate:JSFLDelegate ):void
		{
			this.classGenerator = new ClassGeneratorModel;
			this.classGenerator.initialize( $projectXML, $delegate );
			
			this.sampleBrowser = new SampleBrowserModel;
			this.sampleBrowser.initialize( $projectXML, $delegate );
		}
	}
}
/*
This private class is only accessible by the public class.
The public class will use this as a 'key' to control instantiation.   
*/
class SingletonEnforcer {}