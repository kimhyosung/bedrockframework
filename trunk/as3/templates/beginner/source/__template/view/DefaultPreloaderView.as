package __template.view
{
	import com.bedrock.framework.engine.view.BedrockContentView;
	import com.bedrock.framework.engine.view.IPreloader;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	
	public class DefaultPreloaderView extends BedrockContentView implements IPreloader
	{
		/*
		Variable Declarations
		*/
		public var display:TextField;
		/*
		Constructor
		*/
		public function DefaultPreloaderView()
		{
			this.alpha = 0;
		}
		/*
		Basic view functions
	 	*/
		public function initialize($data:Object=null):void
		{
			this.initializeComplete();
		}
		public function intro($data:Object=null):void
		{
			TweenLite.to(this, 1, { alpha:1, onComplete:this.introComplete } );
			//this.introComplete();
		}
		public function outro($data:Object=null):void
		{
			TweenLite.to(this, 1, { alpha:0, onComplete:this.outroComplete } );
			//this.outroComplete();
		}
		public function displayProgress( $value:Number ):void
		{
			this.display.text= $value + " %";
		}
		public function clear():void
		{
			this.clearComplete();
		}
		

	}
}