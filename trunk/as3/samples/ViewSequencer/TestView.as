package 
{
	import com.autumntactics.bedrock.view.View;
	import com.autumntactics.bedrock.view.IView;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import caurina.transitions.Tweener;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	public class TestView extends View implements IView
	{

		/*
		Variable Declarations
		*/
		public var txtDisplay:TextField;
		public var txtLabel:TextField;
		/*
		Constructor
		*/
		public function TestView()
		{
			this.alpha=0;
		}
		public function initialize($properties:Object=null):void
		{
			this.displayProgress(10000);
			this.txtLabel.text = "Meh";
			this.x=this.stage.stageWidth / 2;
			this.y=this.stage.stageHeight / 2;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, this.onClick);
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			Tweener.addTween(this,{alpha:1,transition:"linear",time:1,onComplete:this.introComplete});
			//this.introComplete();
		}
		public function displayProgress($percent:Number):void
		{
			this.txtDisplay.text=$percent + " %";
		}
		public function outro($properties:Object=null):void
		{
			Tweener.addTween(this,{alpha:0,transition:"linear",time:1,onComplete:this.outroComplete});
			//this.outroComplete();
		}
		public function clear():void
		{

		}
		/*
		Event Handlers
		*/
		private function onClick($event:MouseEvent):void
		{
			this.outro();
		}
	}
}