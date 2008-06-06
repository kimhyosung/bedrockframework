﻿/**

Scroller

*/
package com.autumntactics.gadget
{
	import com.autumntactics.data.ScrollerData;
	import com.autumntactics.events.ScrollerEvent;
	import com.autumntactics.events.TriggerEvent;
	import com.autumntactics.bedrock.base.DispatcherWidget;
	import com.autumntactics.timer.Trigger;
	import com.autumntactics.util.ButtonUtil;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	
	public class Scroller extends DispatcherWidget
	{
		/*
		Variable Decarations
		*/
		private var objScrollerTrigger:Trigger;
		private var objManualTrigger:Trigger;

		private var sprContainer:Sprite;
		private var sprTrack:Sprite;
		private var sprContent:Sprite;
		private var sprMask:Sprite;
		private var sprDrag:Sprite;

		private var strDirection:String;
		private var strAlignment:String;
		private var strSizeOrientation:String;
		private var strDirectionOrientation:String;

		private var numRatio:Number;
		private var numDragSize:Number;
		private var numIncrement:Number;
		private var numOriginalPosition:Number;
		private var numDragBottom:Number;
		private var numContentBottom:Number;

		private var bolResize:Boolean;
		private var bolAutoHide:Boolean;
		private var bolUpdateOnDrag:Boolean;
		/*
		Constructor
		*/
		public function Scroller()
		{
			this.objScrollerTrigger=new Trigger("Scroller");
			this.objScrollerTrigger.silenceLogging=true;
			this.objScrollerTrigger.addEventListener(TriggerEvent.TRIGGER,this.onScrollerTrigger);
			//
			this.objManualTrigger=new Trigger("Manual");
			this.objManualTrigger.silenceLogging=true;
			this.objScrollerTrigger.addEventListener(TriggerEvent.TRIGGER,this.onManualTrigger);
		}
		/*
		Setup the scroller
		*/
		public function setup($data:ScrollerData)
		{
			var objData:ScrollerData=$data;
			this.sprContainer=objData.trackContainer;
			this.sprTrack=objData.trackBackground;
			this.sprContent=objData.content;
			this.sprMask=objData.mask;
			this.sprDrag=objData.drag;
			this.sprContent.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			//
			this.bolResize=objData.resize;
			this.bolAutoHide=objData.autohide;
			this.bolAutoHide=objData.updateOnDrag;
			this.numIncrement = objData.manualIncrement ;
			this.setDirection(objData.direction);
			this.setAlignment(objData.alignment);
			//
			this.numOriginalPosition=this.getLocation(this.sprContent);
			//
			this.applyDrag(this.sprDrag);
			this.applyJumpActions(this.sprTrack);
			this.update();
		}
		/*
		Set direction
		*/
		public function setDirection($value:String):void
		{
			this.strDirection=$value.toLowerCase();
			switch (this.strDirection) {
				case ScrollerData.HORIZONTAL :
					this.strSizeOrientation="width";
					this.strDirectionOrientation="x";
					break;
				case ScrollerData.VERTICAL :
					this.strSizeOrientation="height";
					this.strDirectionOrientation="y";
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
			this.strAlignment=$value.toLowerCase();
		}
		/*
		Start the movement interval
		*/
		public function startDragMovement($event:MouseEvent):void
		{
			this.sprDrag.stage.addEventListener(MouseEvent.MOUSE_UP, this.stopDragMovement);
			if (this.bolUpdateOnDrag) {
				this.update();
			}
			this.objScrollerTrigger.start(0.001);
			var objRectangle:Rectangle;
			switch (this.strDirection) {
				case ScrollerData.HORIZONTAL :
					objRectangle=new Rectangle(0,0,this.numDragBottom,0);
					break;
				case ScrollerData.VERTICAL :
					objRectangle=new Rectangle(0,0,0,this.numDragBottom);
					break;
			}
			this.sprDrag.startDrag(false,objRectangle);
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.START_DRAG,this));
		}
		/*
		Stop the movement interval
		*/
		public function stopDragMovement($event:MouseEvent):void
		{
			this.sprDrag.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stopDragMovement);
			this.objScrollerTrigger.stop();
			this.sprDrag.stopDrag();
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.STOP_DRAG,this));
		}
		/*
		Start manual movement
		*/

		public function startManualMovement($increment:Number):void
		{
			this.numIncrement=$increment;
			this.objManualTrigger.start(0.01);
		}

		/*
		Stop manual movement
		*/
		public function stopManualMovement():void
		{
			this.objManualTrigger.stop();
		}
		/*
		Update the positioning of the scroll bar
		*/
		public function update():void
		{
			if (this.getSize(this.sprContent) < this.getSize(this.sprTrack) && this.bolAutoHide) {
				this.hideScroller();
			} else {
				this.showScroller();
				//
				this.calculateMaxValues();
				//
				if (this.bolResize) {
					this.calcualteResizableDrag();
				} else {
					this.calcualteStaticDrag();
				}
				this.calculateAlignment();
			}
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.UPDATE,this,{content:this.sprContent,drag:this.numDragSize}));
		}
		/*
		Calculate 
		*/
		private function calculateMaxValues():void
		{
			this.numContentBottom=Math.round(this.getSize(this.sprContent) - this.getSize(this.sprMask));
		}
		/*
		Calculate stactic drag position
		*/
		private function calcualteStaticDrag():void
		{
			this.numDragBottom=Math.round(this.getSize(this.sprTrack) - this.getSize(this.sprDrag));
			this.numRatio=this.numContentBottom / this.numDragBottom;
		}
		/*
		Calculate resizable drag position
		*/
		private function calcualteResizableDrag():void
		{
			var numTCRatio:Number=this.getSize(this.sprContent) / this.getSize(this.sprTrack);

			this.numDragSize=Math.floor(this.getSize(this.sprTrack) / numTCRatio);

			if (this.numDragSize > this.getSize(this.sprTrack)) {
				this.numDragSize=this.getSize(this.sprTrack);
			}
			this.setSize(this.sprDrag,this.numDragSize);
			this.numDragBottom=Math.round(this.getSize(this.sprTrack) - this.getSize(this.sprDrag));
			this.numRatio=this.numContentBottom / this.numDragBottom;
		}
		private function getLocation($clip:Sprite):Number
		{
			return $clip[this.strDirectionOrientation];
		}
		private function getSize($clip:Sprite):Number
		{
			return $clip[this.strSizeOrientation];
		}
		private function setLocation($clip:Sprite,$value:Number):void
		{
			$clip[this.strDirectionOrientation]=$value;
		}
		private function setSize($clip:Sprite,$value:Number):void
		{
			$clip[this.strSizeOrientation]=$value;
		}


		/*
		Calculate scroll alignment
		*/
		private function calculateAlignment():void
		{
			switch (this.strAlignment) {
				case ScrollerData.TOP :
					this.setLocation(this.sprDrag,0);
					break;
				case ScrollerData.BOTTOM :
					this.setLocation(this.sprDrag,this.numDragBottom);
					break;
				case ScrollerData.CENTER :
					var numLocation:Number = (this.getSize(this.sprTrack) /2) - (this.numDragSize /2);
					this.setLocation(this.sprDrag,numLocation);
					break;
			}
			this.positionContent(this.getLocation(this.sprDrag));
		}
		/* 
		Check to see if the mouse is making contact with the mask clip.
		*/
		private function inFocus():Boolean
		{
			return this.sprMask.hitTestPoint(this.root.mouseX,this.root.mouseY);
		}
		/*
		Reset the positioning of the scroll bar
		*/
		public function reset():void
		{
			this.setLocation(this.sprContent,this.numOriginalPosition);
			this.setLocation(this.sprDrag,0);
			this.setSize(this.sprDrag,0);
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
			ButtonUtil.addListeners($clip,{up:this.jumpTo},false);
		}
		private function jumpTo($event:MouseEvent)
		{
			this.positionDrag($event.localY);
			this.positionContent(this.getLocation(this.sprDrag));
		}


		//


		/*
		Move the content into position
		*/
		public function positionContent($draglocation:Number):void
		{
			this.setLocation(this.sprContent,- Math.round($draglocation * this.numRatio) + this.numOriginalPosition);
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGE, this));
		}
		/*
		Move the drag button into position
		*/
		public function positionDrag($location:Number):void
		{
			if ($location > 0 && $location < this.numDragBottom) {
				this.setLocation(this.sprDrag,$location);
			} else if ($location < 0) {
				this.setLocation(this.sprDrag,0);
			} else if ($location > this.numDragBottom) {
				this.setLocation(this.sprDrag,this.numDragBottom);
			}
			//this.dispatchEvent(new ScrollerEvent("onDragChange", this));
		}
		public function positionManual($increment:int = 0):void
		{
			var numMovement:int = ($increment != 0) ? $increment : this.numIncrement;
			this.positionDrag(this.getLocation(this.sprDrag) - numMovement);
			this.positionContent(this.getLocation(this.sprDrag));
		}
		/*
		Show/Hide Scroller Functions
		*/
		public function showScroller():void
		{
			this.sprContainer.visible = true;
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.SHOW_SCROLLER, this));
		}
		public function hideScroller():void
		{
			this.sprContainer.visible = false;
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.HIDE_SCROLLER, this));
		}
		/*
		Event Handlers
		*/
		private function onScrollerTrigger($event:TriggerEvent):void
		{
			this.positionContent(this.getLocation(this.sprDrag));

		}
		private function onManualTrigger($event:TriggerEvent):void
		{
			this.positionManual(this.numIncrement);
		}
		private function onMouseWheel($delta:Number):void
		{
			if (this.inFocus()) {
				this.positionManual($delta);
			}
		}
	}
}