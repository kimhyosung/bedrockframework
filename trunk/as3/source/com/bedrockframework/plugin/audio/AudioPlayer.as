package com.bedrockframework.plugin.audio
{
	/**
	 * Generic, auxiliary functions
	 *
	 * @author		Alex Toledo
	 * @version	1.0.0
	 * @created	
	 */
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.event.AudioEvent;
	import com.bedrockframework.plugin.event.IntervalTriggerEvent;
	import com.bedrockframework.plugin.timer.IntervalTrigger;
	import com.bedrockframework.plugin.util.MathUtil;
	
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
		private var _objSound:Sound;
		private var _objChannel:SoundChannel;
		private var _objTransform:SoundTransform;
		private var _strURL:String;
		private var _objPositionTrigger:IntervalTrigger;
		private var _numResumeTime:Number;
		private var _bolPaused:Boolean;
		/*
		Constructor
		*/
		public function AudioPlayer()
		{
			this._bolPaused = false;			
			this._objPositionTrigger = new IntervalTrigger(0.05);
			this._objPositionTrigger.addEventListener(IntervalTriggerEvent.TRIGGER, this.onProgressTrigger);
			this._objPositionTrigger.silenceLogging = true;
		}
		
		public function initialize($sound:Sound = null):void
		{
			this.setSound($sound);
		}
		/*
		Setting Sound
		*/
		private function setSound($sound:Sound = null):void
		{
			this._objSound = $sound || new Sound();
			this._objTransform = new SoundTransform();
			this._objSound.addEventListener(Event.COMPLETE, this.onLoadComplete);
			this._objSound.addEventListener(Event.OPEN, this.onOpen);
			this._objSound.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
			this._objSound.addEventListener(Event.ID3, this.onID3);
			this._objSound.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
		}
		/*
		Load File
		*/
		public function load($url:String):void
		{
			if(this._objSound != null){
				this.regenerateSound();
			}
			this._objSound.load(new URLRequest($url));
		}
		/*
		Play
		*/
		public function play($startTime:Number = 0, $loops:int = 0, $transform:SoundTransform = null):SoundChannel 
		{
			this._bolPaused = false;
			this._objPositionTrigger.start();
			this._objChannel = this._objSound.play($startTime, $loops, $transform);
			this._objChannel.addEventListener(Event.SOUND_COMPLETE, this.onPlayComplete);
			this.setTransform($transform);
			
			this.dispatchEvent(new AudioEvent(AudioEvent.PLAY, this, {duration:this._objSound.length}));
			return this._objChannel;			
		}
		public function stop():void
		{
			this._bolPaused = false;
			this._objChannel.stop();
			this._objPositionTrigger.stop();
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
			if (!this._bolPaused) {
				this._bolPaused = true;
				this._numResumeTime = this._objChannel.position;
				this._objPositionTrigger.stop();
				this._objChannel.stop();
				this.dispatchEvent(new AudioEvent(AudioEvent.PAUSE, this));
			}
		}
		public function resume():void
		{
			if (this._bolPaused) {
				this._bolPaused = false;
				this.play(this._numResumeTime);
				this._objPositionTrigger.start();
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
			return this._objTransform.volume;
		}
		/*
		Set Panning
		*/
		public function setPan($value:Number):void
		{
			this.setTransform(new SoundTransform(this.getVolume(), $value));
			this.dispatchEvent(new AudioEvent(AudioEvent.PAN, this, {volume:$value}));
		}
		
		public function getPan():Number
		{
			return this._objTransform.pan;
		}
		/*
		Set Transform
		*/
		public function setTransform($transform:SoundTransform = null):void
		{
			if ($transform) {
				this._objTransform = $transform;				
			}
			this._objChannel.soundTransform = this._objTransform;
		}
		public function getTransform():SoundTransform
		{
			return this._objTransform;
		}
		/*
		Recreate Sound Object
		*/
		
		private function regenerateSound():void
		{
			this._objSound.removeEventListener(Event.COMPLETE, this.onLoadComplete);
			this._objSound.removeEventListener(Event.OPEN, this.onOpen);
			this._objSound.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
			this._objSound.removeEventListener(Event.ID3, this.onID3);
			this._objSound.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
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
			this.dispatchEvent(new AudioEvent(AudioEvent.OPEN, this, {url:this._strURL}));
		}
		private function onID3($event:Event):void
		{
			this.dispatchEvent(new AudioEvent(AudioEvent.ID3, this, this._objSound.id3));
		}
		private function onIOError($event:IOErrorEvent):void
		{
			this.dispatchEvent(new AudioEvent(AudioEvent.ERROR, this, {url:this._strURL}));
		}
		private function onPlayComplete($event:Event):void
		{
			this._objPositionTrigger.stop();
			this.dispatchEvent(new AudioEvent(AudioEvent.PLAY_COMPLETE, this, {}));			
		}
		private function onProgressTrigger($event:IntervalTriggerEvent):void
		{
			var objDetails :Object = new Object();
			objDetails.position = this._objChannel.position;
			objDetails.duration = this._objSound.length;
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
			return this._objSound;
		}
		public function get channel():SoundChannel
		{
			return this._objChannel;	
		}
		 public function get transform():SoundTransform
		 {
		 	return this._objTransform;
		 }
	}
}