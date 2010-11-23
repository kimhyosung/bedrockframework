package __template.view
{
	import com.bedrock.extras.cloner.Cloner;
	import com.bedrock.extras.cloner.ClonerData;
	import com.bedrock.extras.cloner.ClonerEvent;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.event.BedrockEvent;
	import com.bedrock.framework.engine.view.BedrockContentView;
	import com.bedrock.framework.plugin.util.ButtonUtil;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class NavigationView extends BedrockContentView implements IView
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
			var data:ClonerData = new ClonerData;
			data.clone = MenuButton;
			data.autoSpacing = true;
			data.direction = ClonerData.HORIZONTAL;
			data.paddingX = 10;
			data.total = BedrockEngine.contentManager.filterContent( "indexed", true ).length;
			
			this._cloner = new Cloner;
			this._cloner.addEventListener( ClonerEvent.CREATE, this._onCloneCreate );
			this.addChild( this._cloner );
			this._cloner.x = 5;
			this._cloner.y = 5;
			this._cloner.initialize( data );
			
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
			var data:Object = BedrockEngine.contentManager.filterContent( "indexed", true )[ $event.details.index ];
			var childButton:MovieClip = $event.details.child;
			childButton.label.text = data.label;
			childButton.name = data.id;
			ButtonUtil.addListeners( childButton, { down:this._onButtonClick } );
		}
		private function _onButtonClick( $event:MouseEvent ):void
		{
			BedrockDispatcher.dispatchEvent( new BedrockEvent( BedrockEvent.TRANSITION, this, { id:$event.currentTarget.name } ) );
		}
	 	/*
		Accessors
	 	*/
		
	}
}