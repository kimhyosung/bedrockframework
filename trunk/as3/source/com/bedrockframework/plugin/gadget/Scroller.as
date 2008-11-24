/**

Scroller

*/
package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.plugin.data.ScrollerData;
	import com.bedrockframework.plugin.event.ScrollerEvent;
	import com.bedrockframework.plugin.event.TriggerEvent;
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.timer.IntervalTrigger;
	import com.bedrockframework.plugin.util.ButtonUtil;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	
	public class Scroller extends DispatcherWidget
	{
		/*
		Variable Decarations
		*/
		private var _objData:ScrollerData;
		private var _objScrollerTrigger:IntervalTrigger;
		private var _objManualTrigger:IntervalTrigger;

		private var _strDirection:String;
		private var _strAlignment:String;
		private var _strSizeOrientation:String;
		private var _strDirectionOrientation:String;

		private var _numRatio:Number;
		private var _numDragSize:Number;
		private var _numIncrement:Number;
		private var _numOriginalPosition:Number;
		private var _numDragBottom:Number;
		private var _numContentBottom:Number;
		/*
		Constructor
		*/
		public function Scroller()
		{
			this.createTriggers();
		}
		private function createTriggers():void
		{
			this._objScrollerTrigger=new IntervalTrigger;
			this._objScrollerTrigger.silenceLogging=true;
			this._objScrollerTrigger.addEventListener(TriggerEvent.TRIGGER,this.onScrollerTrigger);
			//
			this._objManualTrigger=new IntervalTrigger;
			this._objManualTrigger.silenceLogging=true;
			this._objScrollerTrigger.addEventListener(TriggerEvent.TRIGGER,this.onManualTrigger);
		}
		/*
		Setup the scroller
		*/
		public function setup($data:ScrollerData):void
		{
			this._objData = $data;
			this._objData.content.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			//
			this._objData.content.graphics.drawRect(0,0,1,1);
			this._objData.content.graphics.endFill();
			//
			this._numIncrement = this._objData.manualIncrement ;
			this.setDirection(this._objData.direction);
			this.setAlignment(this._objData.alignment);
			//
			this._numOriginalPosition=this.getLocation(this._objData.content);
			//
			this._objData.content.mask = this._objData.mask;
			//
			this.applyDrag(this._objData.drag);
			if (this._objData.enableJumpActions) {
				this.applyJumpActions(this._objData.trackBackground);	
			}			
			this.update();
		}
		/*
		Set direction
		*/
		public function setDirection($value:String):void
		{
			this._strDirection=$value.toLowerCase();
			switch (this._strDirection) {
				case ScrollerData.HORIZONTAL :
					this._strSizeOrientation="width";
					this._strDirectionOrientation="x";
					break;
				case ScrollerData.VERTICAL :
					this._strSizeOrientation="height";
					this._strDirectionOrientation="y";
					break;
				default :
					this.error("Invalid direction value!");
					break;
			}
		}
		/*
		Set alignment
		*/
		public function setAlignment($value:String):void
		{
			this._strAlignment=$value.toLowerCase();
		}
		/*
		Start the movement interval
		*/
		public function startDragMovement($event:MouseEvent):void
		{
			this._objData.drag.stage.addEventListener(MouseEvent.MOUSE_UP, this.stopDragMovement);
			if (this._objData.updateOnDrag) {
				this.update();
			}
			this._objScrollerTrigger.start(0.001);
			var objRectangle:Rectangle;
			switch (this._strDirection) {
				case ScrollerData.HORIZONTAL :
					objRectangle=new Rectangle(0,0,this._numDragBottom,0);
					break;
				case ScrollerData.VERTICAL :
					objRectangle=new Rectangle(0,0,0,this._numDragBottom);
					break;
			}
			this._objData.drag.startDrag(false,objRectangle);
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.START_DRAG,this));
		}
		/*
		Stop the movement interval
		*/
		public function stopDragMovement($event:MouseEvent):void
		{
			this._objData.drag.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stopDragMovement);
			this._objScrollerTrigger.stop();
			this._objData.drag.stopDrag();
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.STOP_DRAG,this));
		}
		/*
		Start manual movement
		*/

		public function startManualMovement($increment:Number):void
		{
			this._numIncrement=$increment;
			this._objManualTrigger.start(0.01);
		}

		/*
		Stop manual movement
		*/
		public function stopManualMovement():void
		{
			this._objManualTrigger.stop();
		}
		/*
		Update the positioning of the scroll bar
		*/
		public function update():void
		{
			if (this.getSize(this._objData.content) < this.getSize(this._objData.trackBackground) && this._objData.autoHide) {
				this.hideScroller();
			} else {
				this.showScroller();
				//
				this.calculateMaxValues();
				//
				if (this._objData.resize) {
					this.calcualteResizableDrag();
				} else {
					this.calcualteStaticDrag();
				}
				this.calculateAlignment();
			}
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.UPDATE,this,{content:this._objData.content,drag:this._numDragSize}));
		}
		/*
		Calculate 
		*/
		private function calculateMaxValues():void
		{
			this._numContentBottom=Math.round(this.getSize(this._objData.content) - this.getSize(this._objData.mask));
		}
		/*
		Calculate stactic drag position
		*/
		private function calcualteStaticDrag():void
		{
			this._numDragBottom=Math.round(this.getSize(this._objData.trackBackground) - this.getSize(this._objData.drag));
			this._numRatio=this._numContentBottom / this._numDragBottom;
		}
		/*
		Calculate resizable drag position
		*/
		private function calcualteResizableDrag():void
		{
			var numTCRatio:Number=this.getSize(this._objData.content) / this.getSize(this._objData.trackBackground);

			this._numDragSize=Math.floor(this.getSize(this._objData.trackBackground) / numTCRatio);

			if (this._numDragSize > this.getSize(this._objData.trackBackground)) {
				this._numDragSize=this.getSize(this._objData.trackBackground);
			}
			this.setSize(this._objData.drag,this._numDragSize);
			this._numDragBottom=Math.round(this.getSize(this._objData.trackBackground) - this.getSize(this._objData.drag));
			this._numRatio=this._numContentBottom / this._numDragBottom;
		}
		private function getLocation($clip:Sprite):Number
		{
			return $clip[this._strDirectionOrientation];
		}
		private function getSize($clip:Sprite):Number
		{
			return $clip[this._strSizeOrientation];
		}
		private function setLocation($clip:Sprite,$value:Number):void
		{
			$clip[this._strDirectionOrientation]=$value;
		}
		private function setSize($clip:Sprite,$value:Number):void
		{
			$clip[this._strSizeOrientation]=$value;
		}


		/*
		Calculate scroll alignment
		*/
		private function calculateAlignment():void
		{
			switch (this._strAlignment) {
				case ScrollerData.TOP :
					this.setLocation(this._objData.drag,0);
					break;
				case ScrollerData.BOTTOM :
					this.setLocation(this._objData.drag,this._numDragBottom);
					break;
				case ScrollerData.CENTER :
					var numLocation:Number = (this.getSize(this._objData.trackBackground) /2) - (this._numDragSize /2);
					this.setLocation(this._objData.drag,numLocation);
					break;
			}
			this.positionContent(this.getLocation(this._objData.drag));
		}
		/* 
		Check to see if the mouse is making contact with the mask clip.
		*/
		private function inFocus():Boolean
		{
			return this._objData.mask.hitTestPoint(this._objData.trackContainer.stage.mouseX,this._objData.trackContainer.stage.mouseY);
		}
		/*
		Reset the positioning of the scroll bar
		*/
		public function reset():void
		{
			this.setLocation(this._objData.content,this._numOriginalPosition);
			this.setLocation(this._objData.drag,0);
			this.setSize(this._objData.drag,0);
			//this.dispatchEvent(new ScrollerEvent("onReset", this));
		}
		/*
		Apply button events the the drag button
		*/
		public function applyDrag($clip:Sprite):void
		{
			ButtonUtil.addListeners($clip,{down:this.startDragMovement,up:this.stopDragMovement});
		}
		private function applyJumpActions($clip:Sprite):void
		{
			ButtonUtil.addListeners($clip,{up:this.onJump},false);
		}
		
		/*
		Move the content into position
		*/
		public function positionContent($draglocation:Number):void
		{
			this.setLocation(this._objData.content,- Math.round($draglocation * this._numRatio) + this._numOriginalPosition);
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGE, this));
		}
		/*
		Move the drag button into position
		*/
		public function positionDrag($location:Number):void
		{
			if ($location > 0 && $location < this._numDragBottom) {
				this.setLocation(this._objData.drag,$location);
			} else if ($location < 0) {
				this.setLocation(this._objData.drag,0);
			} else if ($location > this._numDragBottom) {
				this.setLocation(this._objData.drag,this._numDragBottom);
			}
			//this.dispatchEvent(new ScrollerEvent("onDragChange", this));
		}
		public function positionManual($increment:int = 0):void
		{
			var numMovement:int = ($increment != 0) ? $increment : this._numIncrement;
			this.positionDrag(this.getLocation(this._objData.drag) - numMovement);
			this.positionContent(this.getLocation(this._objData.drag));
		}
		/*
		Show/Hide Scroller Functions
		*/
		public function showScroller():void
		{
			this._objData.trackContainer.visible = true;
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.SHOW_SCROLLER, this));
		}
		public function hideScroller():void
		{
			this._objData.trackContainer.visible = false;
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.HIDE_SCROLLER, this));
		}
		/*
		Event Handlers
		*/
		private function onScrollerTrigger($event:TriggerEvent):void
		{
			this.positionContent(this.getLocation(this._objData.drag));
		}
		private function onManualTrigger($event:TriggerEvent):void
		{
			this.positionManual(this._numIncrement);
		}
		private function onMouseWheel($delta:Number):void
		{
			if (this.inFocus()) {
				this.positionManual($delta);
			}
		}
		private function onJump($event:MouseEvent):void
		{
			this.positionDrag($event.localY);
			this.positionContent(this.getLocation(this._objData.drag));
		}
	}
}