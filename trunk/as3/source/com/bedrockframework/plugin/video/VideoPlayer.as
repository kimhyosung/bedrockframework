package com.bedrockframework.plugin.video
{
	import com.bedrockframework.core.base.SpriteWidget;
	import com.bedrockframework.plugin.event.IntervalTriggerEvent;
	import com.bedrockframework.plugin.event.VideoEvent;
	import com.bedrockframework.plugin.timer.IntervalTrigger;
	import com.bedrockframework.plugin.util.MathUtil;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoPlayer extends SpriteWidget
	{
		/*
		Variable Definitions
		*/
		private var _objVideo:Video;
		private var _strURL:String;
        private var _objConnection:NetConnection;
        private var _objStream:NetStream;
        private var _objTransform:SoundTransform;
        private var _objSharedTrigger:IntervalTrigger;
		private var _objClient:Object;
        private var _numDuration:Number;        
        private var _bolPaused:Boolean;
        private var _bolLoadAndPause:Boolean;
        private var _objSoundTransform:SoundTransform;
		private var _numVolume:Number;
        /*
        Constructor
        */	
		public function VideoPlayer($width:int = 320, $height:int = 240)
		{
			this._bolPaused = false;
			this._numVolume = 1;
			this._objSoundTransform = new SoundTransform(this._numVolume, 0);
			
			this._objSharedTrigger = new IntervalTrigger();
			this._objSharedTrigger.silenceLogging = true;
			
			this._objConnection = new NetConnection();
			this._objConnection.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusHandler);			
            this._objConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);

			this._objVideo = new Video($width, $height);
			this.addChild(this._objVideo);
		}
		public function initialize($connection:String = null):void
		{
			this.createClient();
            this.createNetStream($connection);
			this.createInteralListeners();
		}
		private function createInteralListeners():void
		{
			this.addEventListener(VideoEvent.BUFFER_FULL, this.onBufferFull);
			this.addEventListener(VideoEvent.BUFFER_EMPTY, this.onBufferEmpty);
			this.addEventListener(VideoEvent.PLAY_START, this.onPlayStart);
			this.addEventListener(VideoEvent.PLAY_STOP, this.onPlayStop);			
		}
		private function createClient():void
		{
			this._objClient = new Object();
			this._objClient.onMetaData = this.onMetaData;
			this._objClient.onCuePoint = this.onCuePoint;
		}
		private function createNetStream($connection:String = null):void
		{
			this._objConnection.connect($connection);
            
            this._objStream = new NetStream(this._objConnection);
            this._objStream.client = this._objClient;
            this._objStream.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusHandler);
            this._objStream.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._objStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onSyncError);
            
			this._objVideo.attachNetStream(this._objStream);
		}
		/*
		Basic Functions
		*/
		public function play($url:String = null):void
		{
			this._numDuration = 0;
			this._strURL = $url || this._strURL;
			
			if (this.loadAndPause) {
				this.mute();
			}
			
			this._objSharedTrigger.start(0.1);
			
			this._objSharedTrigger.addEventListener(IntervalTriggerEvent.TRIGGER, this.onBufferTrigger);
			this._objSharedTrigger.addEventListener(IntervalTriggerEvent.TRIGGER, this.onLoadTrigger);
			
			this._objStream.play(this._strURL);
		}
		public function stop():void
		{
			this._objStream.close();
			this._objSharedTrigger.stop();
			this.dispatchEvent(new VideoEvent(VideoEvent.STOP, this));
		}
		public function clear():void
		{
			this._objConnection.close();
			this._objStream.close();
			this._objVideo.clear();
			this._objSharedTrigger.stop();
			this.dispatchEvent(new VideoEvent(VideoEvent.CLEAR, this));
		}
		/*
		Muting
		*/
		public function mute():void
		{
			this._numVolume = this._objSoundTransform.volume;
			this._objSoundTransform.volume = 0;
			this._objStream.soundTransform = this._objSoundTransform;
			this.dispatchEvent(new VideoEvent(VideoEvent.MUTE, this));
		}
		public function unmute():void
		{
			this._objSoundTransform.volume = this._numVolume;
			this._objStream.soundTransform = this._objSoundTransform;
			this.dispatchEvent(new VideoEvent(VideoEvent.UNMUTE, this));
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
		/*
		Pausing
		*/
		public function pause():void
		{
			if (!this._bolPaused) {
				this._objStream.pause();
				this._bolPaused = true;
				this.dispatchEvent(new VideoEvent(VideoEvent.PAUSE, this));
			}
		}
		public function resume():void
		{
			if (this._bolPaused) {
				this._objStream.resume();
				this._bolPaused = false;
				this.dispatchEvent(new VideoEvent(VideoEvent.RESUME, this));
			}
		}
		/*
		Seek
		*/
		public function seek($time:Number):void
		{
			this.dispatchEvent(new VideoEvent(VideoEvent.SEEK_START, this));
			this._objStream.seek($time);
		}
		
		private function checkForCompletion():Boolean
		{
			return (Math.floor(this._objStream.time) >= Math.floor(this._numDuration));
		}
		/*
		Event Handlers
		*/
		private function onStatusHandler($event:NetStatusEvent):void
		{
			this.dispatchEvent(new VideoEvent($event.info.code, this, $event));
		}
		private function onSecurityError($event:SecurityErrorEvent):void
		{
			this.dispatchEvent(new VideoEvent(VideoEvent.ERROR, this, {text:$event.text}));
		}
		private function onSyncError($event:AsyncErrorEvent):void
		{
			this.dispatchEvent(new VideoEvent(VideoEvent.ERROR, this, {text:$event.text, error:$event.error}));
		}
		private function onIOError($event:IOErrorEvent):void
		{
			this.dispatchEvent(new VideoEvent(VideoEvent.ERROR, this, {text:$event.text}));
		}
		/*
		
		
		*/
		private function onPlayStart($event:VideoEvent):void
		{
			this._objSharedTrigger.addEventListener(IntervalTriggerEvent.TRIGGER, this.onProgressTrigger);	
			if (this._bolLoadAndPause) {
				this.unmute();
				this.pause();
				this.seek(0);				
			}
		}
		private function onPlayStop($event:VideoEvent):void
		{
			this.removeEventListener(VideoEvent.BUFFER_EMPTY, this.onBufferEmpty);
			if (this.checkForCompletion()) {
				this._objSharedTrigger.stop();
				this.dispatchEvent(new VideoEvent(VideoEvent.PLAY_COMPLETE, this, $event.details));
			}
		}
		private function onBufferFull($event:VideoEvent):void
		{
			this.addEventListener(VideoEvent.BUFFER_EMPTY, this.onBufferEmpty);
			this._objSharedTrigger.removeEventListener(IntervalTriggerEvent.TRIGGER, this.onBufferTrigger);
		}
		private function onBufferEmpty($event:VideoEvent):void
		{
			this._objSharedTrigger.addEventListener(IntervalTriggerEvent.TRIGGER, this.onBufferTrigger);
		}
		/*
		Trigger Handlers
		*/
		private function onBufferTrigger($event:IntervalTriggerEvent):void
		{
			var numPercent:int = MathUtil.calculatePercentage(this._objStream.bufferLength, this._objStream.bufferTime);
			
			var objDetails:Object = new Object();
			objDetails.bufferLength = this._objStream.bufferLength;
			objDetails.bufferTime = this._objStream.bufferTime;
			objDetails.percent = (numPercent > 100) ? 100 : numPercent;

			this.dispatchEvent(new VideoEvent(VideoEvent.BUFFER_PROGRESS, this, objDetails));
		}
		private function onLoadTrigger($event:IntervalTriggerEvent):void
		{
			var numPercent:int = MathUtil.calculatePercentage(this._objStream.bytesLoaded, this._objStream.bytesTotal);
			
			var objDetails:Object = new Object();
			objDetails.bytesLoaded = this._objStream.bytesLoaded;
			objDetails.bytesTotal = this._objStream.bytesTotal;		
			objDetails.percent = (numPercent > 100) ? 100 : numPercent;
			
			if (numPercent == 100) {
				this.dispatchEvent(new VideoEvent(VideoEvent.LOAD_COMPLETE, this, objDetails));
				this._objSharedTrigger.removeEventListener(IntervalTriggerEvent.TRIGGER, this.onLoadTrigger);
			}
			
			this.dispatchEvent(new VideoEvent(VideoEvent.LOAD_PROGRESS, this, objDetails));
		}
		private function onProgressTrigger($event:IntervalTriggerEvent):void
		{
			var numPercent:int = MathUtil.calculatePercentage(this._objStream.time, this._numDuration);
			
			var objDetails:Object = new Object();
			objDetails.position = this._objStream.time;
			objDetails.duration = this._numDuration;
			objDetails.percent = (numPercent > 100) ? 100 : numPercent;
			this.dispatchEvent(new VideoEvent(VideoEvent.PLAY_PROGRESS, this, objDetails));
		}
		/*
		Weird Handlers
		*/
		private function onCuePoint($info:Object):void
		{
			this.dispatchEvent(new VideoEvent(VideoEvent.CUE_POINT, this, $info));			
		}
		private function onMetaData($info:Object):void
		{
			this._numDuration = $info.duration;	
			this.dispatchEvent(new VideoEvent(VideoEvent.META_DATA, this, $info));
		}	
		/*
		Property Definitions
		*/
		public function get paused():Boolean
		{
			return this._bolPaused;
		}
		public function set smoothing($status:Boolean):void
		{
			this._objVideo.smoothing = $status;
		}
		public function get smoothing():Boolean
		{
			return this._objVideo.smoothing;
		}
		public function set deblocking($status:int):void
		{
			this._objVideo.deblocking = $status;
		}
		public function get deblocking():int
		{
			return this._objVideo.deblocking;
		}
		public function set bufferTime($value:Number):void
		{
			this._objStream.bufferTime = $value;
		}
		public function get bufferTime():Number
		{
			return this._objStream.bufferTime;
		}
		public function get duration():Number
		{
			return this._numDuration;
		}
		public function set loadAndPause($value:Boolean):void
		{
			this._bolLoadAndPause = $value;
		}
		public function get loadAndPause():Boolean
		{
			return this._bolLoadAndPause;
		}
		/**
		* Change the video's sound volume.
		* @param value The volume, ranging from 0 (silent) to 1 (full volume). 
	 	*/
		public function set volume($value:Number):void
		{
			this._objSoundTransform.volume = $value;
			this._objStream.soundTransform = this._objSoundTransform;
			this.dispatchEvent(new VideoEvent(VideoEvent.VOLUME, this, {volume:$value}));
		}
		
		public function get volume():Number
		{
			return this._objSoundTransform.volume;
		}
		/**
		* Change the video's sound panning.
		* @param value The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right). A value of 0 represents no panning (center). 
	 	*/
		public function set pan($value:Number):void
		{
			this._objSoundTransform.pan =$value;
			this._objStream.soundTransform = this._objSoundTransform;
		}
		
		public function get pan():Number
		{
			return this._objSoundTransform.pan;
		}
	}
}