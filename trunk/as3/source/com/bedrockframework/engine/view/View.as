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
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.engine.event.ViewEvent;
	import com.bedrockframework.engine.model.Queue;
	
	public class View extends MovieClipWidget
	{
		/*
		Constructor
		*/
		/**
		 * The initializeComplete() function will dispatch ViewEvent.INITIALIZE_COMPLETE notifying any listeners of this class that the initialization of the view is complete.
		 * This function should be called after the view has finished it's initialization.
		 * 
		 * This function is only available to the View class and it's descendants.
		*/
		final protected  function initializeComplete():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.INITIALIZE_COMPLETE,this));
		}
		/**
		 * The introComplete() function will dispatch ViewEvent.INTRO_COMPLETE notifying any listeners of this class that the intro of the view is complete.
		 * This function should be called after the view has finished it's intro sequence.
		 * 
		 * This function is only available to the View class and it's descendants.
		*/
		final protected  function introComplete():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.INTRO_COMPLETE,this));
		}
		/**
		 * The introComplete() function will dispatch ViewEvent.OUTRO_COMPLETE notifying any listeners of this class that the outro of the view is complete.
		 * This function should be called after the view has finished it's outro sequence.
		 * 
		 * This function is only available to the View class and it's descendants.
		*/
		final protected  function outroComplete():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.OUTRO_COMPLETE,this));
		}
		/**
		 * Remove this instance from it's parent's display list.
		*/
		public function remove():void
		{
			this.parent.removeChild(this);
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