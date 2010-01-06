package com.bedrockframework.plugin.audio
{
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.data.SoundData;
	import com.bedrockframework.plugin.event.SoundEvent;
	import com.bedrockframework.plugin.storage.HashMap;
	import com.bedrockframework.plugin.util.ArrayUtil;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
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
		public function add($alias:String, $sound:Sound, $allowMultiple:Boolean = true):void
		{
			this._mapSounds.saveValue($alias, new SoundData($alias, $sound, $allowMultiple));
		}
		public function remove($alias:String):void
		{
			this._mapSounds.removeValue($alias);
		}
		public function load($alias:String, $url:String, $completeHandler:Function):void
		{
		
		}
		public function fadeVolume($alias:String, $time:Number, $volume:Number):void
		{
			var objChannel:SoundChannel
			if ($volume == 0) {
				objChannel = this.getChannel($alias)
				if (objChannel != null) {
					TweenLite.to(objChannel, $time, {volume:$volume, onComplete:this.stop, onCompleteParams:[$alias]});
				}
			} else {
				objChannel = this.getChannel($alias) || this.play($alias, 0, 0, 0, 0, 0);
				TweenLite.to(objChannel, $time, {volume:$volume});	
			}
		}
		
		public function fadePanning($alias:String, $panning:Number):void
		{
			
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
		/*
		Get Info by alias
		*/
		
		public function getSound($alias:String):Sound
		{
			return this.getDataByAlias($alias).sound;
		}
		public function getChannel($alias:String):SoundChannel
		{
			return this.getDataByAlias($alias).channel;
		}
		/*
		Transform Functions
		*/
		private function createTransform($volume:Number, $panning:Number):SoundTransform
		{
			return new SoundTransform($volume, $panning);
		}
		public function setTransform($alias:String, $transform:SoundTransform):void
		{
			try{
			var objChannel:SoundChannel = this.getChannel($alias);
			objChannel.soundTransform = $transform;
			}catch($error){
				//TypeError: Error #1009: Cannot access a property or method of a null object reference.
				//at com.bedrockframework.plugin.audio::SoundBoard/setTransform()
			}
		}				
		public function getTransform($alias:String):SoundTransform
		{
			return this.getChannel($alias).soundTransform;
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
			var objSoundData:SoundData = $data;
			var objSound:Sound = objSoundData.sound;
			objSoundData.playing = true;
			var objTransform:SoundTransform = this.createTransform(objSoundData.volume, objSoundData.panning);
			objSoundData.channel = objSound.play(objSoundData.startTime, objSoundData.loops, objTransform);
			//objSoundData.channel.addEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
			//objSoundData.channel.addEventListener(Event.DEACTIVATE, this.onSoundStop);
			this.setTransform(objSoundData.alias, objTransform);
			return objSoundData.channel;
		}
		private function playDelay($data:SoundData):void
		{
			TweenLite.to({count:0}, $data.delay, {count:100, onComplete:this.playImmediate, onCompleteParams:[$data]})
		}
		public function close($alias:String):void
		{
			var objSound:Sound =  this.getSound($alias);
			objSound.close();
		}
		public function stop($alias:String):void
		{
			var objChannel:SoundChannel = this.getChannel($alias);
			objChannel.stop();
		}
		/*
		Volume Functions
		*/
		public function setVolume($alias:String, $value:Number):void
		{
			this.setTransform($alias, this.createTransform($value, this.getPanning($alias)));
		}
		public function getVolume($alias:String):Number
		{
			return this.getTransform($alias).volume;
		}
		/*
		Pan Functions
		*/
		public function setPanning($alias:String, $value:Number):void
		{
			this.setTransform($alias, this.createTransform(this.getVolume($alias), $value));
		}
		public function getPanning($alias:String):Number
		{
			return this.getTransform($alias).pan;
		}
		/*
		Event Handlers
		*/
		private function onSoundStop($event:Event):void
		{
			trace($event.target)
		}
		private function onSoundComplete($event:Event):void
		{
			var objData:SoundData = this.getDataByChannel($event.target as SoundChannel);
			objData.playing = false;
			$event.target.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
			
			this.dispatchEvent(new SoundEvent(SoundEvent.SOUND_COMPLETE, this, objData));
		}
	}
}