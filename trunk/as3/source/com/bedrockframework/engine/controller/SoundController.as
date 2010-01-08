package com.bedrockframework.engine.controller
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.event.BedrockEvent;
	
	import flash.media.Sound;

	public class SoundController extends StandardWidget
	{
		/*
		Variable Declarations
		*/
		
		/*
		Constructor
		*/
		public function SoundController()
		{
			
		}
		public function initialize():void
		{
			this.createListeners();
		}
		/*
		Creation Functions
		*/
		private function createListeners():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.ADD_SOUND, this.onAddSound);
			BedrockDispatcher.addEventListener(BedrockEvent.PLAY_SOUND, this.onPlaySound);
			BedrockDispatcher.addEventListener(BedrockEvent.STOP_SOUND, this.onStopSound);
			
			BedrockDispatcher.addEventListener(BedrockEvent.FADE_SOUND, this.onFadeSound);
			
			BedrockDispatcher.addEventListener(BedrockEvent.ADJUST_SOUND_VOLUME, this.onAdjustSoundVolume);
			BedrockDispatcher.addEventListener(BedrockEvent.ADJUST_SOUND_PAN, this.onAdjustSoundPan);
			BedrockDispatcher.addEventListener(BedrockEvent.ADJUST_GLOBAL_VOLUME, this.onAdjustGlobalVolume);
			BedrockDispatcher.addEventListener(BedrockEvent.ADJUST_GLOBAL_PAN, this.onAdjustGlobalPan);
			
			BedrockDispatcher.addEventListener(BedrockEvent.MUTE, this.onMute);
			BedrockDispatcher.addEventListener(BedrockEvent.UNMUTE, this.onUnmute);
		}
		/*
		Basic Sound Event Handlers
	 	*/
		private function onAddSound($event:BedrockEvent):void
		{
			var objDetails:Object = $event.details;
			var objSound:Sound = objDetails.sound || BedrockEngine.assetManager.getSound($event.details.alias);
			BedrockEngine.soundManager.addSound(objDetails.alias, objSound, objDetails.allowMultiple);
		}
		private function onPlaySound($event:BedrockEvent):void
		{
			var objDetails:Object = $event.details;
			//BedrockEngine.soundManager.playSound(objDetails.alias, objDetails.startTime, objDetails.delay, objDetails.loops, objDetails.volume, objDetails.panning);
			BedrockEngine.soundManager.playSound(objDetails.alias, objDetails.startTime || 0, objDetails.delay || 0, objDetails.loops || 0, objDetails.volume || 1, objDetails.panning || 0);
		}
		private function onStopSound($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.stopSound($event.details.alias);
		}
		/*
		Fade Event Handlers
		*/
		private function onFadeSound($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.fadeSound( $event.details.alias, $event.details.time, $event.details.value, $event.details.onComplete );
		}
		/*
		Volume & Pan Event Handlers
		*/
		private function onAdjustSoundVolume($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.setSoundVolume($event.details.alias, $event.details.volume);
		}
		private function onAdjustSoundPan($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.setSoundPanning($event.details.alias, $event.details.panning);
		}
		private function onAdjustGlobalVolume($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.setGlobalVolume($event.details.volume);
		}
		private function onAdjustGlobalPan($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.setGlobalPanning($event.details.panning);
		}
		/*
		Mute Event Handlers
		*/
		private function onMute($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.muteGlobal();
		}
		private function onUnmute($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.unmuteGlobal();
		}
	}
}