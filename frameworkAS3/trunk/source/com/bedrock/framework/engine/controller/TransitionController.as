package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.core.dispatcher.DispatcherBase;
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.api.ITransitionController;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.data.BedrockDeeplinkData;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.engine.data.BedrockModuleGroupData;
	import com.bedrock.framework.engine.data.BedrockSequenceData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockModuleDisplay;
	import com.bedrock.framework.engine.view.IPreloader;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.bedrock.framework.plugin.view.*;
	
	import flash.events.Event;
	/**
	 * @private
	 */
	public class TransitionController extends DispatcherBase implements ITransitionController
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
		public function transition( $details:* = null ):void
		{
			if ( this._initialTransitionComplete && $details != null ) {
				
				if ( $details is String ) {
					if ( this._stringContains( $details, "/" ) ) {
						if ( Bedrock.data.deeplinkingEnabled && !Bedrock.data.autoDeeplinkToModules ) {
							Bedrock.deeplinking.setAddress( $details );
						} else {
							this.prepareDeeplinkTransition( { path:$details } );
						}
					} else {
						this.prepareStandardTransition( { id:$details } );
					}
				} else {
					if ( $details.path != null ) {
						if ( Bedrock.data.deeplinkingEnabled && !Bedrock.data.autoDeeplinkToModules ) {
							Bedrock.deeplinking.setAddress( $details.path );
						} else {
							this.prepareDeeplinkTransition( $details );
						}
					} else {
						this.prepareStandardTransition( $details );
					}
				}
				
			} else {
				
				 if ( $details == null ) {
					this.prepareInitialTransition( {} );
				} else if ( $details is String ) {
					if ( this._stringContains( $details, "/" ) ) {
						this.prepareInitialTransition( { path:$details } );
					} else {
						this.prepareInitialTransition( { id:$details } );
					}
				} else {
					this.prepareInitialTransition( $details );
				}
				
			}
		}
		private function _stringContains($string:String, $char:String):Boolean
		{
			if ($string == null) {
				return false;
			}
			return $string.indexOf($char) != -1;
		}
		/*
		Initial Run Functions
		*/
		public function prepareInitialLoad():void
		{
			this._initialLoadPrepared = true;
			for each( var assetGroup:BedrockAssetGroupData in Bedrock.engine::assetManager.filterGroups( BedrockData.INITIAL_LOAD, true ) ) {
				Bedrock.engine::loadController.appendAssetGroup( assetGroup );
			}
			
			for each( var data:BedrockModuleData in Bedrock.engine::moduleManager.filterModules( BedrockData.INITIAL_LOAD, true ) ) {
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
			var deeplinkEnabled:Boolean = Bedrock.data.deeplinkingEnabled;
			if ( deeplinkEnabled ) deeplinkPath = Bedrock.engine::deeplinkingManager.getPath();
			deeplinkEnabled = ( deeplinkEnabled && deeplinkPath != this._bedrockSequenceData.deeplink && deeplinkPath != "/" && deeplinkPath != null );
			
			var idEnabled:Boolean = ( $details.id != null && Bedrock.engine::moduleManager.hasModule( $details.id ) );
			
			this._bedrockSequenceData.preloader = BedrockData.INITIAL_PRELOADER;
			this._bedrockSequenceData.preloaderTime = Bedrock.data.initialPreloaderTime;
			
			var defaultModules:Array = Bedrock.engine::moduleManager.filterModules( BedrockData.INITIAL_TRANSITION, true );
			this._appendIndexedModules( defaultModules, "incoming", false );
			
			var module:BedrockModuleData;
			if ( !deeplinkEnabled && !idEnabled ) {
				this._appendIndexedModules( defaultModules, "incoming" );
			} else if ( deeplinkEnabled ) {
				module = Bedrock.engine::moduleManager.getModule( this._getModuleIDFromDeeplink( deeplinkPath ) );
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
			
			var id:String = this._getModuleIDFromDeeplink( $details.path );
			
			if ( Bedrock.engine::moduleManager.hasModule( id ) ) {
				var module:BedrockModuleData = Bedrock.engine::moduleManager.getModule( id );
				if ( $details.style != null ) this._bedrockSequenceData.style = $details.style;
				
				if ( module != null ) {
					return this.prepareStandardTransition( module );
				} else if ( $details.path == this._bedrockSequenceData.deeplink ) {
					var defaultModules:Array = Bedrock.engine::moduleManager.filterModules( BedrockData.INITIAL_TRANSITION, true );
					this._appendIndexedModules( defaultModules, "incoming" );
					this._appendOutgoingModules( $details );
					
					this.runTransition();
				}
			}
		}
		private function _getModuleIDFromDeeplink( $deeplink:String ):String
		{
			var startIndex:int = ( $deeplink.charAt(0) == "/" ) ? 1 : 0;
			var endIndex:int = $deeplink.indexOf( "/", startIndex );
			if ( endIndex == -1 ) endIndex = $deeplink.length;
			return $deeplink.substring( startIndex, endIndex );
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
				for each( var queue:Array in Bedrock.engine::historyModel.current.incoming ) {
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
			for each ( var queue:Array in Bedrock.engine::historyModel.current.incoming ) {
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
			Bedrock.engine::historyModel.appendItem( this._bedrockSequenceData );
			
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
			if ( Bedrock.data.resourceBundleEnabled && Bedrock.engine::resourceBundleManager.hasBundle( BedrockData.SHELL ) ) {
				this._shellView.bundle = Bedrock.engine::resourceBundleManager.getBundle( BedrockData.SHELL );
			}
		}
		private function _collectExtras( $id:String ):void
		{
			var moduleData:BedrockModuleData = Bedrock.engine::moduleManager.getModule( $id );
			
			var moduleView:BedrockModuleDisplay = Bedrock.engine::loadController.getLoaderContent( $id );
			moduleView.assets = Bedrock.engine::assetManager.getGroup( moduleData.assetGroup );
			
			if ( Bedrock.data.deeplinkingEnabled ) moduleView.deeplink = new BedrockDeeplinkData;
			
			moduleView.details = Bedrock.engine::moduleManager.getModule( $id );
			if ( Bedrock.data.resourceBundleEnabled && Bedrock.engine::resourceBundleManager.hasBundle( $id ) ) {
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
			if ( Bedrock.data.autoDeeplinkToModules ) this._updateDeeplinking();
			
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