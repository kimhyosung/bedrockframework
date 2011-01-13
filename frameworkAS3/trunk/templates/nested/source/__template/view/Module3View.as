package __template.view
{
	import com.bedrock.framework.engine.Bedrock;
	import com.bedrock.framework.engine.view.BedrockModuleView;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	
	public class Module3View extends BedrockModuleView implements IView
	{
		/*
		Variable Declarations
		*/
		public var label:TextField;
		/*
		Constructor
		*/
		public function Module3View()
		{
			this.alpha = 0;
		}
		/*
		Basic view functions
	 	*/
		public function initialize($data:Object=null):void
		{
			Bedrock.logger.status( "Initialize" );
			this.label.text = this.data.label;
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