package
{
	import com.bedrockframework.plugin.view.ViewStack;
	import com.bedrockframework.plugin.data.ViewStackData;

	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TestDocument extends MovieClip
	{
		/*
		Variable Declarations
		*/
		private var _objViewStack:ViewStack;
		
		/*
		Constructor
		*/
		public function TestDocument()
		{
			this.loaderInfo.addEventListener(Event.INIT, this.onBootUp);
		}

		/*
		Basic view functions
	 	*/
		public function initialize():void
		{
			this._objViewStack = new ViewStack();
			this.addChild( this._objViewStack );
			
			var objViewStackData = new ViewStackData();
			objViewStackData.autoQueue = false;
			objViewStackData.addToStack( new Burst() );
			objViewStackData.addToStack( new Cheese() );
			objViewStackData.addToStack( new Sun() );
			objViewStackData.addToStack( new Nothing() );
			
			objViewStackData.autoInitialize = true;
			//objViewStackData.container = this;
			this._objViewStack.initialize(objViewStackData);
			//
			//
			startButton.addEventListener("click", this.onStartClicked);
			stopButton.addEventListener("click", this.onStopClicked);
			modeButton.addEventListener("click", this.onChangeModeClicked );
			nextButton.addEventListener("click", this.onNextClicked);
			previousButton.addEventListener("click", this.onPreviousClicked);
			
			oneButton.addEventListener("click", this.onOneClicked );
			twoButton.addEventListener("click", this.onTwoClicked);
			threeButton.addEventListener("click", this.onThreeClicked);
		}
		
		/*
		Event Handlers
		*/
		final private function onBootUp($event:Event):void
		{
			this.initialize();
		}
		
		function onStartClicked($event)
		{
			this._objViewStack.startTimer( 3 );
		}
		function onStopClicked($event)
		{
			this._objViewStack.stopTimer();
		}
		function onChangeModeClicked ($event)
		{
			this._objViewStack.toggleMode();
		}
		function onNextClicked($event){
			this._objViewStack.selectNext()
		}
		function onPreviousClicked($event){
			this._objViewStack.selectPrevious()
		}
		
		
		function onOneClicked ($event)
		{
			this._objViewStack.selectByIndex( 0 );
		}
		function onTwoClicked($event){
			this._objViewStack.selectByIndex( 1 );
		}
		function onThreeClicked($event){
			this._objViewStack.selectByIndex( 2 );
		}
		
	}
}