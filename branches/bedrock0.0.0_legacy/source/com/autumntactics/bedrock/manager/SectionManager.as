package com.builtonbedrock.bedrock.manager
{
	import com.builtonbedrock.bedrock.base.StaticWidget;
	import com.builtonbedrock.bedrock.dispatcher.BedrockDispatcher;
	import com.builtonbedrock.bedrock.events.BedrockEvent;
	import com.builtonbedrock.bedrock.events.ViewEvent;
	import com.builtonbedrock.bedrock.logging.LogLevel;
	import com.builtonbedrock.bedrock.logging.Logger;
	import com.builtonbedrock.bedrock.model.SectionStorage;
	import com.builtonbedrock.bedrock.output.Outputter;
	import com.builtonbedrock.bedrock.view.IView;
	import com.builtonbedrock.loader.VisualLoader;
	
	import flash.utils.*;

	public class SectionManager extends StaticWidget
	{
		private static  var OBJ_LOADER:VisualLoader;
		private static  var OBJ_SECTION:IView;

		Logger.log(SectionManager, LogLevel.CONSTRUCTOR, "Constructed");
		
		public static function reset():void
		{
			SectionManager.OBJ_LOADER=null;
			SectionManager.OBJ_SECTION=null;
		}
		public static function initialize():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.DO_INITIALIZE,SectionManager.onDoInitialize);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_COMPLETE,SectionManager.onLoadComplete);
		}
		/*
		Manager Event Listening
		*/
		private static function addListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,SectionManager.onInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,SectionManager.onIntroComplete);
			$target.addEventListener(ViewEvent.OUTRO_COMPLETE,SectionManager.onOutroComplete);
		}
		private static function removeListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,SectionManager.onInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,SectionManager.onIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,SectionManager.onOutroComplete);
		}
		public static function outro():void
		{
			SectionManager.OBJ_SECTION.outro();
		}
		/*
		Create a detail object to be sent out with events
	 	*/
	 	private static function getDetailObject():Object
		{
			var objDetail:Object = new Object();
			try {
				objDetail.section = SectionStorage.current;
			} catch ($e:Error) {
			}
			objDetail.view = SectionManager.OBJ_SECTION;
			return objDetail;
		}
		/*
		Framework Event Handlers
		*/
		private static function onDoInitialize($event:BedrockEvent):void
		{
			SectionManager.OBJ_SECTION.initialize();
		}
		private static function onLoadComplete($event:BedrockEvent):void
		{
			SectionManager.OBJ_SECTION=SectionManager.OBJ_LOADER.content as IView;
			SectionManager.addListeners(SectionManager.OBJ_SECTION);
		}
		/*
		Individual Preloader Handlers
		*/
		private static function onInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, SectionManager.OBJ_SECTION, SectionManager.getDetailObject()));
			SectionManager.OBJ_SECTION.intro();
		}
		private static function onIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INTRO_COMPLETE, SectionManager.OBJ_SECTION, SectionManager.getDetailObject()));
		}
		private static function onOutroComplete($event:ViewEvent):void
		{
			SectionManager.removeListeners(SectionManager.OBJ_SECTION);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.OUTRO_COMPLETE, SectionManager.OBJ_SECTION, SectionManager.getDetailObject()));			
			SectionManager.OBJ_SECTION.clear();
			SectionManager.OBJ_LOADER.unload();
			SectionManager.reset();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,SectionManager.OBJ_LOADER));
		}
		/*
		Set the current container to load content into
	 	*/
	 	public static function set container($loader:VisualLoader):void
		{
			SectionManager.OBJ_LOADER=$loader;
		}
		public static function get container():VisualLoader
		{
			return SectionManager.OBJ_LOADER;
		}
	}

}