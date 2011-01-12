package com.bedrock.framework.engine.controller
{
	import com.bedrock.extras.util.StringUtil;
	import com.bedrock.framework.core.base.DispatcherBase;
	import com.bedrock.framework.engine.*;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockContentData;
	import com.bedrock.framework.engine.data.BedrockContentGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.data.BedrockSequenceData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockContentDisplay;
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
			
			for each( var data:BedrockContentData in Bedrock.engine::contentManager.filterContent( true, BedrockData.INITIAL_LOAD ) ) {
				if ( data is BedrockContentGroupData ) {
					for each( var subData:BedrockContentData in data.contents ) {
						Bedrock.engine::loadController.appendContent( subData );
					}
				} else {
					Bedrock.engine::loadController.appendContent( data );
				}
			}
		}
		public function prepareInitialTransition( $details:Object ):void
		{
			this._bedrockSequenceData = new BedrockSequenceData;
			var deeplinkPath:String;
			var deeplinkEnabled:Boolean = ( Bedrock.data.deeplinkingEnabled && Bedrock.data.deeplinkContent );
			if ( deeplinkEnabled ) deeplinkPath = Bedrock.engine::deeplinkingManager.getPath();
			deeplinkEnabled = ( deeplinkEnabled && deeplinkPath != this._bedrockSequenceData.deeplink && deeplinkPath != "/" && deeplinkPath != null );
			
			var idEnabled:Boolean = ( $details.id != null && Bedrock.engine::contentManager.hasContent( $details.id ) );
			
			this._bedrockSequenceData.preloader = BedrockData.INITIAL_PRELOADER;
			this._bedrockSequenceData.preloaderTime = Bedrock.data.initialPreloaderTime;
			
			var defaultContent:Array = Bedrock.engine::contentManager.filterContent( true, BedrockData.INITIAL_TRANSITION );
			this._appendIndexedContent( defaultContent, "incoming", false );
			
			var content:BedrockContentData;
			if ( !deeplinkEnabled && !idEnabled ) {
				this._appendIndexedContent( defaultContent, "incoming" );
			} else if ( deeplinkEnabled ) {
				content = Bedrock.engine::contentManager.filterContent( deeplinkPath, "deeplink" )[ 0 ];
				if ( content != null ) {
					this._bedrockSequenceData.deeplink = content.deeplink;
					this._bedrockSequenceData.appendIncoming( [ content ] );
				} else {
					this._appendIndexedContent( defaultContent, "incoming" );
				}
			} else if ( idEnabled ) {
				content = Bedrock.engine::contentManager.getContent( $details.id );
				this._bedrockSequenceData.deeplink = content.deeplink;
				this._bedrockSequenceData.appendIncoming( [ content ] );
			}
			this.runTransition();
		}
		public function prepareStandardTransition( $details:Object ):void
		{
			this._bedrockSequenceData = new BedrockSequenceData;
			
			var isGood:Boolean = true;
			if ( !Bedrock.engine::contentManager.hasContent( $details.incoming || $details.id ) ) {
				Bedrock.logger.warning( "Content \"" + ( $details.incoming || $details.id ) + "\" does not exist!" );
				isGood = false;
			}
			if ( this._isContentInHistory( $details.incoming || $details.id ) ) {
				Bedrock.logger.warning( "Content \"" + ( $details.incoming || $details.id ) + "\" is already being viewed!" );
				isGood = false;
			}
			
			if ( isGood ) {
				if ( $details.preloader != null ) this._bedrockSequenceData.preloader = $details.preloader;
				if ( $details.preloaderTime != null ) this._bedrockSequenceData.preloaderTime = $details.preloaderTime;
				if ( $details.style != null ) this._bedrockSequenceData.style = $details.style;
				
				this._appendIncomingContent( $details );
				this._appendOutgoingContent( $details );
				
				this.runTransition();
			}
			
		}
		public function prepareDeeplinkTransition( $details:Object ):void
		{
			this._bedrockSequenceData = new BedrockSequenceData;
			var content:Object = Bedrock.engine::contentManager.filterContent( $details.path, "deeplink" )[ 0 ];
			if ( $details.style != null ) this._bedrockSequenceData.style = $details.style;
			
			if ( content != null ) {
				return this.prepareStandardTransition( content );
			} else if ( $details.path == this._bedrockSequenceData.deeplink ) {
				var defaultContent:Array = Bedrock.engine::contentManager.filterContent( true, BedrockData.INITIAL_TRANSITION );
				this._appendIndexedContent( defaultContent, "incoming" );
				this._appendOutgoingContent( $details );
				
				this.runTransition();
			}
		}
		/*
		Appends
		*/
		private function _appendIncomingContent( $details:Object ):void
		{
			var data:BedrockContentData = Bedrock.engine::contentManager.getContent( $details.incoming || $details.id );
			this._bedrockSequenceData.deeplink = $details.deeplink || data.deeplink;
			data.container = $details.container || data.container;
			
			this._bedrockSequenceData.appendIncoming( [ data ] );
		}
		
		private function _appendOutgoingContent( $details:Object ):void
		{
			var data:BedrockContentData;
			if ( $details.outgoing != null ) data = Bedrock.engine::contentManager.getContent( $details.outgoing );
			if ( data == null ) {
				for each( var queue:Array in Bedrock.engine::history.current.incoming ) {
					this._appendIndexedContent( queue, "outgoing" );
				}
			} else {
				this._bedrockSequenceData.appendOutgoing( [ data ] );
			}
		}
		/*
		Utility Functions
		*/
		private function _appendIndexedContent( $queue:Array, $flow:String, $indexed:Boolean = true ):void
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
		
		
		private function _isContentInHistory( $id:String ):Boolean
		{
			for each ( var queue:Array in Bedrock.engine::history.current.incoming ) {
				for each ( var data:BedrockContentData in queue ) {
					if ( data is BedrockContentGroupData ) {
						if ( data.id == $id ) return true;
						for each( var subData:BedrockContentData in data.contents ) {
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
			this._prepareContentLoad();
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
		
		private function _prepareContentLoad():void
		{
			for each( var queue:Array in this._bedrockSequenceData.incoming ) {
				for each( var data:BedrockContentData in queue ) {
					if ( data is BedrockContentGroupData ) {
						for each( var subData:BedrockContentData in data.contents ) {
							Bedrock.engine::loadController.appendContent( Bedrock.engine::contentManager.getContent( subData.id ) );
						}
					} else {
						Bedrock.engine::loadController.appendContent( Bedrock.engine::contentManager.getContent( data.id ) );
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
						this._prepareIncomingContent();
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
						this._prepareIncomingContent();
					}
					this._appendFlows( this._bedrockSequenceData.outgoing, ViewFlowData.OUTGOING );
					this._appendFlows( this._bedrockSequenceData.incoming, ViewFlowData.INCOMING );
					
					break;
				case BedrockSequenceData.REVERSE :
					if ( !Bedrock.engine::loadController.empty ) {
						this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					} else {
						this._prepareIncomingContent();
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
				for each( var data:BedrockContentData in queue ) {
					flows = new Array;
					if ( data is BedrockContentGroupData ) {
						for each ( var subData:BedrockContentData in data.contents ) {
							flows.push( new ViewFlowData( Bedrock.engine::loadController.getLoaderContent( subData.id ), $flow ) );
						}
					} else {
						flows.push( new ViewFlowData( Bedrock.engine::loadController.getLoaderContent( data.id ), $flow ) );
					}
					this._viewSequenceData.append( flows );
				}
			}
			
		}
		
		
		
		
		private function _prepareIncomingContent():void
		{
			if ( !this._initialTransitionComplete ) this._collectShellExtras();
			
			for each( var queue:Array in this._bedrockSequenceData.incoming ) {
				for each( var data:BedrockContentData in queue ) {
					if ( data is BedrockContentGroupData ) {
						for each( var subData:BedrockContentData in data.contents ) {
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
		private function _disposeOutgoingContent():void
		{
			var contentDisplay:BedrockContentDisplay
			for each( var queue:Array in this._bedrockSequenceData.outgoing ) {
				
				for each( var data:BedrockContentData in queue ) {
					if ( data is BedrockContentGroupData ) {
						for each( var subData:BedrockContentData in data.contents ) {
							if ( subData.autoDispose ) Bedrock.engine::loadController.disposeContent( subData.id );
						}
					} else {
						if ( data.autoDispose ) Bedrock.engine::loadController.disposeContent( data.id );
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
			var contentObj:Object = Bedrock.engine::contentManager.getContent( $id );
			
			var contentView:BedrockContentDisplay = Bedrock.engine::loadController.getLoaderContent( $id );
			contentView.assets = Bedrock.engine::assetManager.getGroup( contentObj.assetGroup );
			
			contentView.data = Bedrock.engine::contentManager.getContent( $id );
			if ( Bedrock.data.dataBundleEnabled && Bedrock.engine::resourceBundleManager.hasBundle( $id ) ) {
				contentView.bundle = Bedrock.engine::resourceBundleManager.getBundle( $id );
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
			if ( Bedrock.data.deeplinkContent ) this._updateDeeplinking();
		}
		
		private function _onLoadComplete($event:BedrockEvent):void
		{
			this._prepareIncomingContent();
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
			this._disposeOutgoingContent();
		}
		
		
	}
}