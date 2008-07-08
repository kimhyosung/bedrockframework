package com.autumntactics.project.template.view
{
	import com.autumntactics.bedrock.view.View;
	import com.autumntactics.bedrock.view.IView;
	import caurina.transitions.Tweener;

	public class NavigationView extends View implements IView
	{
		public function NavigationView()
		{
			this.alpha = 0;
		}
		
		public function initialize($properties:Object=null):void
		{
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			Tweener.addTween(this,{alpha:1,transition:"linear",time:1,onComplete:this.introComplete});
		}
		public function outro($properties:Object=null):void
		{
			
		}
		public function clear():void
		{
			
		}
	}
}