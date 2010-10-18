package com.bedrockframework.engine.controller
{
	import com.bedrockframework.core.controller.FrontController;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.engine.command.HideBlockerCommand;
	import com.bedrockframework.engine.command.ShowBlockerCommand;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.model.State;
	import com.bedrockframework.engine.view.ContainerView;
	
	public class EngineController extends FrontController
	{
		/*
		Variable Declarations
		*/
		/*
		Constructor
		*/
		public function EngineController()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			this.createListeners();
			this.createCommands();
		}
		/*
		Creation Functions
		*/
		private function createListeners():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_QUEUE, this.onLoadQueue);
			BedrockDispatcher.addEventListener(BedrockEvent.DO_DEFAULT, this.onDoDefault);
			BedrockDispatcher.addEventListener(BedrockEvent.DO_CHANGE, this.onDoChange);
			
			BedrockDispatcher.addEventListener(BedrockEvent.RENDER_PRELOADER, this.onRenderPreloader);
			BedrockDispatcher.addEventListener(BedrockEvent.RENDER_SITE, this.onRenderSite);
			
			BedrockDispatcher.addEventListener(BedrockEvent.SET_QUEUE, this.onStateChange);
			BedrockDispatcher.addEventListener(BedrockEvent.PAGE_INITIALIZE_COMPLETE, this.onStateChange);
			BedrockDispatcher.addEventListener(BedrockEvent.SITE_INTRO_COMPLETE, this.onUpdateDeeplinkPath );
			BedrockDispatcher.addEventListener(BedrockEvent.PAGE_OUTRO_COMPLETE, this.onUpdateDeeplinkPath );
			
			BedrockDispatcher.addEventListener(BedrockEvent.URL_CHANGE, this.onURLChange );
			
			BedrockDispatcher.addEventListener(BedrockEvent.LOCALE_CHANGE, this.onLocaleChange );
			
			if (BedrockEngine.config.getSettingValue( BedrockData.AUTO_INTRO_ENABLED ) ){
				BedrockDispatcher.addEventListener( BedrockEvent.BEDROCK_COMPLETE, this.onRenderSite );
			}
		}
		private function createCommands():void
		{
			this.addCommand(BedrockEvent.SHOW_BLOCKER, ShowBlockerCommand);
			this.addCommand(BedrockEvent.HIDE_BLOCKER, HideBlockerCommand);
			
			if ( BedrockEngine.config.getSettingValue(BedrockData.AUTO_BLOCKER_ENABLED) ) {
				this.addCommand(BedrockEvent.SET_QUEUE, ShowBlockerCommand);
				this.addCommand(BedrockEvent.SITE_INTRO_COMPLETE, HideBlockerCommand);
				this.addCommand(BedrockEvent.PAGE_INTRO_COMPLETE, HideBlockerCommand);
			}
		}
		/*
		Queue Event Handlers
	 	*/
		private function onLoadQueue($event:BedrockEvent):void
		{
			var objPage:Object=BedrockEngine.bedrock::transitionManager.loadQueue();
			if (objPage) {
				BedrockEngine.bedrock::transitionManager.setupPageLoad(objPage);
			}
			BedrockEngine.loadManager.loadQueue();
		}
		/*
		Change Event Handlers
	 	*/
		private function onDoDefault($event:BedrockEvent):void
		{
			if ( !BedrockEngine.config.getSettingValue( BedrockData.AUTO_DEFAULT_ENABLED ) ) {
				if ( !BedrockEngine.bedrock::state.doneDefault ) {
					var strDefaultAlias:String = BedrockEngine.bedrock::pageManager.getDefaultPage( $event.details );
					this.status("Transitioning to - " + strDefaultAlias);
					BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.SET_QUEUE, this, { id:strDefaultAlias } ) );
					BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.RENDER_PRELOADER, this ) );
					BedrockEngine.bedrock::state.doneDefault = true;
					BedrockEngine.deeplinkManager.setPath( strDefaultAlias );
				}
			} else {
				BedrockEngine.bedrock::state.doneDefault = true;
			}
		}
		private function onDoChange($event:BedrockEvent):void
		{
			if ( BedrockEngine.bedrock::state.current == State.AVAILABLE ) {
				var strID:String = $event.details.id;
				if ( BedrockEngine.bedrock::pageManager.getPage( strID ) ){
					if (BedrockEngine.history.current == null || BedrockEngine.history.current.id != strID) {
						this.status("Transitioning to - " + strID);
						BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.SET_QUEUE, this, { id:strID } ));
						BedrockEngine.bedrock::transitionManager.setQueue( strID );
						BedrockEngine.bedrock::transitionManager.pageView.outro();
					} else {
						this.warning("Page '" + strID + "' is currently loaded!");
					}
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
				if (BedrockEngine.assetManager.hasPreloader( BedrockEngine.bedrock::transitionManager.queue.id )) {
					objPreloader = BedrockEngine.assetManager.getPreloader( BedrockEngine.bedrock::transitionManager.queue.id );
				} else {
					objPreloader = BedrockEngine.assetManager.getPreloader( BedrockData.DEFAULT_PRELOADER );
				}
			} else {
				objPreloader = BedrockEngine.assetManager.getPreloader( BedrockData.SHELL_PRELOADER );
			}
			var objContainer:ContainerView = BedrockEngine.containerManager.getContainer( BedrockData.PRELOADER_CONTAINER );
			objContainer.hold( objPreloader );
			BedrockEngine.bedrock::transitionManager.preloaderView = objPreloader;
		}
		private function onRenderSite($event:BedrockEvent):void
		{
			if ( !BedrockEngine.bedrock::state.siteRendered ) {
				var objPreloader:*  = new ShellPreloader;
				var objContainer:ContainerView = BedrockEngine.containerManager.getContainer( BedrockData.PRELOADER_CONTAINER );
				objContainer.hold( objPreloader );
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
					BedrockEngine.bedrock::state.change( State.UNAVAILABLE );
					break;
				case BedrockEvent.PAGE_INITIALIZE_COMPLETE :
					BedrockEngine.bedrock::state.change( State.AVAILABLE );
					break;
			}
		}
		/*
		URL Event Handler
		*/
		private function onURLChange($event:BedrockEvent):void
		{
			var strPath:String = $event.details.paths[0];
			if ( strPath != null && strPath != "" ) {
				BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_CHANGE, this, { id:strPath } ));
			}
		}
		/*
		URL Event Handler
		*/
		private function onLocaleChange($event:BedrockEvent):void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.LOCALES_ENABLED ) ) {
				BedrockEngine.localeManager.load( $event.details.locale );
			}
		}
		
		private function onUpdateDeeplinkPath( $event:BedrockEvent ):void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.DEEP_LINKING_ENABLED ) ) {
				BedrockEngine.deeplinkManager.setPath( BedrockEngine.history.current.id );
			}
		}
	}
}