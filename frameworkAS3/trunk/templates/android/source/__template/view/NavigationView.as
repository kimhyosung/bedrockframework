package __template.view
{
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.engine.view.BedrockModuleView;
	import com.bedrock.framework.plugin.util.ButtonUtil;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;

	public class NavigationView extends BedrockModuleView implements IView
	{
		/*
		Variable Declarations
		*/
		private var _itemCount:uint;
		private var _itemSpacing:uint;
		/*
		Constructor
	 	*/
		public function NavigationView()
		{
			super();
			this._itemCount = 0;
			this._itemSpacing = 160;
			this.alpha = 0;
		}
		
		public function initialize($data:Object=null):void
		{
			this._createMenu();
			this.initializeComplete();
		}
		
		public function intro($data:Object=null):void
		{
			TweenLite.to(this, 1, { alpha:1, onComplete:this.introComplete } );
		}
		
		public function outro($data:Object=null):void
		{
			this.outroComplete();
		}
		
		public function clear():void
		{
			this.clearComplete();
		}
		
		/*
		CreateMenu
	 	*/
	 	private function _createMenu():void
		{
			var menuItem:MenuButton;
			var data:BedrockModuleData;
			var modules:Array = Bedrock.api.getIndexedModules();
			var count:uint = modules.length;
			for ( var i:uint; i < count; i++ ) {
				data = modules[ i ];
				menuItem = new MenuButton();
				menuItem.label.text = data.label;
				menuItem.name = data.id;
				menuItem.x = this._itemSpacing * i;
				ButtonUtil.addListeners( menuItem, { down:this._onButtonClick } );
				this.addChild( menuItem );
			}
		}
		/*
		Event Handlers
	 	*/
		private function _onButtonClick( $event:MouseEvent ):void
		{
			Bedrock.api.transition( $event.currentTarget.name );
		}
	 	/*
		Accessors
	 	*/
		
	}
}