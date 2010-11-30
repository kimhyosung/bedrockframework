package com.bedrock.extension.logging
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.framework.core.logging.TraceLogger;

	public class JSFLLogger extends TraceLogger
	{
		public var delegate:JSFLDelegate;
		
		public function JSFLLogger( $detailDepth:uint=10 )
		{
			this.delegate = new JSFLDelegate;
			this.delegate.initialize( "Bedrock Framework/BedrockBridge.jsfl" );
			super($detailDepth);
		}
		override public function log($trace:*, $target:*, $category:int ):String
		{
			var strTrace:String = super.log( $trace, $target, $category);
			this.delegate.output ( strTrace );
			return strTrace;
		}
	}
}