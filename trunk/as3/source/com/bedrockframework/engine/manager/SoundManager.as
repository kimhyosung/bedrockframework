package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.engine.api.ISoundManager;
	import com.bedrockframework.plugin.audio.GlobalSound;
	import com.bedrockframework.plugin.audio.SoundBoard;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import gs.TweenMax;

	public class SoundManager extends StandardWidget implements ISoundManager
	{
		/*
		Variable Declarations
		*/
		private var _objSoundBoard:SoundBoard;
		private var _objGlobalSound:GlobalSound
		/*
		Constructor
		*/
		public function SoundManager()
		{
			this.createGlobalSound();
			this.createSoundBoard();
		}
		public function initialize($sounds:Array = null):void
		{
			this.createSounds($sounds);
		}
		/*
		Creation Functions
		*/
		private function createSoundBoard():void
		{
			this._objSoundBoard = new SoundBoard;
		}
		private function createGlobalSound():void
		{
			this._objGlobalSound = new GlobalSound;
		}
		private function createSounds($sounds:Array):void
		{
			var arrSounds:Array = $sounds;
			var numLength:int = $sounds.length;
			for (var i:int = 0 ; i < numLength; i++) {
				this.addSound(arrSounds[i].alias, arrSounds[i].value);
			}
		}
		/*
		Audio Functions
		*/
		public function addSound($alias:String, $sound:Sound):void
		{
			this._objSoundBoard.add($alias, $sound);
		}
		public function loadSound($alias:String, $url:String, $completeHandler:Function):void
		{
		}
		public function playSound($alias:String, $startTime:Number=0, $loops:int=0, $volume:Number = 1, $panning:Number = 0):SoundChannel
		{
			return this._objSoundBoard.play($alias, $startTime, $loops, $volume, $panning);
		}
		public function stopSound($alias:String):void
		{
			this._objSoundBoard.stop($alias);
		}
		public function closeSound($alias:String):void
		{
			this._objSoundBoard.stop($alias);
		}
		public function setSoundVolume($alias:String, $value:Number):void
		{
			this._objSoundBoard.setVolume($alias, $value);
		}
		public function getSoundVolume($alias:String):Number
		{
			return this._objSoundBoard.getVolume($alias);
		}
		public function setSoundPanning($alias:String, $value:Number):void
		{
			this._objSoundBoard.setPanning($alias, $value);
		}
		public function getSoundPanning($alias:String):Number
		{
			return this._objSoundBoard.getVolume($alias);
		}
		public function fadeInSound($alias:String, $time:Number):void
		{
			var objChannel:SoundChannel = this._objSoundBoard.play($alias);
			this._objSoundBoard.setVolume($alias, 0);
			TweenMax.to(objChannel, $time, {volume:1});
		}
		public function fadeOutSound($alias:String, $time:Number):void
		{
			var objChannel:SoundChannel = this._objSoundBoard.getChannel($alias);
			TweenMax.to(objChannel, $time, {volume:0, onComplete:this.onFadeOutComplete, onCompleteParams:[$alias]}); 
		}
		/*
		Global Sound Functions
		*/
		public function muteGlobal():void
		{
			this._objGlobalSound.mute();
		}
		public function unmuteGlobal():void
		{
			this._objGlobalSound.unmute();
		}
		public function toggleGlobalMute():Boolean
		{
			return this._objGlobalSound.toggleMute();
		}
		public function setGlobalPanning($value:Number):void
		{
			this._objGlobalSound.panning = $value;
		}
		public function getGlobalPanning():Number
		{
			return this._objGlobalSound.panning;
		}
		public function setGlobalVolume($value:Number):void
		{
			this._objGlobalSound.volume = $value;
		}
		public function getGlobalVolume():Number
		{
			return this._objGlobalSound.volume;
		} 
		/*
		Event Handlers
		*/
		private function onFadeOutComplete($alias:String):void
		{
			this.stopSound($alias);
		}
	}
}