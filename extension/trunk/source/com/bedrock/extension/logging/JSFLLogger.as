package com.bedrock.extension.logging
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.framework.core.logging.LogData;
	import com.bedrock.framework.plugin.logging.ILoggingService;
	import com.bedrock.framework.plugin.logging.LogFormatter;

	public class JSFLLogger implements ILoggingService
	{
		private var _level:uint;
		
		public var data:LogData;
		public var delegate:JSFLDelegate;
		
		private var _formatter:LogFormatter;
		
		public function JSFLLogger()
		{
			this.delegate = new JSFLDelegate;
			this.delegate.initialize( "Bedrock Framework/BedrockBridge.jsfl" );
		}
		public function initialize( $logLevel:uint, $detailDepth:uint ):void
		{
			this.level = $logLevel;
			this._formatter = new LogFormatter( $detailDepth );
		}
		public function log( $trace:*, $data:LogData ):void
		{
			this.delegate.output ( this._formatter.format( $trace, $data ) );
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