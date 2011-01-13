package com.bedrock.framework.engine.controller
{
	import com.bedrock.extras.util.StringUtil;
	import com.bedrock.framework.core.base.DispatcherBase;
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.engine.data.BedrockModuleGroupData;
	import com.bedrock.framework.engine.data.BedrockSequenceData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockModuleDisplay;
	import com.bedrock.framework.engine.view.IPreloader;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.bedrock.framework.plugin.view.*;
	
	import flash.events.Event;
	
	public class TransitionController extends DispatcherBase
	{
		/*
		Variable Declarations
		*/
		private var _bedrockSequenceData:BedrockSequenceData;
		private var _viewSequence:ViewSequence;
		private var _viewSequenceData:ViewSequenceData;
		
		private var _shellView:*;
		private var _preloader:IPreloader;
		private var _initialTransitionComplete:Boolean;
		private var _initialLoadPrepared:Boolean;
		/*
		Constructor
		*/
		public function TransitionController()
		{
		}
		/*
		Basic view functions
	 	*/
		public function initialize( $shellView:* ):void
		{
			this._initialTransitionComplete = false;
			this._initialLoadPrepared = false;
			
			this._shellView = $shellView;
			
			this._viewSequence = new ViewSequence;
			this._viewSequence.addEventListener( ViewSequenceEvent.SEQUENCE_COMPLETE, this._onSequenceComplete );
		}
		/*
		Public Transition Function
		*/
		public function transition( $detail:* = null ):void
		{
			if ( this._initialTransitionComplete ) {
				
				if ( $detail is String ) {
					if ( StringUtil.contains( $detail, "/" ) ) {
						this.prepareDeeplinkTransition( { path:$detail } );
					} else {
						this.prepareStandardTransition( { id:$detail } );
					}
				} else {
					if ( $detail.path != null ) {
						this.prepareDeeplinkTransition( $detail );
					} else {
						this.prepareStandardTransition( $detail );
					}
				}
				
			} else {
				
				if ( $detail is String ) {
					if ( StringUtil.contains( $detail, "/" ) ) {
						this.prepareInitialTransition( { path:$detail } );
					} else {
						this.prepareInitialTransition( { id:$detail } );
					}
				} else if ( $detail == null ) {
					this.prepareInitialTransition( {} );
				} else {
					this.prepareInitialTransition( $detail );
				}
				
			}
		}
		/*
		Initial Run Functions
		*/
		public function prepareInitialLoad():void
		{
			this._initialLoadPrepared = true;
			for each( var assetGroup:BedrockAssetGroupData in Bedrock.engine::assetManager.filterGroups( true, BedrockData.INITIAL_LOAD ) ) {
				Bedrock.engine::loadController.appendAssetGroup( assetGroup );
			}
			
			for each( var data:BedrockModuleData in Bedrock.engine::moduleManager.filterModules( true, BedrockData.INITIAL_LOAD ) ) {
				if ( data is BedrockModuleGroupData ) {
					for each( var subData:BedrockModuleData in data.modules ) {
						Bedrock.engine::loadController.appendModule( subData );
					}
				} else {
					Bedrock.engine::loadController.appendModule( data );
				}
			}
		}
		public function prepareInitialTransition( $details:Object ):void
		{
			this._bedrockSequenceData = new BedrockSequenceData;
			var deeplinkPath:String;
			var deeplinkEnabled:Boolean = ( Bedrock.data.deeplinkingEnabled && Bedrock.data.deeplinkModules );
			if ( deeplinkEnabled ) deeplinkPath = Bedrock.engine::deeplinkingManager.getPath();
			deeplinkEnabled = ( deeplinkEnabled && deeplinkPath != this._bedrockSequenceData.deeplink && deeplinkPath != "/" && deeplinkPath != null );
			
			var idEnabled:Boolean = ( $details.id != null && Bedrock.engine::moduleManager.hasModule( $details.id ) );
			
			this._bedrockSequenceData.preloader = BedrockData.INITIAL_PRELOADER;
			this._bedrockSequenceData.preloaderTime = Bedrock.data.initialPreloaderTime;
			
			var defaultModules:Array = Bedrock.engine::moduleManager.filterModules( true, BedrockData.INITIAL_TRANSITION );
			this._appendIndexedModules( defaultModules, "incoming", false );
			
			var module:BedrockModuleData;
			if ( !deeplinkEnabled && !idEnabled ) {
				this._appendIndexedModules( defaultModules, "incoming" );
			} else if ( deeplinkEnabled ) {
				module = Bedrock.engine::moduleManager.filterModules( deeplinkPath, "deeplink" )[ 0 ];
				if ( module != null ) {
					this._bedrockSequenceData.deeplink = module.deeplink;
					this._bedrockSequenceData.appendIncoming( [ module ] );
				} else {
					this._appendIndexedModules( defaultModules, "incoming" );
				}
			} else if ( idEnabled ) {
				module = Bedrock.engine::moduleManager.getModule( $details.id );
				this._bedrockSequenceData.deeplink = module.deeplink;
				this._bedrockSequenceData.appendIncoming( [ module ] );
			}
			this.runTransition();
		}
		public function prepareStandardTransition( $details:Object ):void
		{
			this._bedrockSequenceData = new BedrockSequenceData;
			
			var isGood:Boolean = true;
			if ( !Bedrock.engine::moduleManager.hasModule( $details.incoming || $details.id ) ) {
				Bedrock.logger.warning( "Module \"" + ( $details.incoming || $details.id ) + "\" does not exist!" );
				isGood = false;
			}
			if ( this._isModuleInHistory( $details.incoming || $details.id ) ) {
				Bedrock.logger.warning( "Module \"" + ( $details.incoming || $details.id ) + "\" is already being viewed!" );
				isGood = false;
			}
			
			if ( isGood ) {
				if ( $details.preloader != null ) this._bedrockSequenceData.preloader = $details.preloader;
				if ( $details.preloaderTime != null ) this._bedrockSequenceData.preloaderTime = $details.preloaderTime;
				if ( $details.style != null ) this._bedrockSequenceData.style = $details.style;
				
				this._appendIncomingModules( $details );
				this._appendOutgoingModules( $details );
				
				this.runTransition();
			}
			
		}
		public function prepareDeeplinkTransition( $details:Object ):void
		{
			this._bedrockSequenceData = new BedrockSequenceData;
			var module:BedrockModuleData = Bedrock.engine::moduleManager.filterModules( $details.path, "deeplink" )[ 0 ];
			if ( $details.style != null ) this._bedrockSequenceData.style = $details.style;
			
			if ( module != null ) {
				return this.prepareStandardTransition( module );
			} else if ( $details.path == this._bedrockSequenceData.deeplink ) {
				var defaultModules:Array = Bedrock.engine::moduleManager.filterModules( true, BedrockData.INITIAL_TRANSITION );
				this._appendIndexedModules( defaultModules, "incoming" );
				this._appendOutgoingModules( $details );
				
				this.runTransition();
			}
		}
		/*
		Appends
		*/
		private function _appendIncomingModules( $details:Object ):void
		{
			var data:BedrockModuleData = Bedrock.engine::moduleManager.getModule( $details.incoming || $details.id );
			this._bedrockSequenceData.deeplink = $details.deeplink || data.deeplink;
			data.container = $details.container || data.container;
			
			this._bedrockSequenceData.appendIncoming( [ data ] );
		}
		
		private function _appendOutgoingModules( $details:Object ):void
		{
			var data:BedrockModuleData;
			if ( $details.outgoing != null ) data = Bedrock.engine::moduleManager.getModule( $details.outgoing );
			if ( data == null ) {
				for each( var queue:Array in Bedrock.engine::history.current.incoming ) {
					this._appendIndexedModules( queue, "outgoing" );
				}
			} else {
				this._bedrockSequenceData.appendOutgoing( [ data ] );
			}
		}
		/*
		Utility Functions
		*/
		private function _appendIndexedModules( $queue:Array, $flow:String, $indexed:Boolean = true ):void
		{
			var result:Array = ArrayUtil.filter( $queue, $indexed, BedrockData.INDEXED );
			if ( result.length > 0 ) {
				switch( $flow ) {
					case "incoming" :
						this._bedrockSequenceData.appendIncoming( result );
						break;
					case "outgoing" :
						this._bedrockSequenceData.appendOutgoing( result );
						break;
				}
			}
		}
		
		
		private function _isModuleInHistory( $id:String ):Boolean
		{
			for each ( var queue:Array in Bedrock.engine::history.current.incoming ) {
				for each ( var data:BedrockModuleData in queue ) {
					if ( data is BedrockModuleGroupData ) {
						if ( data.id == $id ) return true;
						for each( var subData:BedrockModuleData in data.modules ) {
							if ( subData.id == $id ) return true;
						}
					} else {
						if ( data.id == $id ) return true;
					}
				}
			}
			return false;
		}
		
		
		/*
		Initial Run Functions
		*/
		public function runShellTransition():void
		{
			this._bedrockSequenceData = new BedrockSequenceData;
			this._bedrockSequenceData.preloader = BedrockData.INITIAL_PRELOADER;
			this._bedrockSequenceData.preloaderTime = Bedrock.data.initialPreloaderTime;
			
			this._preparePreloader();
			
			Bedrock.engine::deeplinkingManager.disableChangeHandler();
			
			Bedrock.engine::loadController.addEventListener( BedrockEvent.LOAD_COMPLETE, this._onLoadComplete );
			Bedrock.engine::loadController.addEventListener( BedrockEvent.LOAD_PROGRESS, this._onLoadProgress );
			
			this._viewSequenceData = new ViewSequenceData;
			this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
			this._viewSequenceData.append( [ new ViewFlowData( this._shellView, ViewFlowData.INCOMING ) ] );
			
			Bedrock.dispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.TRANSITION_PREPARED, this ) );
			this._viewSequence.initialize( this._viewSequenceData );
		}
		public function runTransition():void
		{
			Bedrock.engine::history.appendItem( this._bedrockSequenceData );
			
			Bedrock.engine::deeplinkingManager.disableChangeHandler();
			
			Bedrock.engine::loadController.addEventListener( BedrockEvent.LOAD_COMPLETE, this._onLoadComplete );
			Bedrock.engine::loadController.addEventListener( BedrockEvent.LOAD_PROGRESS, this._onLoadProgress );
			
			this._preparePreloader();
			this._prepareModuleLoad();
			this._prepareSequence();
			
			Bedrock.dispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.TRANSITION_PREPARED, this ) );
			
			this._viewSequence.initialize( this._viewSequenceData );
		}
		
		private function _preparePreloader():void
		{
			if ( Bedrock.data.libraryEnabled ) {
				if ( Bedrock.engine::libraryManager.hasPreloader( this._bedrockSequenceData.preloader ) ) {
					this._preloader = Bedrock.engine::libraryManager.getPreloader( this._bedrockSequenceData.preloader );
				}
			} else {
				this._preloader = Bedrock.engine::libraryManager.getPreloader( BedrockData.INITIAL_PRELOADER );
			}
			this._preloader.addEventListener( ViewEvent.INTRO_COMPLETE, this._onPreloaderIntroComplete );
			this._preloader.addEventListener( ViewEvent.CLEAR_COMPLETE, this._onPreloaderClearComplete );
			Bedrock.engine::containerManager.getContainer( BedrockData.PRELOADER ).addChild( this._preloader );
			
			Bedrock.engine::preloadManager.minimumTime = this._bedrockSequenceData.preloaderTime;
			Bedrock.engine::preloadManager.preloader = this._preloader;
		}
		
		private function _prepareModuleLoad():void
		{
			for each( var queue:Array in this._bedrockSequenceData.incoming ) {
				for each( var data:BedrockModuleData in queue ) {
					if ( data is BedrockModuleGroupData ) {
						for each( var subData:BedrockModuleData in data.modules ) {
							Bedrock.engine::loadController.appendModule( Bedrock.engine::moduleManager.getModule( subData.id ) );
						}
					} else {
						Bedrock.engine::loadController.appendModule( Bedrock.engine::moduleManager.getModule( data.id ) );
					}
				}
			}
		}
		private function _prepareSequence():void
		{
			this._viewSequenceData = new ViewSequenceData;
					
			 switch ( this._bedrockSequenceData.style ) {
				case BedrockSequenceData.NORMAL :
					this._appendFlows( this._bedrockSequenceData.outgoing, ViewFlowData.OUTGOING );
					if ( !Bedrock.engine::loadController.empty ) {
						this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					} else {
						this._prepareIncomingModules();
					}
					if ( !this._initialTransitionComplete ) {
						this._viewSequenceData.append( [ new ViewFlowData( this._shellView, ViewFlowData.INCOMING ) ] );
					}
					this._appendFlows( this._bedrockSequenceData.incoming, ViewFlowData.INCOMING );
					
					break;
				case BedrockSequenceData.PRELOAD :
					if ( !Bedrock.engine::loadController.empty ) {
						this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					} else {
						this._prepareIncomingModules();
					}
					this._appendFlows( this._bedrockSequenceData.outgoing, ViewFlowData.OUTGOING );
					this._appendFlows( this._bedrockSequenceData.incoming, ViewFlowData.INCOMING );
					
					break;
				case BedrockSequenceData.REVERSE :
					if ( !Bedrock.engine::loadController.empty ) {
						this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					} else {
						this._prepareIncomingModules();
					}
					this._appendFlows( this._bedrockSequenceData.incoming, ViewFlowData.INCOMING );
					this._appendFlows( this._bedrockSequenceData.outgoing, ViewFlowData.OUTGOING );
					
					break;
				case BedrockSequenceData.CROSS :
					this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					//sequenceData.append.apply( this, this._appendFlows( sequence.incoming ).concat( this._appendOutgoingFlows( sequence.outgoing ) ) );
					
					break;
				case BedrockSequenceData.CUSTOM :
					break;
			}
			
		}
		private function _appendFlows( $sequence:Array, $flow:Array ):void
		{
			var flows:Array;
			for each ( var queue:Array in $sequence ) {
				for each( var data:BedrockModuleData in queue ) {
					flows = new Array;
					if ( data is BedrockModuleGroupData ) {
						for each ( var subData:BedrockModuleData in data.modules ) {
							flows.push( new ViewFlowData( Bedrock.engine::loadController.getLoaderContent( subData.id ), $flow ) );
						}
					} else {
						flows.push( new ViewFlowData( Bedrock.engine::loadController.getLoaderContent( data.id ), $flow ) );
					}
					this._viewSequenceData.append( flows );
				}
			}
			
		}
		
		
		
		
		private function _prepareIncomingModules():void
		{
			if ( !this._initialTransitionComplete ) this._collectShellExtras();
			
			for each( var queue:Array in this._bedrockSequenceData.incoming ) {
				for each( var data:BedrockModuleData in queue ) {
					if ( data is BedrockModuleGroupData ) {
						for each( var subData:BedrockModuleData in data.modules ) {
							this._collectExtras( subData.id );
						}
					} else {
						this._collectExtras( data.id );
					}
					
				}
				
			}
		}
		
		private function _disposePreloader():void
		{
			Object( this._preloader ).parent.removeChild( this._preloader );
			this._preloader = null;
		}
		private function _disposeOutgoingModules():void
		{
			var moduleDisplay:BedrockModuleDisplay;
			for each( var queue:Array in this._bedrockSequenceData.outgoing ) {
				
				for each( var data:BedrockModuleData in queue ) {
					if ( data is BedrockModuleGroupData ) {
						for each( var subData:BedrockModuleData in data.modules ) {
							if ( subData.autoDispose ) Bedrock.engine::loadController.disposeModule( subData.id );
						}
					} else {
						if ( data.autoDispose ) Bedrock.engine::loadController.disposeModule( data.id );
					}
				}
				
			}
		}
		private function _updateDeeplinking():void
		{
			Bedrock.engine::deeplinkingManager.setPath( this._bedrockSequenceData.deeplink );
		}
		
		
		/*
		Collect
		*/
		private function _collectShellExtras():void
		{
			this._shellView.assets = Bedrock.engine::assetManager.getGroup( BedrockData.SHELL );
			if ( Bedrock.data.dataBundleEnabled && Bedrock.engine::resourceBundleManager.hasBundle( BedrockData.SHELL ) ) {
				this._shellView.bundle = Bedrock.engine::resourceBundleManager.getBundle( BedrockData.SHELL );
			}
		}
		private function _collectExtras( $id:String ):void
		{
			var moduleData:BedrockModuleData = Bedrock.engine::moduleManager.getModule( $id );
			
			var moduleView:BedrockModuleDisplay = Bedrock.engine::loadController.getLoaderContent( $id );
			moduleView.assets = Bedrock.engine::assetManager.getGroup( moduleData.assetGroup );
			
			moduleView.data = Bedrock.engine::moduleManager.getModule( $id );
			if ( Bedrock.data.dataBundleEnabled && Bedrock.engine::resourceBundleManager.hasBundle( $id ) ) {
				moduleView.bundle = Bedrock.engine::resourceBundleManager.getBundle( $id );
			}
		}
		
		/*
		Event Handlers
		*/
		private function _onPreloaderIntroComplete( $event:ViewEvent ):void
		{
			Bedrock.engine::preloadManager.loadBegin();
			Bedrock.engine::loadController.load();
		}
		private function _onPreloaderClearComplete( $event:ViewEvent ):void
		{
			this._disposePreloader();
			if ( Bedrock.data.deeplinkModules ) this._updateDeeplinking();
		}
		
		private function _onLoadComplete($event:BedrockEvent):void
		{
			this._prepareIncomingModules();
			Bedrock.engine::preloadManager.loadComplete();
		}
		private function _onLoadProgress($event:BedrockEvent):void
		{
			Bedrock.engine::preloadManager.progress = $event.details.progress;
		}
		private function _onSequenceComplete($event:Event):void
		{
			if ( !this._initialTransitionComplete ) {
				this._initialTransitionComplete = true;
			}
			
			Bedrock.engine::deeplinkingManager.enableChangeHandler();
			
			Bedrock.engine::loadController.removeEventListener( BedrockEvent.LOAD_COMPLETE, this._onLoadComplete );
			Bedrock.engine::loadController.removeEventListener( BedrockEvent.LOAD_PROGRESS, this._onLoadProgress );
			
			this.dispatchEvent( new BedrockEvent( BedrockEvent.TRANSITION_COMPLETE, this ) );
			this._disposeOutgoingModules();
		}
		
		
	}
}