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
package com.bedrockframework.engine.view
{
	import com.bedrockframework.engine.model.Queue;
	import com.bedrockframework.plugin.view.View;

	public class BedrockView extends View
	{
		/*
		Variable Declarations
		*/
		
		/*
		Constructor
		*/
		public function BedrockView()
		{
			super();
		}
		/*
		Property Definitions
		*/
		/**
		 * This will return the config details for the currently shown section.
		 * This information can also be accessed from the SectionStorage class.
		*/
		final protected  function get current():Object
		{
			return Queue.current;
		}
		/**
		 * This will return the config details for the previously shown section.
		 * This information can also be accessed from the SectionStorage class.
		*/
		final protected  function get previous():Object
		{
			return Queue.previous;
		}
		
	}
	
}