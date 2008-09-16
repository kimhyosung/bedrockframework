package com.yourdomain.project.template.view
{
	import caurina.transitions.Tweener;
	
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.ContainerManager;
	import com.bedrockframework.engine.view.BedrockView;
	import com.bedrockframework.plugin.view.IView;
	
	public class SiteView extends BedrockView implements IView
	{
		/*
		Variable Declarations
		*/
		/*
		Constructor
	 	*/
		public function SiteView()
		{
			this.alpha=0;
		}
		/*
		Basic view functions
	 	*/
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
		/*
		Event Handlers
		*/
		private function onIntroTweenComplete():void
		{
			this.introComplete();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_DEFAULT,this));
		}
	}
}