package __template.view
{
	import com.bedrock.framework.Bedrock;
	import com.bedrock.framework.engine.view.BedrockModuleView;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.text.TextField;
	import flash.sensors.Accelerometer;
	import flash.events.AccelerometerEvent;
	
	public class Module2View extends BedrockModuleView implements IView
	{
		/*
		Variable Declarations
		*/
		public var label:TextField;
		public var output:TextField;
		private var _accelerometer:Accelerometer;
		/*
		Constructor
		*/
		public function Module2View()
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
			
			this._accelerometer = new Accelerometer();
			this._accelerometer.addEventListener( AccelerometerEvent.UPDATE, this._onAccelerometerUpdate );
			
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
		private function _onAccelerometerUpdate( $event:AccelerometerEvent ):void
		{
			var feedback:String = "Feedback : \n";
			feedback += "X : " + $event.accelerationX.toString() + "\n";
            feedback += "Y : " + $event.accelerationY.toString() + "\n";
            feedback += "Z : " + $event.accelerationZ.toString() + "\n";
			this.output.text = feedback;
		}
	}
}