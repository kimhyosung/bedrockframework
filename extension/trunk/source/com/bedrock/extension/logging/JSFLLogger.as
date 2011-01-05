package com.bedrock.extension.logging
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.framework.core.logging.ILogger;
	import com.bedrock.framework.core.logging.LogData;

	public class JSFLLogger implements ILogger
	{
		private var _level:uint;
		
		public var data:LogData;
		public var delegate:JSFLDelegate;
		
		public function JSFLLogger( $detailDepth:uint=10 )
		{
			this.delegate = new JSFLDelegate;
			this.delegate.initialize( "Bedrock Framework/BedrockBridge.jsfl" );
		}
		public function log( $trace:*, $data:LogData ):void
		{
			this.delegate.output ( $trace.toString() );
		}
		public function set level( $level:uint ):void
		{
			this._level = $level;
		}
		public function get level():uint
		{
			return this._level;
		}
	}
}