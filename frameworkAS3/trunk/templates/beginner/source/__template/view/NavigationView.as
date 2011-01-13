﻿package __template.view
{
	import com.bedrock.extras.cloner.Cloner;
	import com.bedrock.extras.cloner.ClonerData;
	import com.bedrock.extras.cloner.ClonerEvent;
	import com.bedrock.framework.engine.Bedrock;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.engine.view.BedrockModuleView;
	import com.bedrock.framework.plugin.util.ButtonUtil;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class NavigationView extends BedrockModuleView implements IView
	{
		/*
		Variable Declarations
		*/
		private var _cloner:Cloner;
		/*
		Constructor
	 	*/
		public function NavigationView()
		{
			super();
			this.alpha = 0;
		}
		
		public function initialize($data:Object=null):void
		{
			var clonerData:ClonerData = new ClonerData;
			clonerData.clone = MenuButton;
			clonerData.autoSpacing = true;
			clonerData.direction = ClonerData.HORIZONTAL;
			clonerData.paddingX = 10;
			clonerData.total = Bedrock.api.getIndexedModules().length;
			
			this._cloner = new Cloner;
			this._cloner.addEventListener( ClonerEvent.CREATE, this._onCloneCreate );
			this.addChild( this._cloner );
			this._cloner.x = 5;
			this._cloner.y = 5;
			this._cloner.initialize( clonerData );
			
			this.initializeComplete();
		}
		
		public function intro($data:Object=null):void
		{
			TweenLite.to(this, 1, { alpha:1, onComplete:this.introComplete } );
		}
		
		public function outro($data:Object=null):void
		{
		}
		
		public function clear():void
		{
		}
		/*
		Event Handlers
	 	*/
	 	private function _onCloneCreate( $event:ClonerEvent ):void
		{
			var data:BedrockModuleData = Bedrock.api.getIndexedModules()[ $event.details.index ];
			var childButton:MovieClip = $event.details.child;
			childButton.label.text = data.label;
			childButton.name = data.id;
			ButtonUtil.addListeners( childButton, { down:this._onButtonClick } );
		}
		private function _onButtonClick( $event:MouseEvent ):void
		{
			Bedrock.api.transition( $event.currentTarget.name );
		}
	 	/*
		Accessors
	 	*/
		
	}
}