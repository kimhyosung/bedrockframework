package com.autumntactics.project.template.view
{
	import com.autumntactics.bedrock.view.View;
	import com.autumntactics.bedrock.view.IView;
	
	import caurina.transitions.Tweener;
	import com.autumntactics.bedrock.dispatcher.BedrockDispatcher;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.manager.ContainerManager;
	import com.autumntactics.project.template.view.NavigationView;
	public class SiteView extends View implements IView
	{
		public function SiteView()
		{
			this.alpha=0;
		}
		public function initialize($properties:Object=null):void
		{
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			var objNavigation:IView = ContainerManager.getContainer("navigation").content as IView;
			objNavigation.initialize();
			objNavigation.intro();
			//trace(objNavigation)
			Tweener.addTween(this,{alpha:1,transition:"linear",time:1,onComplete:this.onIntroTweenComplete});
			//this.introComplete();
		}
		
		public function outro($properties:Object=null):void
		{
			Tweener.addTween(this,{alpha:0,transition:"linear",time:1,onComplete:this.outroComplete});
			//this.outroComplete();
		}
		public function clear():void
		{

		}
		
		private function onIntroTweenComplete():void
		{
			this.introComplete();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_DEFAULT,this));
		}
	}
}