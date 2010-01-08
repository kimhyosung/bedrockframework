package com.bedrockframework.engine.controller
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.controller.FrontController;
	import com.bedrockframework.core.controller.IFrontController;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.engine.command.HideBlockerCommand;
	import com.bedrockframework.engine.command.ShowBlockerCommand;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.model.State;
	
	public class EngineController extends StandardWidget implements IFrontController
	{
		/*
		Variable Declarations
		*/
		private var _objFrontController:FrontController;
		private var _objSoundController:SoundController;
		/*
		Constructor
		*/
		public function EngineController()
		{
		}
		
		public function initialize():void
		{
			this.createFrontController();
			this.createSoundController();
			this.createListeners();
			this.createCommands();
		}
		/*
		Creation Functions
		*/
		private function createFrontController():void
		{
			this._objFrontController = new FrontController;
			this._objFrontController.initialize();
		}
		private function createSoundController():void
		{
			this._objSoundController = new SoundController;
			this._objSoundController.initialize();
		}
		private function createListeners():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.SET_QUEUE, this.onSetQueue);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_QUEUE, this.onLoadQueue);
			BedrockDispatcher.addEventListener(BedrockEvent.DO_DEFAULT, this.onDoDefault);
			BedrockDispatcher.addEventListener(BedrockEvent.DO_CHANGE, this.onDoChange);
			
			BedrockDispatcher.addEventListener(BedrockEvent.RENDER_PRELOADER, this.onRenderPreloader);
			BedrockDispatcher.addEventListener(BedrockEvent.RENDER_SITE, this.onRenderSite);
			
			BedrockDispatcher.addEventListener(BedrockEvent.SET_QUEUE, this.onStateChange);
			BedrockDispatcher.addEventListener(BedrockEvent.INITIALIZE_COMPLETE, this.onStateChange);
			
			BedrockDispatcher.addEventListener(BedrockEvent.URL_CHANGE, this.onURLChange );
			
			BedrockDispatcher.addEventListener(BedrockEvent.LOCALE_CHANGE, this.onLocaleChange );
			
			if (BedrockEngine.config.getSettingValue(BedrockData.AUTO_INTRO_ENABLED)){
				BedrockDispatcher.addEventListener(BedrockEvent.BEDROCK_COMPLETE, this.onRenderSite);
			}
		}
		private function createCommands():void
		{
			this.addCommand(BedrockEvent.SHOW_BLOCKER, ShowBlockerCommand);
			this.addCommand(BedrockEvent.HIDE_BLOCKER, HideBlockerCommand);
			
			if ( BedrockEngine.config.getSettingValue(BedrockData.AUTO_BLOCKER_ENABLED) ) {
				this.addCommand(BedrockEvent.SET_QUEUE, ShowBlockerCommand);
				this.addCommand(BedrockEvent.INTRO_COMPLETE, HideBlockerCommand);
			}
		}
		/*
		Front Controller Functions
		*/
		public function addCommand($type:String,$command:Class):void
		{
			this._objFrontController.addCommand($type, $command);
		}
		public function removeCommand($type:String,$command:Class):void
		{
			this._objFrontController.removeCommand($type, $command);
		}
		/*
		Queue Event Handlers
	 	*/
		private function onSetQueue($event:BedrockEvent):void
		{
			BedrockEngine.bedrock::pageManager.setQueue(BedrockEngine.config.getPage($event.details.alias));
		}
		private function onLoadQueue($event:BedrockEvent):void
		{
			var objPage:Object=BedrockEngine.bedrock::pageManager.loadQueue();
			if (objPage) {
				BedrockEngine.bedrock::pageManager.setupPageLoad(objPage);
			}
			BedrockEngine.loadManager.loadQueue();
		}
		/*
		Change Event Handlers
	 	*/
		private function onDoDefault($event:BedrockEvent):void
		{
			if (!BedrockEngine.config.getSettingValue(BedrockData.AUTO_DEFAULT_ENABLED)) {
				if (!BedrockEngine.bedrock::state.doneDefault) {
					var strDefaultAlias:String = BedrockEngine.bedrock::pageManager.getDefaultPage($event.details);
					this.status("Transitioning to - " + strDefaultAlias);
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strDefaultAlias}));
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,this));
					BedrockEngine.bedrock::state.doneDefault = true;
				}
			} else {
				BedrockEngine.bedrock::state.doneDefault = true;
			}
		}
		private function onDoChange($event:BedrockEvent):void
		{
			var strAlias:String = $event.details.alias;
			if (BedrockEngine.config.getPage(strAlias)){
				if (BedrockEngine.bedrock::pageManager.current == null || BedrockEngine.bedrock::pageManager.current.alias != strAlias) {
					this.status("Transitioning to - " + strAlias);
					BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE,this,{alias:strAlias}));
					BedrockEngine.bedrock::transitionManager.pageView.outro();
				} else {
					this.warning("Page '" + strAlias + "' is currently loaded!");
				}
			}
		}
		/*
		Render Event Handlers
	 	*/
	 	private function onRenderPreloader($event:BedrockEvent):void
		{
			var objPreloader:*;
			if ( BedrockEngine.config.getSettingValue( BedrockData.SHARED_ENABLED ) ) {
				if (BedrockEngine.assetManager.hasPreloader( BedrockEngine.bedrock::pageManager.queue.alias )) {
					objPreloader = BedrockEngine.assetManager.getPreloader( BedrockEngine.bedrock::pageManager.queue.alias );
				} else {
					objPreloader = BedrockEngine.assetManager.getPreloader( BedrockData.DEFAULT_PRELOADER );
				}
			} else {
				objPreloader = BedrockEngine.assetManager.getPreloader( BedrockData.SHELL_PRELOADER );
			}
			BedrockEngine.containerManager.preloaderContainer.hold( objPreloader );
			BedrockEngine.bedrock::transitionManager.preloaderView = objPreloader;
		}
		private function onRenderSite($event:BedrockEvent):void
		{
			if ( !BedrockEngine.bedrock::state.siteRendered ) {
				var objPreloader:*  = new ShellPreloader;
				BedrockEngine.containerManager.preloaderContainer.hold( objPreloader );
				BedrockEngine.bedrock::transitionManager.preloaderView = objPreloader;
				BedrockEngine.bedrock::state.siteRendered = true;
			}
		}
		/*
		State Event Handlers
		*/
		private function onStateChange($event:BedrockEvent):void
		{
			switch ($event.type) {
				case BedrockEvent.SET_QUEUE :
					BedrockEngine.bedrock::state.change(State.UNAVAILABLE);
					break;
				case BedrockEvent.INITIALIZE_COMPLETE :
					BedrockEngine.bedrock::state.change(State.AVAILABLE);
					break;
			}
		}
		/*
		URL Event Handler
		*/
		private function onURLChange($event:BedrockEvent):void
		{
			if (BedrockEngine.bedrock::state.current != State.INITIALIZED && BedrockEngine.bedrock::state.current != State.UNAVAILABLE ) {
				try {
					var strPath:String = $event.details.paths[0];
					var strCurrentAlias:String = BedrockEngine.bedrock::pageManager.current.alias;
					if (BedrockEngine.config.getPage(strPath) != null) {
						if (strPath && strPath != strCurrentAlias) {
							BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE, this, {alias:strPath}));
						}
					}					
				} catch ($e:Error) {
				}
			}
		}
		/*
		URL Event Handler
		*/
		private function onLocaleChange($event:BedrockEvent):void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.LOCALE_ENABLED ) ) {
				BedrockEngine.localeManager.load( $event.details.locale );
			}
		}
		
		/*
		Copy Event Handlers
		*/
		private function onLoadCopy($event:BedrockEvent):void
		{
			BedrockEngine.resourceManager.load($event.details.locale);
		}
	}
}