package com.bedrockframework.engine.view
{
	import flash.display.DisplayObject;
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.engine.view.IView;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	
	import com.bedrockframework.engine.event.ViewEvent;
	import com.bedrockframework.engine.model.SectionStorage;
	public class View extends MovieClipWidget
	{
		/*
		Constructor
		*/
		/*
		Initialize Functions
		*/
		final protected  function initializeComplete():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.INITIALIZE_COMPLETE,this));
		}
		/**
		 * 
		*/
		final protected  function introComplete():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.INTRO_COMPLETE,this));
		}
		/**
		Outro Functions
		*/
		final protected  function outroComplete():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.OUTRO_COMPLETE,this));
		}
		/**
		Remove this instance from it's parent's display list.
		*/
		public function remove():void
		{
			this.parent.removeChild(this);
		}
		/**
		Section shortcuts
		*/
		final protected  function get current():Object
		{
			return SectionStorage.current;
		}
		final protected  function get previous():Object
		{
			return SectionStorage.previous;
		}
	}

}