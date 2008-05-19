package com.autumntactics.audio
{
	import com.autumntactics.bedrock.base.DispatcherWidget;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	public class GlobalVolume extends DispatcherWidget
	{
		/*
		Variable Declarations
		*/
		private var numVolume:Number;
		private var objTransform:SoundTransform;
		/*
		Constructor
		*/
		public function GlobalVolume()
		{
			this.numVolume = 1;
			this.objTransform = new SoundTransform(1, 0);
			
		}
		
		private function setVolume($volume:Number):void
		{
			this.numVolume = $volume;
			this.objTransform.volume = this.numVolume;
			SoundMixer.soundTransform = this.objTransform;
		}
		private function getVolume():Number
		{
			return this.objTransform.volume;
		}
		
		
		
		
		public function mute():void
		{
			this.objTransform.volume = 0;
			SoundMixer.soundTransform = this.objTransform;
		}
		public function unmute():void
		{
			this.setVolume(this.numVolume);
		}
		public function toggleMute():Boolean
		{
			if (this.getVolume() != 0) {
				this.mute();
				return true;
			} else {
				this.unmute();
				return false;
			}
		}
		
		
		
		public function set volume($volume:Number):void
		{
			return this.setVolume($volume);
		}
		
		public function get volume():Number
		{
			return this.getVolume();
		}
	}
}