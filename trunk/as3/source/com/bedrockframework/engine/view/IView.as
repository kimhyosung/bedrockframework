/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@autumntactics.com
 * website: http://www.autumntactics.com/
 * blog: http://blog.autumntactics.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.engine.view
{
	
	public interface IView
	{
		function initialize($properties:Object=null):void;
		function intro($properties:Object=null):void;
		function outro($properties:Object=null):void;
		//
		function clear():void;
	}
}