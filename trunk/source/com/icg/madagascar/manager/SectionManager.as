package com.icg.madagascar.manager
{
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.events.ViewEvent;
	import com.icg.madagascar.model.SectionStorage;
	import com.icg.madagascar.output.Outputter;
	import com.icg.madagascar.view.IView;
	import com.icg.tools.VisualLoader;
	
	import flash.utils.*;

	public class SectionManager extends StaticWidget
	{
		private static  var OUTPUT:Outputter = new Outputter(SectionManager);
		private static  var OBJ_LOADER:VisualLoader;
		private static  var OBJ_SECTION:IView;

		
		public static function reset():void
		{
			SectionManager.OBJ_LOADER=null;
			SectionManager.OBJ_SECTION=null;
		}
		public static function initialize():void
		{
			MadagascarDispatcher.addEventListener(MadagascarEvent.DO_INITIALIZE,SectionManager.onDoInitialize);
			MadagascarDispatcher.addEventListener(MadagascarEvent.LOAD_COMPLETE,SectionManager.onLoadComplete);
		}
		public static function set($loader:VisualLoader):void
		{
			SectionManager.OBJ_LOADER=$loader;
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
		Framework Event Handlers
		*/
		private static function onDoInitialize($event:MadagascarEvent):void
		{
			SectionManager.OBJ_SECTION.initialize();
		}
		private static function onLoadComplete($event:MadagascarEvent):void
		{
			SectionManager.OBJ_SECTION=SectionManager.OBJ_LOADER.content as IView;
			SectionManager.addListeners(SectionManager.OBJ_SECTION);
		}
		/*
		Individual Preloader Handlers
		*/
		private static function onInitializeComplete($event:ViewEvent):void
		{
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.INITIALIZE_COMPLETE, SectionManager.OBJ_SECTION, SectionManager.getDetailObject()));
			SectionManager.OBJ_SECTION.intro();
		}
		private static function onIntroComplete($event:ViewEvent):void
		{
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.INTRO_COMPLETE, SectionManager.OBJ_SECTION, SectionManager.getDetailObject()));
		}
		private static function onOutroComplete($event:ViewEvent):void
		{
			SectionManager.removeListeners(SectionManager.OBJ_SECTION);
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.OUTRO_COMPLETE, SectionManager.OBJ_SECTION, SectionManager.getDetailObject()));			
			SectionManager.OBJ_SECTION.clear();
			SectionManager.OBJ_LOADER.unload();
			SectionManager.reset();
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.RENDER_PRELOADER,SectionManager.OBJ_LOADER));
		}
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
	}

}