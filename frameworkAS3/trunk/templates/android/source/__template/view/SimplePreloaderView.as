package __template.view
{
	import com.bedrock.framework.plugin.view.MovieClipView;
	import com.bedrock.framework.engine.view.IPreloader;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	
	public class SimplePreloaderView extends MovieClipView implements IPreloader
	{
		/*
		Variable Declarations
		*/
		public var display:TextField;
		/*
		Constructor
		*/
		public function SimplePreloaderView()
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
			this.display.text= int( $value * 100 ) + " %";
		}
		public function clear():void
		{
			this.clearComplete();
		}
		

	}
}