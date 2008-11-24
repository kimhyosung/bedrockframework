package com.bedrockframework.plugin.audio
{
	import com.bedrockframework.core.base.BasicWidget;
	
	import flash.media.SoundTransform;

	public class TransformBoard extends BasicWidget
	{
		/*
		Variable Declarations
		*/
		private var _numVolume:Number;
		private var _objTarget:*;
		private var _objSoundTransform:SoundTransform;
		/*
		Constructor
		*/
		public function TransformBoard($target:* = null, $volume:Number = 1, $panning:Number =0)
		{
			this._numVolume = 1;
			this.target = $target || {};
			this._objSoundTransform = new SoundTransform($volume, $panning);
			this.applyTransform();
		}
		private function applyTransform():void
		{
			this._objTarget.soundTransform = this._objSoundTransform;
		}
		/*
		Mute Functions
		*/
		public function mute():void
		{
			this._numVolume = this._objSoundTransform.volume;
			this._objSoundTransform.volume = 0;
			this.applyTransform();
		}
		public function unmute():void
		{
			this._objSoundTransform.volume = this._numVolume;
			this.applyTransform();
		}
		public function toggleMute():Boolean
		{
			if (this.volume != 0) {
				this.mute();
				return true;
			} else {
				this.unmute();
				return false;
			}
		}
		/*
		Property Definitions
	 	*/
		/**
		* Change the global sound volume of the application.
		* @param value The volume, ranging from 0 (silent) to 1 (full volume). 
	 	*/
		public function set volume($value:Number):void
		{
			this._objSoundTransform.volume = $value;
			this.applyTransform();
		}
		
		public function get volume():Number
		{
			return this._objSoundTransform.volume;
		}
		/**
		* Change the global sound panning of the application.
		* @param value The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right). A value of 0 represents no panning (center). 
	 	*/
		public function set panning($value:Number):void
		{
			this._objSoundTransform.pan =$value;
			this.applyTransform();
		}
		
		public function get panning():Number
		{
			return this._objSoundTransform.pan;
		}
		
		public function set target($target:*):void
		{
			this._objTarget = $target;
			this.applyTransform();
		}
		public function get target():*
		{
			return this._objTarget;
		}
		
		public function get transform():SoundTransform
		{
			return this._objSoundTransform;
		}
	}
}