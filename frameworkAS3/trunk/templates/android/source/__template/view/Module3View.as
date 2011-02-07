package __template.view
{
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.engine.view.BedrockModuleView;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	import flash.events.GesturePhase;
	
	public class Module3View extends BedrockModuleView implements IView
	{
		/*
		Variable Declarations
		*/
		public var label:TextField;
		public var output:TextField;
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
			this.label.text = this.details.label;
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			this.addEventListener(TransformGestureEvent.GESTURE_PAN, this._onGestureEvent );
			this.addEventListener(TransformGestureEvent.GESTURE_ROTATE, this._onGestureEvent );
			this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, this._onGestureEvent );
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, this._onGestureEvent );
			
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
		private function _onGestureEvent( $event:TransformGestureEvent ):void
		{
			var feedback:String = new String;
			if ( $event.phase==GesturePhase.BEGIN) { 
				feedback += "Begin : \n"; 
				
			} 
			if ( $event.phase==GesturePhase.UPDATE) { 
				feedback += "Update : \n"; 
			} 
			if ( $event.phase==GesturePhase.END) { 
				feedback += "End : "; 
			} 
			feedback += "\noffsetX : " + $event.offsetX;
			feedback += "\noffsetY : " + $event.offsetY;
			feedback += "\nscaleX : " + $event.scaleX;
			feedback += "\nscaleY : " + $event.scaleY;
			feedback += "\nrotation : " + $event.rotation;
			
			this.output.text = feedback;
		}
	}
}