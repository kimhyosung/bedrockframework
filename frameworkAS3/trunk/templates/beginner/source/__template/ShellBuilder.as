package __template
{
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.IBedrockBuilder;
	import com.bedrock.framework.engine.builder.BedrockBuilder;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	public class ShellBuilder extends BedrockBuilder implements IView, IBedrockBuilder
	{
		/*
		Variable Declarations
		*/
		public var label:TextField;
		/*
		Constructor
	 	*/
		public function ShellBuilder()
		{
			super();
			this.label.alpha = 0;
		}
		
		public function preinitialize():void
		{
			//BedrockDispatcher.addEventListener( BedrockEvent.TRANSITION_COMPLETE, this._onTransitionComplete );
		}
		
		public function initialize($data:Object=null):void
		{
			this.debug( "Initialize" );
			this.initializeComplete();
		}
		
		public function intro($data:Object=null):void
		{
			this.debug( "Intro" );
			TweenLite.to( this.label, 1, { alpha:1, onComplete:this.introComplete } );
		}
		
		public function outro($data:Object=null):void
		{
			this.outroComplete();
		}
		
		public function clear():void
		{
			this.clearComplete();
		}
		/*
		Event Handlers
	 	*/
	 	private function _onTransitionComplete( $event:Event ):void
		{
			//BedrockDispatcher.removeEventListener( BedrockEvent.LOAD_COMPLETE, this._onLoadComplete );
			//BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.PREPARE_INITIAL_TRANSITION, this ) );
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.PREPARE_INITIAL_LOAD, this ) );
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.PREPARE_INITIAL_TRANSITION, this ) );
		}
	}
}