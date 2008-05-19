package com.autumntactics.bedrock.view
{
	import flash.display.DisplayObject;
	import com.autumntactics.bedrock.base.MovieClipWidget;
	import com.autumntactics.bedrock.view.IView;
	import com.autumntactics.bedrock.dispatcher.BedrockDispatcher;
	
	import com.autumntactics.bedrock.events.ViewEvent;
	import com.autumntactics.bedrock.model.SectionStorage;
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
		/*
		Intro Functions
		*/
		final protected  function introComplete():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.INTRO_COMPLETE,this));
		}
		/*
		Outro Functions
		*/
		final protected  function outroComplete():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.OUTRO_COMPLETE,this));
		}
		/*
		Section shortcuts
		*/
		public function remove():void{
			this.parent.removeChild(this);
		}
		/*
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