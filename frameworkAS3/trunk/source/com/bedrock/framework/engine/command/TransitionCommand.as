package com.bedrock.framework.engine.command
{
	import com.bedrock.framework.core.command.Command;
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.core.event.GenericEvent;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.bedrock;
	import com.bedrock.framework.engine.data.BedrockContentData;
	import com.bedrock.framework.engine.data.BedrockContentGroupData;
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
				case BedrockEvent.INITIAL_TRANSITION :
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
			
			var defaultContent:Array = BedrockEngine.contentManager.filterContents( true, BedrockData.INITIAL_TRANSITION );
			this._appendIndexedContent( defaultContent, "incoming", false );
			
			if ( $details.path == null  || $details.path == this._sequence.deeplink || $details.path == "/" ) {
				this._appendIndexedContent( defaultContent, "incoming" );
			} else {
				var content:Object = BedrockEngine.contentManager.filterContents( "deeplink", $details.path )[ 0 ];
				if ( content != null ) {
					this._sequence.deeplink = content.deeplink;
					this._sequence.appendIncoming( [ content ] );
				} else {
					this._appendIndexedContent( defaultContent, "incoming" );
				}
			}
			
			BedrockEngine.bedrock::transitionController.runSequence( this._sequence );
			return true;
		}
		private function _prepareDeeplinkTransition( $details:Object ):Boolean
		{
			var content:Object = BedrockEngine.contentManager.filterContents( "deeplink", $details.path )[ 0 ];
			if ( $details.style != null ) this._sequence.style = $details.style;
			
			if ( content != null ) {
				return this._prepareStandardTransition( content );
			} else if ( $details.path == this._sequence.deeplink ) {
				var defaultContent:Array = BedrockEngine.contentManager.filterContents( true, BedrockData.INITIAL_TRANSITION );
				this._appendIndexedContent( defaultContent, "incoming" );
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
				this.warning( "Content \"" + ( $details.incoming || $details.id ) + "\" is already being viewed!" );
				return false;
			}
			
			if ( $details.preloader != null ) this._sequence.preloader = $details.preloader;
			if ( $details.preloaderTime != null ) this._sequence.preloaderTime = $details.preloaderTime;
			if ( $details.style != null ) this._sequence.style = $details.style;
			
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
			var data:BedrockContentData = BedrockEngine.contentManager.getContent( $details.incoming || $details.id );
			this._sequence.deeplink = $details.deeplink || data.deeplink;
			data.container = $details.container || data.container;
			
			this._sequence.appendIncoming( [ data ] );
		}
		
		private function _appendOutgoing( $details:Object ):void
		{
			var data:BedrockContentData;
			if ( $details.outgoing != null ) data = BedrockEngine.contentManager.getContent( $details.outgoing );
			if ( data == null ) {
				for each( var queue:Array in BedrockEngine.history.current.incoming ) {
					this._appendIndexedContent( queue, "outgoing" );
				}
			} else {
				this._sequence.appendOutgoing( [ data ] );
			}
		}
		/*
		Utility Functions
		*/
		private function _appendIndexedContent( $queue:Array, $flow:String, $indexed:Boolean = true ):void
		{
			var content:Array = ArrayUtil.filter( $queue, $indexed, BedrockData.INDEXED );
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
		
		
		private function _isContentInHistory( $id:String ):Boolean
		{
			for each ( var queue:Array in BedrockEngine.history.current.incoming ) {
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
		private function _doesContentExist( $id:String ):Boolean
		{
			return BedrockEngine.contentManager.hasContent( $id );
		}
	}
}