/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@builtonbedrock.com
 * website: http://www.builtonbedrock.com/
 * blog: http://blog.builtonbedrock.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrock.framework.plugin.logging
{
	import com.bedrock.framework.core.logging.LogData;
	
	public interface ILoggingService
	{
		function initialize( $logLevel:uint, $detailDepth:uint ):void;
		function log( $trace:*, $data:LogData ):void;
		function set level( $level:uint ):void;
		function get level():uint;
	}
}