package com.icg.madagascar.base
{
	import com.icg.madagascar.output.OutputManager;
	import com.icg.util.ClassUtil;
	import flash.display.Sprite;
	import flash.events.Event;

	public class SpriteWidget extends Sprite
	{
		private var strClassName:String;
		private var bolOutputSilenced:Boolean;
		private var bolOutputEvents:Boolean;

		public function SpriteWidget($outputConstruction:Boolean = true)
		{
			super();
			this.bolOutputSilenced=false;
			this.strClassName=ClassUtil.getDisplayClassName(this);
			if ($outputConstruction) {
				this.output("Constructed","constructor");
			}
		}
		/*
		Overrides adding additional functionality
		*/
		override public function dispatchEvent($event:Event):Boolean
		{
			if (this.bolOutputEvents) {
				this.output($event);
			}
			return super.dispatchEvent($event);
		}
		override public function addEventListener($type:String,$listener:Function,$capture:Boolean=false,$priority:int=0,$weak:Boolean=true):void
		{
			super.addEventListener($type,$listener,$capture,$priority,$weak);
		}
		/*
		Output Function
		*/
		public function output($trace:*,$category:*=0)
		{
			if (!this.bolOutputSilenced) {
				OutputManager.send($trace,$category,this);
			}
		}
		/*
		Output Silenced
		*/
		public function set outputSilenced($status:Boolean):void
		{
			this.bolOutputSilenced=$status;
		}
		public function get outputSilenced():Boolean
		{
			return this.bolOutputSilenced;
		}
		/*
		Output Events
		*/
		public function set outputEvents($status:Boolean):void
		{
			this.bolOutputEvents=$status;
		}
		public function get outputEvents():Boolean
		{
			return this.bolOutputEvents;
		}
		/*
		String Identifier
		*/
		override public function toString():String
		{
			return this.strClassName;
		}
	}
}