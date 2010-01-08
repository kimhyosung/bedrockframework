package com.bedrockframework.engine.controller
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.data.SoundData;
	
	import flash.media.Sound;

	public class SoundController extends StandardWidget
	{
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
			
			BedrockDispatcher.addEventListener(BedrockEvent.FADE_VOLUME, this.onFadeVolume);
			BedrockDispatcher.addEventListener(BedrockEvent.FADE_PANNING, this.onFadePanning);
			
			BedrockDispatcher.addEventListener(BedrockEvent.SET_VOLUME, this.onSetVolume);
			BedrockDispatcher.addEventListener(BedrockEvent.SET_PANNING, this.onSetPanning);
			
			BedrockDispatcher.addEventListener(BedrockEvent.MUTE, this.onMute);
			BedrockDispatcher.addEventListener(BedrockEvent.UNMUTE, this.onUnmute);
		}
		/*
		Basic Sound Event Handlers
	 	*/
		private function onAddSound($event:BedrockEvent):void
		{
			var objDetails:Object = $event.details;
			var objSound:Sound = objDetails.sound || BedrockEngine.assetManager.getSound( $event.details.alias );
			BedrockEngine.soundManager.add( new SoundData( objDetails.alias, objSound, objDetails.allowMultiple ) );
		}
		private function onPlaySound($event:BedrockEvent):void
		{
			var objDetails:Object = $event.details;
			BedrockEngine.soundManager.play(objDetails.alias, objDetails.startTime, objDetails.delay, objDetails.loops, objDetails.volume, objDetails.panning);
		}
		private function onStopSound($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.stop( $event.details.alias);
		}
		/*
		Fade Event Handlers
		*/
		private function onFadeVolume($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.fadeVolume( $event.details.alias, $event.details.time, $event.details.value, $event.details.handlers );
		}
		private function onFadePanning($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.fadePanning( $event.details.alias, $event.details.time, $event.details.value, $event.details.handlers );
		}
		/*
		Volume & Pan Event Handlers
		*/
		private function onSetVolume( $event:BedrockEvent ):void
		{
			BedrockEngine.soundManager.setVolume( $event.details.alias, $event.details.volume );
		}
		private function onSetPanning( $event:BedrockEvent ):void
		{
			BedrockEngine.soundManager.setPanning( $event.details.alias, $event.details.panning );
		}
		/*
		Mute Event Handlers
		*/
		private function onMute($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.mute( $event.details.alias );
		}
		private function onUnmute($event:BedrockEvent):void
		{
			BedrockEngine.soundManager.unmute( $event.details.alias );
		}
	}
}