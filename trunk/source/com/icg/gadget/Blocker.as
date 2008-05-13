package com.icg.gadget
{
	import flash.display.Stage;
	import com.icg.madagascar.base.SpriteWidget;
	import com.icg.events.BlockerEvent;
	import flash.events.MouseEvent;
	import com.icg.util.ButtonUtil;
	import com.icg.storage.SimpleMap;
	/*
	Class Declarations
	*/
	public class Blocker extends SpriteWidget
	{
		private static  var OBJ_REPLACEMENTS:SimpleMap;
		/*
		Variable Declarations
		*/
		private var bolActive:Boolean;
		/*
		Constructor
		*/
		public function Blocker($alpha:Number=0)
		{
			Blocker.setupReplacements();
			this.alpha=$alpha;
			this.bolActive=false;
		}
		private static function setupReplacements():void
		{
			if (! OBJ_REPLACEMENTS) {
				var arrEvents:Array=new Array("MOUSE_DOWN","MOUSE_UP","MOUSE_OVER","MOUSE_OUT");
				Blocker.OBJ_REPLACEMENTS=new SimpleMap  ;
				//
				var numLength:Number=arrEvents.length;
				for (var i:Number=0; i < numLength; i++) {
					Blocker.OBJ_REPLACEMENTS.set(MouseEvent[arrEvents[i]],BlockerEvent[arrEvents[i]]);
				}
			}
		}
		public function show():void
		{
			if (! this.active) {
				output("Show");
				this.bolActive=true;
				this.stage.focus = this;
				this.drawBlocker();
				this.dispatchEvent(new BlockerEvent(BlockerEvent.SHOW,this));
			}
		}
		public function hide():void
		{
			output("Hide");
			this.clearBlocker();
			this.stage.focus = null;
			this.bolActive=false;
			this.dispatchEvent(new BlockerEvent(BlockerEvent.HIDE,this));
		}
		/*
		Draw the blocker
		*/
		public function drawBlocker():void
		{
			if (this.stage) {
				this.graphics.moveTo(0,0);
				this.graphics.beginFill(0xFF00FF);
				this.graphics.lineTo(this.stage.stageWidth,0);
				this.graphics.lineTo(this.stage.stageWidth,this.stage.stageHeight);
				this.graphics.lineTo(0,this.stage.stageHeight);
				this.graphics.endFill();
				//
				ButtonUtil.addListeners(this,{down:this.mouseHandler,up:this.mouseHandler,over:this.mouseHandler,out:this.mouseHandler},false);
				//
			} else {
				output("Blocker must be added to stage before it can be shown!","error");
			}
		}
		/*
		Mouse Handlers
		*/
		private function mouseHandler($event:MouseEvent):void
		{
			this.dispatchEvent(new BlockerEvent(Blocker.OBJ_REPLACEMENTS.get($event.type),this));
		}
		public function clearBlocker()
		{
			this.graphics.clear();
			ButtonUtil.removeListeners(this,{down:this.mouseHandler,up:this.mouseHandler,over:this.mouseHandler,out:this.mouseHandler},false);
		}
		public function get active():Boolean
		{
			return this.bolActive;
		}
	}
}