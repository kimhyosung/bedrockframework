package com.bedrock.framework.plugin.logging
{
	import com.bedrock.framework.core.logging.ILogger;
	import com.bedrock.framework.core.logging.LogData;
	import nl.demonsters.debugger.MonsterDebugger;

	public class MonsterLogger implements ILogger
	{
		private var _level:uint;
		
		public function MonsterLogger( $logLevel:uint )
		{
			this.level = $logLevel;
		}

		public function log( $trace:*, $data:LogData ):void
		{
			MonsterDebugger.trace( this, $trace, $data.categoryColor );
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