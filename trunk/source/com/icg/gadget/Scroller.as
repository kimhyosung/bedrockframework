/**

Scroller

*/
package com.icg.gadget
{
	import com.icg.data.ScrollerData;
	import com.icg.events.ScrollerEvent;
	import com.icg.events.TriggerEvent;
	import com.icg.madagascar.base.DispatcherWidget;
	import com.icg.timer.Trigger;
	import com.icg.util.ButtonUtil;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	public class Scroller extends DispatcherWidget
	{
		/*
		Variable Decarations
		*/
		private var objScrollerTrigger:Trigger;
		private var objManualTrigger:Trigger;

		private var mcContainer:MovieClip;
		private var mcTrack:MovieClip;
		private var mcContent:MovieClip;
		private var mcMask:MovieClip;
		private var mcDrag:MovieClip;

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
			this.objScrollerTrigger.outputSilenced=true;
			this.objScrollerTrigger.addEventListener(TriggerEvent.TRIGGER,this.onScrollerTrigger);
			//
			this.objManualTrigger=new Trigger("Manual");
			this.objManualTrigger.outputSilenced=true;
			this.objScrollerTrigger.addEventListener(TriggerEvent.TRIGGER,this.onManualTrigger);
		}
		/*
		Setup the scroller
		*/
		public function setup($data:ScrollerData)
		{
			var objData:ScrollerData=$data;
			this.mcContainer=objData.trackContainer;
			this.mcTrack=objData.trackBackground;
			this.mcContent=objData.content;
			this.mcMask=objData.mask;
			this.mcDrag=objData.drag;
			this.mcContent.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			//
			this.bolResize=objData.resize;
			this.bolAutoHide=objData.autohide;
			this.bolAutoHide=objData.updateOnDrag;
			this.numIncrement = objData.manualIncrement ;
			this.setDirection(objData.direction);
			this.setAlignment(objData.alignment);
			//
			this.numOriginalPosition=this.getLocation(this.mcContent);
			//
			this.applyDrag(this.mcDrag);
			this.applyJumpActions(this.mcTrack);
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
					this.output("Invalid direction value!","error");
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
			this.mcDrag.stage.addEventListener(MouseEvent.MOUSE_UP, this.stopDragMovement);
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
			this.mcDrag.startDrag(false,objRectangle);
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.START_DRAG,this));
		}
		/*
		Stop the movement interval
		*/
		public function stopDragMovement($event:MouseEvent):void
		{
			this.mcDrag.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stopDragMovement);
			this.objScrollerTrigger.stop();
			this.mcDrag.stopDrag();
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
			if (this.getSize(this.mcContent) < this.getSize(this.mcTrack) && this.bolAutoHide) {
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
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.UPDATE,this,{content:this.mcContent,drag:this.numDragSize}));
		}
		/*
		Calculate 
		*/
		private function calculateMaxValues():void
		{
			this.numContentBottom=Math.round(this.getSize(this.mcContent) - this.getSize(this.mcMask));
		}
		/*
		Calculate stactic drag position
		*/
		private function calcualteStaticDrag():void
		{
			this.numDragBottom=Math.round(this.getSize(this.mcTrack) - this.getSize(this.mcDrag));
			this.numRatio=this.numContentBottom / this.numDragBottom;
		}
		/*
		Calculate resizable drag position
		*/
		private function calcualteResizableDrag():void
		{
			var numTCRatio:Number=this.getSize(this.mcContent) / this.getSize(this.mcTrack);

			this.numDragSize=Math.floor(this.getSize(this.mcTrack) / numTCRatio);

			if (this.numDragSize > this.getSize(this.mcTrack)) {
				this.numDragSize=this.getSize(this.mcTrack);
			}
			this.setSize(this.mcDrag,this.numDragSize);
			this.numDragBottom=Math.round(this.getSize(this.mcTrack) - this.getSize(this.mcDrag));
			this.numRatio=this.numContentBottom / this.numDragBottom;
		}
		private function getLocation($clip:MovieClip):Number
		{
			return $clip[this.strDirectionOrientation];
		}
		private function getSize($clip:MovieClip):Number
		{
			return $clip[this.strSizeOrientation];
		}
		private function setLocation($clip:MovieClip,$value:Number):void
		{
			$clip[this.strDirectionOrientation]=$value;
		}
		private function setSize($clip:MovieClip,$value:Number):void
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
					this.setLocation(this.mcDrag,0);
					break;
				case ScrollerData.BOTTOM :
					this.setLocation(this.mcDrag,this.numDragBottom);
					break;
				case ScrollerData.CENTER :
					var numLocation:Number = (this.getSize(this.mcTrack) /2) - (this.numDragSize /2);
					this.setLocation(this.mcDrag,numLocation);
					break;
			}
			this.positionContent(this.getLocation(this.mcDrag));
		}
		/* 
		Check to see if the mouse is making contact with the mask clip.
		*/
		private function inFocus():Boolean
		{
			return this.mcMask.hitTestPoint(this.root.mouseX,this.root.mouseY);
		}
		/*
		Reset the positioning of the scroll bar
		*/
		public function reset():void
		{
			this.setLocation(this.mcContent,this.numOriginalPosition);
			this.setLocation(this.mcDrag,0);
			this.setSize(this.mcDrag,0);
			//this.dispatchEvent(new ScrollerEvent("onReset", this));
		}
		/*
		Apply button events the the drag button
		*/
		public function applyDrag($clip:MovieClip):void
		{
			ButtonUtil.addListeners($clip,{down:this.startDragMovement,up:this.stopDragMovement});
		}
		private function applyJumpActions($clip:MovieClip):void
		{
			ButtonUtil.addListeners($clip,{up:this.jumpTo},false);
		}
		private function jumpTo($event:MouseEvent)
		{
			this.positionDrag($event.localY);
			this.positionContent(this.getLocation(this.mcDrag));
		}


		//


		/*
		Move the content into position
		*/
		public function positionContent($draglocation:Number):void
		{
			this.setLocation(this.mcContent,- Math.round($draglocation * this.numRatio) + this.numOriginalPosition);
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGE, this));
		}
		/*
		Move the drag button into position
		*/
		public function positionDrag($location:Number):void
		{
			if ($location > 0 && $location < this.numDragBottom) {
				this.setLocation(this.mcDrag,$location);
			} else if ($location < 0) {
				this.setLocation(this.mcDrag,0);
			} else if ($location > this.numDragBottom) {
				this.setLocation(this.mcDrag,this.numDragBottom);
			}
			//this.dispatchEvent(new ScrollerEvent("onDragChange", this));
		}
		public function positionManual($increment:int = 0):void
		{
			var numMovement:int = ($increment != 0) ? $increment : this.numIncrement;
			this.positionDrag(this.getLocation(this.mcDrag) - numMovement);
			this.positionContent(this.getLocation(this.mcDrag));
		}
		/*
		Show/Hide Scroller Functions
		*/
		public function showScroller():void
		{
			this.mcContainer.visible = true;
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.SHOW_SCROLLER, this));
		}
		public function hideScroller():void
		{
			this.mcContainer.visible = false;
			this.dispatchEvent(new ScrollerEvent(ScrollerEvent.HIDE_SCROLLER, this));
		}
		/*
		Event Handlers
		*/
		private function onScrollerTrigger($event:TriggerEvent):void
		{
			this.positionContent(this.getLocation(this.mcDrag));

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