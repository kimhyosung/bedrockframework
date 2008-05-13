package com.icg.madagascar
{

	import com.icg.gadget.Blocker;
	import com.icg.madagascar.base.MovieClipWidget;
	import com.icg.madagascar.command.*;
	import com.icg.madagascar.controller.*;
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.gadget.*;
	import com.icg.madagascar.manager.*;
	import com.icg.madagascar.model.*;
	import com.icg.madagascar.output.OutputManager;
	import com.icg.madagascar.view.*;
	import com.icg.tools.ArrayBrowser;
	import com.icg.tools.BackgroundLoader;
	import com.icg.tools.BulkLoader;
	import com.icg.tools.VisualLoader;
	
	import flash.events.Event;

	public class MadagascarBuilder extends MovieClipWidget
	{
		private var numLoadIndex:Number;
		private const strConfigurationXMLPath:String="../../config/madagascar_config.xml";
		private const arrLoadSequence:Array=new Array("loadDispatcher","loadParams","loadConfig","loadCacheSettings", "loadOutput","loadController","loadServices","loadTracking","loadEngineClasses","loadEngineCommands","loadEngineContainers","loadCSS", "loadCopy", "buildDefaultPanel","loadModels","loadCommands","loadViews","loadCustomization","loadComplete");
		private var objMadagascarController:MadagascarController;
		public var params:String
		
		public function MadagascarBuilder()
		{			
			this.loaderInfo.addEventListener(Event.COMPLETE,this.onBootUp);
			this.numLoadIndex=0;
		}
		final public function initialize():void
		{
			this.next();
		}
		final protected function next():void
		{
			var strFunction:String=this.arrLoadSequence[this.numLoadIndex];
			this.numLoadIndex+= 1;

			var objDetails:Object = this.getProgressObject();

			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.MADAGASCAR_PROGRESS,this,objDetails));

			this[strFunction]();
		}
		/*
		Calculate Percentage
		*/
		private function getProgressObject():Object
		{
			var numPercent:int=Math.round(this.numLoadIndex / this.arrLoadSequence.length * 100);
			var objDetails:Object=new Object  ;
			objDetails.index=this.numLoadIndex;
			objDetails.percent=numPercent;
			return objDetails;
		}
		/*
		Sequential Functions
		*/
		final private function loadDispatcher():void
		{
			MadagascarDispatcher.initialize();
			this.next();
		}

		final private function loadParams():void
		{
			Params.initialize();
			Params.parse(this.params);
			Params.save(this.loaderInfo.parameters);
			Params.output();
			this.next();
		}
		final private function loadConfig():void
		{
			Params.getValue("config");
			var strConfigPath:String = Params.getValue("config") ||this.strConfigurationXMLPath;
			Config.initialize(strConfigPath, this.loaderInfo.url, this.onConfigLoaded, this.stage);
			this.output(this.loaderInfo.url);
		}
		final private function loadCacheSettings():void
		{
			if (Config.getSetting("cache_prevention") && Config.getSetting("environment") != "local") {
				BackgroundLoader.cachePrevention = true;
				VisualLoader.cachePrevention = true;
			}
			this.next();
		}
		final private function loadOutput():void
		{
			OutputManager.outputLevel=Config.getValue("output_level");
			this.next();
		}
		final private function loadCSS():void
		{
			if (Config.getSetting("stylesheet")) {
				this.addToQueue(Config.getValue("css_path") + "style.css", null, StyleManager.onCSSLoaded);
			}
			this.next();
		}
		final private function loadCopy():void
		{
			if (Config.getSetting("copy_deck")) {
				var strPath:String;
				var arrLanguages:Array = Config.getSetting("languages");
				var objBrowser:ArrayBrowser = new ArrayBrowser(arrLanguages);
				if (arrLanguages.length > 0 && Config.getSetting("default_language") != "") {
					if (objBrowser.containsItem(Config.getSetting("language"))) {
						strPath = Config.getValue("xml_path") + Config.getSetting("language") + "_copy.xml";
					} else {
						strPath = Config.getValue("xml_path") + Config.getSetting("default_language") + "_copy.xml";
					}
				} else {
					strPath = Config.getValue("xml_path") + "copy.xml";
				}
				CopyManager.initialize(strPath);
			}			
			this.next();
		}
		final private function loadController():void
		{			
			this.objMadagascarController=new MadagascarController();
			this.next();
		}
		final protected function loadEngineCommands():void
		{			
			this.addCommand(MadagascarEvent.SET_QUEUE,SetQueueCommand);
			this.addCommand(MadagascarEvent.LOAD_QUEUE,LoadQueueCommand);
			this.addCommand(MadagascarEvent.DO_DEFAULT,DoDefaultCommand);
			this.addCommand(MadagascarEvent.DO_CHANGE,DoChangeCommand);
			this.addCommand(MadagascarEvent.RENDER_VIEW,RenderViewCommand);
			this.addCommand(MadagascarEvent.RENDER_PRELOADER,RenderPreloaderCommand);
			
			this.addCommand(MadagascarEvent.RENDER_SITE,RenderSiteCommand);
			this.addCommand(MadagascarEvent.URL_CHANGE, URLChangeCommand);
			//
			this.addCommand(MadagascarEvent.SHOW_BLOCKER,ShowBlockerCommand);
			this.addCommand(MadagascarEvent.HIDE_BLOCKER,HideBlockerCommand);
			this.addCommand(MadagascarEvent.SET_QUEUE,ShowBlockerCommand);
			this.addCommand(MadagascarEvent.INTRO_COMPLETE,HideBlockerCommand);
			//
			this.addCommand(MadagascarEvent.SET_QUEUE, StateChangeCommand);
			this.addCommand(MadagascarEvent.INITIALIZE_COMPLETE, StateChangeCommand);
			//
			if (Config.getSetting("auto_intro")){
				this.addCommand(MadagascarEvent.MADAGASCAR_COMPLETE,RenderSiteCommand);
			}
			if (Config.getSetting("copy_deck")){
				this.addCommand(MadagascarEvent.LOAD_COPY, LoadCopyCommand);
			}
			//
			this.next();
		}
		final protected function loadEngineClasses():void
		{
			SectionStorage.save(Config.getSetting("sections"));
			State.initialize();
			if (Config.getSetting("deep_linking")) {
				URLManager.initialize()
			}
			ContainerManager.initialize(this);
			LayoutBuilder.initialize();
			LoadManager.initialize();
			PreloaderManager.initialize();
			SectionManager.initialize();
			this.next();
		}
		final protected function loadEngineContainers():void
		{
			LayoutBuilder.buildLayout(Config.getSetting("layout"));
			SectionManager.set(ContainerManager.getContainer("site") as VisualLoader);
			var objBlocker:Blocker=new Blocker();
			ContainerManager.buildContainer("blocker",objBlocker);
			objBlocker.show();
			this.next();
		}
		final protected function loadServices():void
		{
			try{
				ServiceManager.createServices(Config.getValue("remoting"))
			}catch($error:Error){
			}		
			this.next();
		}
		final protected function loadTracking():void
		{
			TrackingManager.initialize();
			TrackingManager.enabled = Config.getValue("tracking_enabled");
			this.next();
		}
		final protected function buildDefaultPanel():void
		{
			this.next();
		}
		/*
		Site Customization Functions
		*/
		public function loadModels():void
		{
			this.next();
		}
		public function loadCommands():void
		{
			this.next();
		}
		public function loadContainers():void
		{
			this.next();
		}
		public function loadViews():void
		{
			this.next();
		}
		public function loadCustomization():void
		{
			this.next();
		}
		/*
		Load Completion Notice
		*/
		final protected function loadComplete():void
		{
			this.addToQueue(Config.getValue("swf_path") + "site.swf",ContainerManager.getContainer("site"));
			this.addToQueue(Config.getValue("swf_path") + "shared.swf",ContainerManager.getContainer("shared"));			
			this.output("Initialization Complete!");
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.MADAGASCAR_COMPLETE,this));
		}
		/*
		Add Command
		*/
		final protected function addCommand($type:String,$command:Class):void
		{
			this.objMadagascarController.addCommand($type,$command);
		}
		final protected function removeCommand($type:String,$command:Class):void
		{
			this.objMadagascarController.removeCommand($type,$command);
		}
		/*
		Add View Functions
		*/
		final protected function addToQueue($path:String,$loader:*,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			LoadManager.addToQueue($path, $loader, $completeHandler, $errorHandler);
		}
		/*
		
		Event Handlers
		
		*/
		final private function onConfigLoaded():void
		{
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.CONFIG_LOADED,this));
			this.next();
		}
		final private function onBootUp($event:Event)
		{
			this.initialize();
		}



	}
}