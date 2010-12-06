package com.bedrock.framework.engine.controller
{
	import com.bedrock.framework.core.base.DispatcherBase;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.ITransitionController;
	import com.bedrock.framework.engine.bedrock;
	import com.bedrock.framework.engine.command.PrepareInitialLoadCommand;
	import com.bedrock.framework.engine.command.PrepareInitialTransitionCommand;
	import com.bedrock.framework.engine.data.BedrockContentData;
	import com.bedrock.framework.engine.data.BedrockContentGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.data.BedrockSequenceData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockContentDisplay;
	import com.bedrock.framework.engine.view.IPreloader;
	import com.bedrock.framework.plugin.view.*;
	
	import flash.events.Event;
	
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
			
			this._shellView = $shellView;
			
			this._viewSequence = new ViewSequence;
			this._viewSequence.addEventListener( ViewSequenceEvent.SEQUENCE_COMPLETE, this._onSequenceComplete );
		}
		/*
		Initial Run Functions
		*/
		public function runSequence( $sequence:BedrockSequenceData ):void
		{
			this._bedrockSequenceData = $sequence;
			BedrockEngine.history.appendItem( this._bedrockSequenceData );
			
			BedrockEngine.deeplinkingManager.disableChangeHandler();
			
			BedrockEngine.loadController.addEventListener( BedrockEvent.LOAD_COMPLETE, this._onLoadComplete );
			BedrockEngine.loadController.addEventListener( BedrockEvent.LOAD_PROGRESS, this._onLoadProgress );
			
			this._preparePreloader();
			this._prepareContentLoad();
			this._prepareSequence();
		}
		
		private function _prepareContentLoad():void
		{
			for each( var queue:Array in this._bedrockSequenceData.incoming ) {
				for each( var data:BedrockContentData in queue ) {
					if ( data is BedrockContentGroupData ) {
						for each( var subData:BedrockContentData in data.contents ) {
							BedrockEngine.loadController.appendContent( BedrockEngine.contentManager.getContent( subData.id ) );
						}
					} else {
						BedrockEngine.loadController.appendContent( BedrockEngine.contentManager.getContent( data.id ) );
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
					this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					if ( !this._initialTransitionComplete ) {
						this._viewSequenceData.append( [ new ViewFlowData( this._shellView, ViewFlowData.INCOMING ) ] );
					}
					this._appendFlows( this._bedrockSequenceData.incoming, ViewFlowData.INCOMING );
					
					break;
				case BedrockSequenceData.PRELOAD :
					this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					this._appendFlows( this._bedrockSequenceData.outgoing, ViewFlowData.OUTGOING );
					this._appendFlows( this._bedrockSequenceData.incoming, ViewFlowData.INCOMING );
					
					break;
				case BedrockSequenceData.REVERSE :
					this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					this._appendFlows( this._bedrockSequenceData.incoming, ViewFlowData.INCOMING );
					this._appendFlows( this._bedrockSequenceData.outgoing, ViewFlowData.OUTGOING );
					
					break;
				case BedrockSequenceData.CROSS :
					this._viewSequenceData.append( [ new ViewFlowData( this._preloader, ViewFlowData.ROUND_TRIP ) ] );
					//sequenceData.append.apply( this, this._appendFlows( this._sequence.incoming ).concat( this._appendOutgoingFlows( this._sequence.outgoing ) ) );
					
					break;
				case BedrockSequenceData.CUSTOM :
					break;
			}
			
			this._viewSequence.initialize( this._viewSequenceData );
		}
		private function _appendFlows( $sequence:Array, $flow:Array ):void
		{
			var flows:Array;
			for each ( var queue:Array in $sequence ) {
				for each( var data:BedrockContentData in queue ) {
					flows = new Array;
					if ( data is BedrockContentGroupData ) {
						for each ( var subData:BedrockContentData in data.contents ) {
							flows.push( new ViewFlowData( BedrockEngine.loadController.getLoaderContent( subData.id ), $flow ) );
						}
					} else {
						flows.push( new ViewFlowData( BedrockEngine.loadController.getLoaderContent( data.id ), $flow ) );
					}
					this._viewSequenceData.append( flows );
				}
			}
			
		}
		
		private function _preparePreloader():void
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.LIBRARY_ENABLED ) ) {
				if ( BedrockEngine.libraryManager.hasPreloader( this._bedrockSequenceData.preloader ) ) {
					this._preloader = BedrockEngine.libraryManager.getPreloader( this._bedrockSequenceData.preloader );
				}
			} else {
				this._preloader = BedrockEngine.libraryManager.getPreloader( BedrockData.INITIAL_PRELOADER );
			}
			this._preloader.addEventListener( ViewEvent.INTRO_COMPLETE, this._onPreloaderIntroComplete );
			this._preloader.addEventListener( ViewEvent.CLEAR_COMPLETE, this._onPreloaderClearComplete );
			BedrockEngine.containerManager.getContainer( BedrockData.PRELOADER ).addChild( this._preloader );
			
			BedrockEngine.bedrock::preloadManager.minimumTime = this._bedrockSequenceData.preloaderTime;
			BedrockEngine.bedrock::preloadManager.preloader = this._preloader;
		}
		
		
		private function _prepareIncoming():void
		{
			for each( var queue:Array in this._bedrockSequenceData.incoming ) {
				for each( var data:BedrockContentData in queue ) {
					if ( data is BedrockContentGroupData ) {
						for each( var subData:BedrockContentData in data.contents ) {
							this._collectExtras( subData.id );
							this._addContentToContainer( subData );
						}
					} else {
						this._collectExtras( data.id );
						this._addContentToContainer( data );
					}
					
				}
				
			}
		}
		
		private function _addContentToContainer( $data:BedrockContentData ):void
		{
			if ( BedrockEngine.containerManager.hasContainer( $data.container ) ) {
				BedrockEngine.containerManager.getContainer( $data.container ).addChild( BedrockEngine.loadController.getLoaderContent( $data.id ) );
			} else {
				this.warning( "Container \"" + $data.container + "\" not found for content \"" + $data.id + "\"!" );
			}
		}
		
		
		
		
		private function _disposePreloader():void
		{
			Object( this._preloader ).parent.removeChild( this._preloader );
		}
		private function _disposeOutgoing():void
		{
			var contentDisplay:BedrockContentDisplay
			for each( var queue:Array in this._bedrockSequenceData.outgoing ) {
				
				for each( var data:BedrockContentData in queue ) {
					if ( data is BedrockContentGroupData ) {
						for each( var subData:BedrockContentData in data.contents ) {
							if ( subData.autoDispose ) BedrockEngine.loadController.disposeContent( subData.id );
						}
					} else {
						if ( data.autoDispose ) BedrockEngine.loadController.disposeContent( data.id );
					}
				}
				
			}
		}
		private function _updateDeeplinking():void
		{
			BedrockEngine.deeplinkingManager.setPath( this._bedrockSequenceData.deeplink );
		}
		
		
		/*
		Collect
		*/
		private function _collectShellExtras():void
		{
			this._shellView.assets = BedrockEngine.loadController.getAssetGroup( BedrockData.SHELL );
			this._shellView.bundle = this._collectBundle( BedrockData.SHELL );
		}
		private function _collectExtras( $id:String ):void
		{
			var contentObj:Object = BedrockEngine.contentManager.getContent( $id );
			var contentView:BedrockContentDisplay = BedrockEngine.loadController.getLoaderContent( $id );
			var id:String = ( contentObj.assetGroup != BedrockData.NONE ) ? contentObj.assetGroup : contentObj.id;
			
			contentView.properties = BedrockEngine.contentManager.getContent( $id );
			contentView.assets = BedrockEngine.loadController.getAssetGroup( id );
			contentView.bundle = this._collectBundle( id );
		}
		private function _collectBundle( $id:String ):*
		{
			if ( BedrockEngine.config.getSettingValue( BedrockData.DATA_BUNDLE_ENABLED ) ) {
				 if ( BedrockEngine.dataBundleManager.hasBundle( $id ) ) {
					return BedrockEngine.dataBundleManager.getBundle( $id );
				} 
			}
			return new Object;
		}
		/*
		Event Handlers
		*/
		private function _onPreloaderIntroComplete( $event:ViewEvent ):void
		{
			BedrockEngine.bedrock::preloadManager.loadBegin();
			BedrockEngine.loadController.load();
		}
		private function _onPreloaderClearComplete( $event:ViewEvent ):void
		{
			this._disposePreloader();
			if ( BedrockEngine.config.getSettingValue( BedrockData.DEEPLINK_CONTENT ) ) this._updateDeeplinking();
		}
		
		private function _onLoadComplete($event:BedrockEvent):void
		{
			if ( !this._initialTransitionComplete ) this._collectShellExtras();
			this._prepareIncoming();
			BedrockEngine.bedrock::preloadManager.loadComplete();
		}
		private function _onLoadProgress($event:BedrockEvent):void
		{
			BedrockEngine.bedrock::preloadManager.progress = $event.details.progress;
		}
		private function _onSequenceComplete($event:Event):void
		{
			if ( !this._initialTransitionComplete ) {
				this._initialTransitionComplete = true;
			}
			
			BedrockEngine.deeplinkingManager.enableChangeHandler();
			
			BedrockEngine.loadController.removeEventListener( BedrockEvent.LOAD_COMPLETE, this._onLoadComplete );
			BedrockEngine.loadController.removeEventListener( BedrockEvent.LOAD_PROGRESS, this._onLoadProgress );
			
			this.dispatchEvent( new BedrockEvent( BedrockEvent.TRANSITION_COMPLETE, this ) );
			this._disposeOutgoing();
		}
		
	}
}