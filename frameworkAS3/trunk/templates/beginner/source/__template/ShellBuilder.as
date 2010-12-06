package __template
{
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.api.IBedrockBuilder;
	import com.bedrock.framework.engine.builder.BedrockBuilder;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
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
		}
		
		public function initialize($data:Object=null):void
		{
			this.status( "Initialize" );
			this.initializeComplete();
		}
		
		public function intro($data:Object=null):void
		{
			this.status( "Intro" );
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
	}
}