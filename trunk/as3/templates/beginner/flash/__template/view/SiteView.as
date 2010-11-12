package __template.view
{
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockContentView;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	
	public class SiteView extends BedrockContentView implements IView
	{
		/*
		Variable Declarations
		*/
		public var label:TextField;
		public var button1:*;
		public var button2:*;
		/*
		Constructor
	 	*/
		public function SiteView()
		{
			this.alpha = 0;
		}
		/*
		Basic view functions
	 	*/
		public function initialize($data:Object=null):void
		{
			this.status( "Initialize" );
			this.label.text = this.properties.label;
			this.button1.addEventListener( "click", this._onClick1 );
			this.button1.label.text = "Content 3 > Content1";
			this.button2.addEventListener( "click", this._onClick2 );
			this.button2.label.text = "Content 4 > Content2";
			this.initializeComplete();
		}
		function _onClick1 ( $event) {
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.TRANSITION, this, { incoming:"content1", outgoing:"content3", container:"container1" } ) );
		}
		function _onClick2 ( $event) {
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.TRANSITION, this, { incoming:"content2", outgoing:"content4", container:"container2" } ) );
		}

		public function intro($data:Object=null):void
		{
			this.status( "Intro" );
			//BedrockDispatcher.dispatchEvent( new BedrockEvent(BedrockEvent.DO_DEFAULT, this ) );
			TweenLite.to(this, 1, {alpha:1, onComplete:this.introComplete});
			//this.introComplete();
		}
		public function outro($data:Object=null):void
		{
			TweenLite.to(this, 1, {alpha:0, onComplete:this.outroComplete});
			//this.outroComplete();
		}
		public function clear():void
		{
			this.clearComplete();
		}
	}
}