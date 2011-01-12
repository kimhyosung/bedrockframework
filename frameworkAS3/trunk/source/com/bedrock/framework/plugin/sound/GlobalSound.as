package com.bedrock.framework.plugin.sound
{
	/**
	* Manages the global sound within the flash application.
	*
	* @author Alex Toledo
	* @version 1.0.0
	* @created Sat Apr 3 2008 19:16:40 GMT-0400 (EDT)
	*/
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	public class GlobalSound
	{
		/*
		Variable Declarations
		*/
		private var _soundTransform:SoundTransform;
		private var _muted:Boolean;
		private var _volume:Number;
		/*
		Constructor
		*/
		public function GlobalSound()
		{
			this._soundTransform = new SoundTransform( 1, 0 );
		}
		
		public function mute():void
		{
			this._volume = this._soundTransform.volume;
			this._soundTransform.volume = 0;
			this._muted = true;
			
			this._applyTransform();
		}
		public function unmute():void
		{
			this._soundTransform.volume = this._volume;
			this._muted = false;

			this._applyTransform();
		}
		public function toggleMute():Boolean
		{
			if ( this._muted ) {
				this.unmute();
			} else {
				this.mute();
			}
			return this._muted;
		}
		
		private function _applyTransform():void
		{
			SoundMixer.soundTransform = this._soundTransform;
		}

		public function get isMuted():Boolean
		{
			return this._muted;
		}
	}
}