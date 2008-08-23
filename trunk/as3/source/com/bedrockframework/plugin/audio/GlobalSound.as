package com.bedrockframework.plugin.audio
{
	/**
	* Manages the global sound within the flash application.
	*
	* @author Alex Toledo
	* @version 1.0.0
	* @created Sat Apr 3 2008 19:16:40 GMT-0400 (EDT)
	*/
	import com.bedrockframework.core.base.StandardWidget;
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	public class GlobalSound extends StandardWidget
	{
		/*
		Variable Declarations
		*/
		private var _objSoundTransform:SoundTransform;
		private var _numVolume:Number;
		/*
		Constructor
		*/
		public function GlobalSound()
		{
			this._numVolume = 1;
			this._objSoundTransform = new SoundTransform(this._numVolume, 0);
		}
		
		public function mute():void
		{
			this._numVolume = this._objSoundTransform.volume;
			this._objSoundTransform.volume = 0;
			SoundMixer.soundTransform = this._objSoundTransform;
		}
		public function unmute():void
		{
			this._objSoundTransform.volume = this._numVolume;
			SoundMixer.soundTransform = this._objSoundTransform;
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
		
		
		/**
		* Change the global sound volume of the application.
		* @param value The volume, ranging from 0 (silent) to 1 (full volume). 
	 	*/
		public function set volume($value:Number):void
		{
			this._objSoundTransform.volume = $value;
			SoundMixer.soundTransform = this._objSoundTransform;
		}
		
		public function get volume():Number
		{
			return this._objSoundTransform.volume;
		}
		/**
		* Change the global sound panning of the application.
		* @param value The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right). A value of 0 represents no panning (center). 
	 	*/
		 
		
		public function set pan($value:Number):void
		{
			this._objSoundTransform.pan =$value;
			SoundMixer.soundTransform = this._objSoundTransform;
		}
		
		public function get pan():Number
		{
			return this._objSoundTransform.pan;
		}
	}
}