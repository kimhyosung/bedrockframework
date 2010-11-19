package 
{
	import com.bedrock.framework.plugin.util.ButtonUtil;
	import com.bedrock.framework.plugin.view.IView;
	import com.bedrock.framework.plugin.view.MovieClipView;
	import com.bedrock.framework.plugin.view.ViewStack;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TestView extends MovieClipView implements IView
	{
		/*
		Variable Declarations
		*/
		
		/*
		Constructor
		*/
		public function TestView()
		{
			this.alpha=0;
			this.addEventListener( Event.ADDED_TO_STAGE, this._onAddedToStage );
		}
		public function initialize($data:Object=null):void
		{
			ButtonUtil.addListeners( this, { down:this._onClick } );
			this.initializeComplete();
		}
		public function intro($data:Object=null):void
		{
			TweenLite.to( this, 1, { alpha:1, onComplete:this.introComplete } );
		}
		public function outro($data:Object=null):void
		{
			TweenLite.to( this, 1, { alpha:0, onComplete:this.outroComplete } );
		}
		public function clear():void
		{
			this.clearComplete();
		}
		/*
		Event Handlers
		*/
		private function _onClick($event:MouseEvent):void
		{
			//this.outro();
			ViewStack( this.parent ).selectNext();
		}
		private function _onAddedToStage($event:Event):void
		{
			this.x = this.stage.stageWidth / 2;
			this.y = this.stage.stageHeight / 2;
		}
	}
}