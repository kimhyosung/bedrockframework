package com.bedrockframework.plugin.audio
{
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.data.SoundData;
	import com.bedrockframework.plugin.event.SoundEvent;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.ArrayUtil;
	
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import gs.TweenLite;

	public class SoundBoard extends DispatcherWidget implements ISoundBoard
	{
		/*
		Variable Declarations
		*/
		private var _mapSounds:HashMap;
		/*
		Constructor
		*/
		public function SoundBoard()
		{
			this._mapSounds = new HashMap();
		}
		
		/*
		Add a new sound
		*/
		public function add( $data:SoundData ):void
		{
			this._mapSounds.saveValue($data.alias, $data );
		}
		public function remove($alias:String):void
		{
			this._mapSounds.removeValue($alias);
		}
		public function load($alias:String, $url:String, $completeHandler:Function):void
		{
		
		}
		/*
		Yay
		*/
		public function play($alias:String, $startTime:Number = 0, $delay:Number = 0, $loops:int = 0, $volume:Number = 1, $panning:Number = 0):SoundChannel
		{
			var objSoundData:SoundData = this.getDataByAlias($alias);
			objSoundData.startTime = ( isNaN($startTime) ) ? 0 : $startTime;
			objSoundData.delay = ( isNaN($delay) ) ? 0 : $delay;
			objSoundData.loops = $loops;
			objSoundData.volume = ( isNaN($volume) ) ? 1 : $volume;
			objSoundData.panning = ( isNaN($panning) ) ? 0 : $panning;
			this.playConditional(objSoundData);
			//trace(objSoundData.allowMultiple, objSoundData.playing)
			/* if (objSoundData.allowMultiple && objSoundData.playing) {
				this.playConditional(objSoundData);
			} else if(objSoundData.allowMultiple && !objSoundData.playing) {
				this.playConditional(objSoundData);
			} */
			return null;
		}
		private function playConditional($data:SoundData):SoundChannel
		{
			if ($data.delay == 0) {
				return this.playImmediate($data);
			} else {
				this.playDelay($data);
				return null;
			}
		}
		private function playImmediate($data:SoundData):SoundChannel
		{
			var objData:SoundData = $data;
			objData.playing = true;
			objData.channel = objData.sound.play(objData.startTime, objData.loops, objData.transform );
			objData.mixer.target = objData.channel;
			objData.channel.addEventListener( Event.SOUND_COMPLETE, this.onSoundComplete );
			return objData.channel;
		}
		private function playDelay($data:SoundData):void
		{
			TweenLite.delayedCall( $data.delay, this.playImmediate, [$data] );
		}
		public function close($alias:String):void
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			if ( objData.playing ) {
				objData.playing = false;
				objData.channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete );
				objData.sound.close();
			}
		}
		public function stop($alias:String):void
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			if ( objData.playing ) {
				objData.playing = false;
				objData.channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete );
				objData.channel.stop();
			}
		}
		/*
		Get Data
		*/
		private function getDataByChannel($channel:SoundChannel):SoundData
		{
			var arrData:Array = this._mapSounds.getValues();
			return ArrayUtil.findItem(arrData, $channel, "channel");
		}
		private function getDataByAlias($alias:String):SoundData
		{
			return this._mapSounds.getValue($alias);
		}
		public function getData($alias:String):SoundData
		{
			return this.getDataByAlias( $alias );
		}
		/*
		Volume Functions
		*/
		public function setVolume($alias:String, $value:Number):void
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			objData.mixer.volume = $value;
		}
		public function getVolume($alias:String):Number
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			return objData.mixer.volume;
		}
		/*
		Pan Functions
		*/
		public function setPanning($alias:String, $value:Number):void
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			objData.mixer.panning = $value;
		}
		public function getPanning($alias:String):Number
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			return objData.mixer.panning;
		}
		/*
		Fade Functions
		*/
		public function fadeVolume($alias:String, $time:Number, $value:Number, $handlers:Object = null ):void
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			if ( !objData.playing ) this.play($alias, 0, 0, 0, 0, 0);
			objData.mixer.fadeVolume( $value, $time, $handlers );
		}
		
		public function fadePanning($alias:String, $time:Number, $value:Number, $handlers:Object = null ):void
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			if ( !objData.playing ) this.play($alias, 0, 0, 0, 0, 0);
			objData.mixer.fadePanning( $value, $time, $handlers );
		}
		/*
		Mute/ Unmute
		*/
		public function mute( $alias:String ):void
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			objData.mixer.mute();
		}
		public function unmute( $alias:String ):void
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			objData.mixer.unmute();
		}
		public function toggleMute( $alias:String ):Boolean
		{
			var objData:SoundData = this.getDataByAlias( $alias );
			return objData.mixer.toggleMute();
		}
		/*
		Event Handlers
		*/
		private function onSoundComplete($event:Event):void
		{
			var objData:SoundData = this.getDataByChannel($event.target as SoundChannel);
			objData.playing = false;
			objData.channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
			
			this.dispatchEvent( new SoundEvent(SoundEvent.SOUND_COMPLETE, this, objData) );
		}
	}
}