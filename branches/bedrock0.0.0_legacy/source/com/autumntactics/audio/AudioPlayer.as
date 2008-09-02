package com.builtonbedrock.audio
{
	/**
	 * Generic, auxiliary functions
	 *
	 * @author		Alex Toledo
	 * @version	1.0.0
	 * @created	
	 */
	import com.builtonbedrock.events.AudioEvent;
	import com.builtonbedrock.events.TriggerEvent;
	import com.builtonbedrock.bedrock.base.DispatcherWidget;
	import com.builtonbedrock.timer.Trigger;
	import com.builtonbedrock.util.MathUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class AudioPlayer extends DispatcherWidget
	{
		/*
		Variable Declarations
		*/
		private var objSound:Sound;
		private var objChannel:SoundChannel;
		private var objTransform:SoundTransform;
		private var strURL:String;
		private var objPositionTrigger:Trigger;
		private var numInterval:Number;
		private var numResumeTime:Number;
		private var bolPaused:Boolean;
		/*
		Constructor
		*/
		public function AudioPlayer($sound:Sound = null)
		{
			this.bolPaused = false;
			this.numInterval = 0.05;
			this.setSound($sound);
			this.objPositionTrigger = new Trigger("Position");
			this.objPositionTrigger.addEventListener(TriggerEvent.TRIGGER, this.onProgressTrigger);
			this.objPositionTrigger.silenceLogging = true;
		}
		/*
		Setting Sound
		*/
		private function setSound($sound:Sound = null):void
		{
			this.objSound = $sound || new Sound();
			this.objTransform = new SoundTransform();
			this.objSound.addEventListener(Event.COMPLETE, this.onLoadComplete);
			this.objSound.addEventListener(Event.OPEN, this.onOpen);
			this.objSound.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
			this.objSound.addEventListener(Event.ID3, this.onID3);
			this.objSound.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
		}
		/*
		Load File
		*/
		public function load($url:String):void
		{
			if(this.objSound != null){
				this.regenerateSound();
			}
			this.objSound.load(new URLRequest($url));
		}
		/*
		Play
		*/
		public function play($startTime:Number = 0, $loops:int = 0, $transform:SoundTransform = null):SoundChannel 
		{
			this.bolPaused = false;
			this.objPositionTrigger.start(this.numInterval);
			this.objChannel = this.objSound.play($startTime, $loops, $transform);
			this.objChannel.addEventListener(Event.SOUND_COMPLETE, this.onPlayComplete);
			this.setTransform($transform);
			
			this.dispatchEvent(new AudioEvent(AudioEvent.PLAY, this, {duration:this.objSound.length}));
			return this.objChannel;			
		}
		public function stop():void
		{
			this.bolPaused = false;
			this.objChannel.stop();
			this.objPositionTrigger.stop();
			this.dispatchEvent(new AudioEvent(AudioEvent.STOP, this));
		}
		
		/*
		Muting
		*/
		public function mute():void
		{
			this.setVolume(0);
			this.dispatchEvent(new AudioEvent(AudioEvent.MUTE, this));
		}
		public function unmute():void
		{
			this.setVolume(1);
			this.dispatchEvent(new AudioEvent(AudioEvent.UNMUTE, this));
		}
		/*
		Pausing
		*/
		public function pause():void
		{
			if (!this.bolPaused) {
				this.bolPaused = true;
				this.numResumeTime = this.objChannel.position;
				this.objPositionTrigger.stop();
				this.objChannel.stop();
				this.dispatchEvent(new AudioEvent(AudioEvent.PAUSE, this));
			}
		}
		public function resume():void
		{
			if (this.bolPaused) {
				this.bolPaused = false;
				this.play(this.numResumeTime);
				this.objPositionTrigger.start(this.numInterval);
				this.dispatchEvent(new AudioEvent(AudioEvent.RESUME, this));
			}			
		}
		/*
		Set Volume
		*/
		public function setVolume($value:Number):void
		{
			this.setTransform(new SoundTransform($value, this.getPan()));
			this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME, this, {volume:$value}));
		}
		public function getVolume():Number
		{
			return this.objTransform.volume;
		}
		/*
		Set Panning
		*/
		private function setPan($value:Number):void
		{
			this.setTransform(new SoundTransform(this.getVolume(), $value));
			this.dispatchEvent(new AudioEvent(AudioEvent.PAN, this, {volume:$value}));
		}
		
		private function getPan():Number
		{
			return this.objTransform.pan;
		}
		/*
		Set Transform
		*/
		public function setTransform($transform:SoundTransform = null):void
		{
			if ($transform) {
				this.objTransform = $transform;				
			}
			this.objChannel.soundTransform = this.objTransform;
		}
		public function getTransform():SoundTransform
		{
			return this.objTransform;
		}
		/*
		Recreate Sound Object
		*/
		
		private function regenerateSound():void
		{
			this.objSound.removeEventListener(Event.COMPLETE, this.onLoadComplete);
			this.objSound.removeEventListener(Event.OPEN, this.onOpen);
			this.objSound.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
			this.objSound.removeEventListener(Event.ID3, this.onID3);
			this.objSound.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
			this.setSound();
		}
		
		
		/*
		Event Handlers
		*/
		private function onLoadComplete($event:Event):void
		{
			this.dispatchEvent(new AudioEvent(AudioEvent.LOAD_COMPLETE, this, {}));
		}
		private function onProgress($event:ProgressEvent):void
		{
			var objDetails:Object = new Object();
			objDetails.bytesLoaded = $event.bytesLoaded;
			objDetails.bytesTotal = $event.bytesTotal;
			objDetails.percent = MathUtil.calculatePercentage(objDetails.bytesLoaded,objDetails.bytesTotal);
			this.dispatchEvent(new AudioEvent(AudioEvent.LOAD_PROGRESS, this, objDetails));
		}
		private function onOpen($event:Event):void
		{
			this.dispatchEvent(new AudioEvent(AudioEvent.OPEN, this, {url:this.strURL}));
		}
		private function onID3($event:Event):void
		{
			this.dispatchEvent(new AudioEvent(AudioEvent.ID3, this, this.objSound.id3));
		}
		private function onIOError($event:IOErrorEvent):void
		{
			this.dispatchEvent(new AudioEvent(AudioEvent.ERROR, this, {url:this.strURL}));
		}
		private function onPlayComplete($event:Event):void
		{
			this.objPositionTrigger.stop();
			this.dispatchEvent(new AudioEvent(AudioEvent.PLAY_COMPLETE, this, {}));			
		}
		private function onProgressTrigger($event:TriggerEvent):void
		{
			var objDetails :Object = new Object();
			objDetails.position = this.objChannel.position;
			objDetails.duration = this.objSound.length;
			objDetails.percent = MathUtil.calculatePercentage(objDetails.position, objDetails.duration);
			this.dispatchEvent(new AudioEvent(AudioEvent.PLAY_PROGRESS, this, objDetails));
		}
		
		/*
		Property Definitions
		*/
		public function get volume():Number
		{
			return this.getVolume();
		}
		public function set volume($value:Number):void
		{
			this.setVolume($value);	
		}
		public function get pan():Number
		{
			return this.getPan();
		}
		public function set pan($value:Number):void
		{
			this.setPan($value);	
		}		
		public function get sound():Sound
		{
			return this.objSound;
		}
		public function get channel():SoundChannel
		{
			return this.objChannel;	
		}
		 public function get transform():SoundTransform
		 {
		 	return this.objTransform;
		 }
		 public function set interval($value:int):void
		 {
		 	this.numInterval = $value;
		 }
		 public function get interval():int
		 {
		 	return this.numInterval;
		 }
	}
}