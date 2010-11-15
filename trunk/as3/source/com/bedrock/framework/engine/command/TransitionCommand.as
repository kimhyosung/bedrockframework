package com.bedrock.framework.engine.command
{
	import com.bedrock.framework.core.command.Command;
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.core.event.GenericEvent;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.bedrock;
	import com.bedrock.framework.engine.data.BedrockContentData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.data.BedrockSequenceData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.plugin.util.ArrayUtil;

	public class TransitionCommand extends Command implements ICommand
	{
		/*
		Variable Declarations
		*/
		private var _sequence:BedrockSequenceData;
		/*
		Constructor
	 	*/
		public function TransitionCommand()
		{
		}
		
		public function execute($event:GenericEvent):void
		{
			var transitioning:Boolean = false;
			this._sequence = new BedrockSequenceData;
			switch( $event.type ) {
				case BedrockEvent.DEFAULT_TRANSITION :
					transitioning = this._prepareDefaultTransition( $event.details );
					break;
				case BedrockEvent.TRANSITION :
					transitioning = this._prepareStandardTransition( $event.details );
					break;
				case BedrockEvent.DEEPLINK_CHANGE :
					transitioning = this._prepareDeeplinkTransition( $event.details );
					break;
			}
			if ( transitioning ) BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.TRANSITION_PREPARED, this ) );
		}
		private function _prepareDefaultTransition( $details:Object ):Boolean
		{
			this._sequence.preloader = BedrockData.INITIAL_PRELOADER;
			this._sequence.preloaderTime = BedrockEngine.config.getSettingValue( BedrockData.INITIAL_PRELOADER_TIME );
			
			var defaultContent:Array = BedrockEngine.contentManager.filterContent( BedrockData.DEFAULT, true );
			this._appendAndConvert( ArrayUtil.filter( defaultContent, false, "indexed" ), "incoming" );
			
			if ( $details.path == null  || $details.path == this._sequence.deeplink || $details.path == "/" ) {
				this._appendAndConvert( ArrayUtil.filter( defaultContent, true, "indexed" ), "incoming" );
			} else {
				var content:Object = BedrockEngine.contentManager.filterContent( "deeplink", $details.path )[ 0 ];
				if ( content != null ) {
					this._sequence.deeplink = content.deeplink;
					this._appendAndConvert( [ content ], "incoming" );
				} else {
					this._appendAndConvert( ArrayUtil.filter( defaultContent, true, "indexed" ), "incoming" );
				}
			}
			
			BedrockEngine.bedrock::transitionController.runSequence( this._sequence );
			return true;
		}
		private function _prepareDeeplinkTransition( $details:Object ):Boolean
		{
			var content:Object = BedrockEngine.contentManager.filterContent( "deeplink", $details.path )[ 0 ];
			this._sequence.style = $details.style || BedrockSequenceData[ BedrockEngine.config.getSettingValue( BedrockData.DEFAULT_TRANSITION_STYLE ) ];
			
			if ( content != null ) {
				return this._prepareStandardTransition( content );
			} else if ( $details.path == this._sequence.deeplink ) {
				var defaultContent:Array = BedrockEngine.contentManager.filterContent( BedrockData.DEFAULT, true );
				this._appendAndConvert( ArrayUtil.filter( defaultContent, true, "indexed" ), "incoming" );
				this._appendOutgoing( $details );
				
				BedrockEngine.bedrock::transitionController.runSequence( this._sequence );
				
				return true;
			} else {
				return false;
			}
		}
		private function _prepareStandardTransition( $details:Object ):Boolean
		{
			if ( !BedrockEngine.contentManager.hasContent( $details.incoming || $details.id ) ) {
				this.warning( "Content \"" + ( $details.incoming || $details.id ) + "\" does not exist!" );
				return false;
			}
			if ( this._isContentInHistory( $details.incoming || $details.id ) ) {
				this.warning( "Content \"" + ( $details.incoming || $details.id ) + "\" already loaded!" );
				return false;
			}
			
			if ( $details.preloader != null ) this._sequence.preloader = $details.preloader;
			if ( $details.preloaderTime != null ) this._sequence.preloaderTime = $details.preloaderTime;
			this._sequence.style = $details.style || BedrockSequenceData[ BedrockEngine.config.getSettingValue( BedrockData.DEFAULT_TRANSITION_STYLE ) ];
			
			this._appendIncoming( $details );
			this._appendOutgoing( $details );
			
			BedrockEngine.bedrock::transitionController.runSequence( this._sequence );
			return true;
		}
		/*
		Appends
		*/
		private function _appendIncoming( $details:Object ):void
		{
			var data:Object = BedrockEngine.contentManager.getContent( $details.incoming || $details.id );
			this._sequence.deeplink = $details.deeplink || data.deeplink;
			data.container = $details.container || data.container;
			
			this._sequence.appendIncoming( [ new BedrockContentData( data ) ] );
		}
		
		private function _appendOutgoing( $details:Object ):void
		{
			var data:Object;
			if ( $details.outgoing != null ) data = BedrockEngine.contentManager.getContent( $details.outgoing );
			if ( data == null ) {
				for each( var queue:Array in BedrockEngine.history.current.incoming ) {
					this._appendIndexedContent( queue, "outgoing" );
				}
			} else {
				this._sequence.appendOutgoing( [ new BedrockContentData( data ) ] );
			}
		}
		/*
		Utility Functions
		*/
		private function _appendIndexedContent( $queue:Array, $flow:String, $indexed:Boolean = true ):void
		{
			var content:Array = ArrayUtil.filter( $queue, $indexed, "indexed" );
			if ( content.length > 0 ) {
				switch( $flow ) {
					case "incoming" :
						this._sequence.appendIncoming( content );
						break;
					case "outgoing" :
						this._sequence.appendOutgoing( content );
						break;
				}
			}
		}
		
		private function _appendAndConvert( $queue:Array, $flow:String ):void
		{
			for each( var data:Object in $queue ) {
				switch( $flow ) {
					case "incoming" :
						this._sequence.appendIncoming( [ new BedrockContentData( data ) ] );
						break;
					case "outgoing" :
						this._sequence.appendOutgoing( [ new BedrockContentData( data ) ] );
						break;
				}
			}
		}
		
		private function _isContentInHistory( $id:String ):Boolean
		{
			for each ( var queue:Array in BedrockEngine.history.current.incoming ) {
				for each ( var data:BedrockContentData in queue ) {
					if ( data.isComplex ) {
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
		private function _doesContentExist( $id:String ):Boolean
		{
			return BedrockEngine.contentManager.hasContent( $id );
		}
	}
}