package __template.view
{
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.engine.view.BedrockModuleView;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	import flash.media.Video;
	import flash.media.Camera;
	
	public class Module1View extends BedrockModuleView implements IView
	{
		/*
		Variable Declarations
		*/
		public var label:TextField;
		public var mobileVideo:Video;
		public var mobileCamera:Camera;
		/*
		Constructor
		*/
		public function Module1View()
		{
			this.alpha = 0;
		}
		/*
		Basic view functions
	 	*/
		public function initialize($data:Object=null):void
		{
			Bedrock.logger.status( "Initialize" );
			this.label.text = this.details.label;
			
			
			this.mobileCamera = Camera.getCamera();
			if( this,mobileCamera && !this.mobileCamera.muted ) {
				this.mobileCamera.setMode( this.mobileVideo.width, this.mobileVideo.height, 15 );
				this.mobileVideo.attachCamera( this.mobileCamera );
			}
			
			this.initializeComplete();
		}
		public function intro($data:Object=null):void
		{
			Bedrock.logger.status( "Intro" );
			TweenLite.to(this, 1, { alpha:1, onComplete:this.introComplete } );
			//this.introComplete();
		}
		public function outro($data:Object=null):void
		{
			TweenLite.to(this, 1, { alpha:0, onComplete:this.outroComplete } );
			//this.outroComplete();
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