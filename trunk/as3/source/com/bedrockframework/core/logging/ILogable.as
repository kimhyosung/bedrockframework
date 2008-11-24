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
package com.bedrockframework.core.logging
{

	/**
	 *  All loggers within the logging framework must implement this interface.
	 */
	public interface ILogable
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------


		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		     *  Logs the specified data at the given level.
		 *  
		     *  <p>The String specified for logging can contain braces with an index
		     *  indicating which additional parameter should be inserted
		 *  into the String before it is logged.
		     *  For example "the first additional parameter was {0} the second was {1}"
		     *  is translated into "the first additional parameter was 10 the
		 *  second was 15" when called with 10 and 15 as parameters.</p>
		     *  
		     *  @param level The level this information should be logged at.
		     *  Valid values are:
		     *  <ul>
		     *    <li><code>LogLevel.FATAL</code> designates events that are very
		     *    harmful and will eventually lead to application failure</li>
		     *
		     *    <li><code>LogLevel.ERROR</code> designates error events
		 *    that might still allow the application to continue running.</li>
		     *
		     *    <li><code>LogLevel.WARN</code> designates events that could be
		     *    harmful to the application operation</li>
		 *
		     *    <li><code>LogLevel.INFO</code> designates informational messages
		     *    that highlight the progress of the application at
		     *    coarse-grained level.</li>
		 *
		     *    <li><code>LogLevel.DEBUG</code> designates informational
		     *    level messages that are fine grained and most helpful when
		     *    debugging an application.</li>
		 *
		     *    <li><code>LogLevel.ALL</code> intended to force a target to
		     *    process all messages.</li>
		     *  </ul>
		 *
		     *  @param message The information to log.
		     *  This String can contain special marker characters of the form {x},
		 *  where x is a zero based index that will be replaced with
		     *  the additional parameters found at that index if specified.
		 *
		     *  @param rest Additional parameters that can be subsituted in the str
		     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
		 *  is an integer (zero based) index value into the Array of values
		 *  specified.
		 *
		     *  @example
		     *  <pre>
		     *  // Get the logger for the mx.messaging.Channel "category"
		     *  // and send some data to it.
		     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
		     *  logger.log("here is some channel info {0} and {1}", LogLevel.DEBUG, 15.4, true);
		 *
		     *  // this will log the following string:
		     *  //   "here is some channel info 15.4 and true"
		     *  </pre>
		 *
		     */
		function log($level:int,...$arguments:Array):void;

		/**
		     *  Logs the specified data using the <code>LogLevel.DEBUG</code>
		 *  level.
		     *  <code>LogLevel.DEBUG</code> designates informational level
		 *  messages that are fine grained and most helpful when debugging
		 *  an application.
		 *  
		     *  <p>The string specified for logging can contain braces with an index
		     *  indicating which additional parameter should be inserted
		 *  into the string before it is logged.
		     *  For example "the first additional parameter was {0} the second was {1}"
		     *  will be translated into "the first additional parameter was 10 the
		 *  second was 15" when called with 10 and 15 as parameters.</p>
		 *
		     *  @param message The information to log.
		     *  This string can contain special marker characters of the form {x},
		 *  where x is a zero based index that will be replaced with
		     *  the additional parameters found at that index if specified.
		 *
		     *  @param rest Additional parameters that can be subsituted in the str
		     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
		 *  is an integer (zero based) index value into the Array of values
		 *  specified.
		 *
		     *  @example
		     *  <pre>
		     *  // Get the logger for the mx.messaging.Channel "category"
		     *  // and send some data to it.
		     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
		     *  logger.debug("here is some channel info {0} and {1}", 15.4, true);
		 *
		     *  // This will log the following String:
		     *  //   "here is some channel info 15.4 and true"
		 *  </pre>
		     */
		function debug(...$arguments:Array):void;

		/**
		     *  Logs the specified data using the <code>LogLevel.ERROR</code>
		 *  level.
		     *  <code>LogLevel.ERROR</code> designates error events
		 *  that might still allow the application to continue running.
		 *  
		     *  <p>The string specified for logging can contain braces with an index
		     *  indicating which additional parameter should be inserted
		 *  into the string before it is logged.
		     *  For example "the first additional parameter was {0} the second was {1}"
		     *  will be translated into "the first additional parameter was 10 the
		 *  second was 15" when called with 10 and 15 as parameters.</p>
		 *
		     *  @param message The information to log.
		     *  This String can contain special marker characters of the form {x},
		 *  where x is a zero based index that will be replaced with
		     *  the additional parameters found at that index if specified.
		 *
		     *  @param rest Additional parameters that can be subsituted in the str
		     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
		 *  is an integer (zero based) index value into the Array of values
		 *  specified.
		 *
		     *  @example
		     *  <pre>
		     *  // Get the logger for the mx.messaging.Channel "category"
		     *  // and send some data to it.
		     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
		     *  logger.error("here is some channel info {0} and {1}", 15.4, true);
		 *
		     *  // This will log the following String:
		     *  //   "here is some channel info 15.4 and true"
		     *  </pre>
		     */
		function error(...$arguments:Array):void;

		/**
		     *  Logs the specified data using the <code>LogLevel.FATAL</code> 
		     *  level.
		     *  <code>LogLevel.FATAL</code> designates events that are very 
		     *  harmful and will eventually lead to application failure
		 *
		     *  <p>The string specified for logging can contain braces with an index
		     *  indicating which additional parameter should be inserted
		 *  into the string before it is logged.
		     *  For example "the first additional parameter was {0} the second was {1}"
		     *  will be translated into "the first additional parameter was 10 the
		 *  second was 15" when called with 10 and 15 as parameters.</p>
		 *
		     *  @param message The information to log.
		     *  This String can contain special marker characters of the form {x},
		 *  where x is a zero based index that will be replaced with
		     *  the additional parameters found at that index if specified.
		 *
		     *  @param rest Additional parameters that can be subsituted in the str
		     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
		 *  is an integer (zero based) index value into the Array of values
		 *  specified.
		 *
		     *  @example
		     *  <pre>
		     *  // Get the logger for the mx.messaging.Channel "category"
		     *  // and send some data to it.
		     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
		     *  logger.fatal("here is some channel info {0} and {1}", 15.4, true);
		 *
		     *  // This will log the following String:
		     *  //   "here is some channel info 15.4 and true"
		 *  </pre>
		     */
		function fatal(...$arguments:Array):void;

		/**
		     *  Logs the specified data using the <code>LogEvent.INFO</code> level.
		     *  <code>LogLevel.INFO</code> designates informational messages that 
		     *  highlight the progress of the application at coarse-grained level.
		 *  
		     *  <p>The string specified for logging can contain braces with an index
		     *  indicating which additional parameter should be inserted
		 *  into the string before it is logged.
		     *  For example "the first additional parameter was {0} the second was {1}"
		     *  will be translated into "the first additional parameter was 10 the
		 *  second was 15" when called with 10 and 15 as parameters.</p>
		 *
		     *  @param message The information to log.
		     *  This String can contain special marker characters of the form {x},
		 *  where x is a zero based index that will be replaced with
		     *  the additional parameters found at that index if specified.
		 *
		     *  @param rest Additional parameters that can be subsituted in the str
		     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
		 *  is an integer (zero based) index value into the Array of values
		 *  specified.
		 *
		     *  @example
		     *<pre>
		     *  // Get the logger for the mx.messaging.Channel "category"
		     *  // and send some data to it.
		     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
		     *  logger.info("here is some channel info {0} and {1}", 15.4, true);
		 *
		     *  // This will log the following String:
		     *  //   "here is some channel info 15.4 and true"
		 *  </pre>
		     */
		function status(...$arguments:Array):void;

		/**
		     *  Logs the specified data using the <code>LogLevel.WARN</code> level.
		     *  <code>LogLevel.WARN</code> designates events that could be harmful 
		     *  to the application operation.
		 *  
		     *  <p>The string specified for logging can contain braces with an index
		     *  indicating which additional parameter should be inserted
		 *  into the string before it is logged.
		     *  For example "the first additional parameter was {0} the second was {1}"
		     *  will be translated into "the first additional parameter was 10 the
		 *  second was 15" when called with 10 and 15 as parameters.</p>
		     *  
		     *  @param message The information to log.
		     *  This String can contain special marker characters of the form {x},
		 *  where x is a zero based index that will be replaced with
		     *  the additional parameters found at that index if specified.
		 *
		     *  @param rest Aadditional parameters that can be subsituted in the str
		     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
		 *  is an integer (zero based) index value into the Array of values
		 *  specified.
		 *
		     *  @example
		     *  <pre>
		     *  // Get the logger for the mx.messaging.Channel "category"
		     *  // and send some data to it.
		     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
		     *  logger.warn("here is some channel info {0} and {1}", 15.4, true);
		 *
		     *  // This will log the following String:
		     *  //   "here is some channel info 15.4 and true"
		 *  </pre>
		     */
		function warning(...$arguments:Array):void;
		
		function set silenceLogging($value:Boolean):void;
		
		function get silenceLogging():Boolean;

	}

}