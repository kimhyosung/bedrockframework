package com.yourdomain.project.template.view
{
	import caurina.transitions.Tweener;
	
	import com.bedrockframework.engine.view.IView;
	import com.bedrockframework.engine.view.View;

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