package com.bedrockframework.plugin.video
{
	import com.bedrockframework.plugin.event.TriggerEvent;
	import com.bedrockframework.plugin.event.VideoEvent;
	import com.bedrockframework.core.base.SpriteWidget;
	import com.bedrockframework.plugin.timer.Trigger;
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
        private var _bolPaused:Boolean;
        private var _objTransform:SoundTransform;
        private var _objBufferTrigger:Trigger;
        private var _objLoadTrigger:Trigger;
        private var _objProgressTrigger:Trigger;
        private var _numDuration:Number;
        private var _bolJustLoad:Boolean;
        /*
        Constructor
        */	
		public function VideoPlayer($width:int = 320, $height:int = 240)
		{
			this._bolPaused = false;
			
			this._objBufferTrigger = new Trigger();
			this._objBufferTrigger.addEventListener(TriggerEvent.TRIGGER, this.onBufferTrigger);
			this._objBufferTrigger.silenceLogging = true;
			this._objLoadTrigger = new Trigger();
			this._objLoadTrigger.addEventListener(TriggerEvent.TRIGGER, this.onLoadTrigger);
			this._objLoadTrigger.silenceLogging = true;
			this._objProgressTrigger = new Trigger();
			this._objProgressTrigger.addEventListener(TriggerEvent.TRIGGER, this.onProgressTrigger);
			this._objProgressTrigger.silenceLogging = true;
			
			this._objConnection = new NetConnection();
			this._objConnection.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusHandler);			
            this._objConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);

			this._objVideo = new Video($width, $height);
			this.addChild(this._objVideo);
		}
		public function initialize($connection:String = null):void
		{
            this._objConnection.connect($connection);
            
            this._objStream = new NetStream(this._objConnection);
            this._objStream.client = this.createClient();
            this._objStream.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusHandler);
            this._objStream.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._objStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onSyncError);
            
			this._objVideo.attachNetStream(this._objStream);
			//
			this.createInteralListeners();
		}
		private function createInteralListeners():void
		{
			this.addEventListener(VideoEvent.BUFFER_FULL, this.onBufferFull);
			this.addEventListener(VideoEvent.BUFFER_EMPTY, this.onBufferEmpty);
			this.addEventListener(VideoEvent.PLAY_START, this.onPlayStart);
			this.addEventListener(VideoEvent.PLAY_STOP, this.onPlayStop);			
		}
		private function createClient():Object
		{
			var objClient:Object = new Object();
			objClient.onMetaData = this.onMetaData;
			objClient.onCuePoint = this.onCuePoint;
			objClient.onPlayStatus = this.onPlayStatus;
			return objClient;
		}
		/*
		Basic Functions
		*/
		public function play($url:String = null):void
		{
			this._numDuration = 0;
			this._strURL = $url || this._strURL;
			
			this._objBufferTrigger.start(0.1);
			this._objLoadTrigger.start(0.1);
			
			this._objStream.play(this._strURL);
		}
		public function stop():void
		{
			this._objStream.close();
			this.stopTriggers();
			this.dispatchEvent(new VideoEvent(VideoEvent.STOP, this));
		}
		public function clear():void
		{
			this._objConnection.close();
			this._objStream.close();
			this._objVideo.clear();
			this.stopTriggers();
			this.dispatchEvent(new VideoEvent(VideoEvent.CLEAR, this));
		}
		/*
		Interval Handling
		*/
		private function stopTriggers():void
		{
			this._objBufferTrigger.stop();
			this._objLoadTrigger.stop();
			this._objProgressTrigger.stop();
		}
		/*
		Muting
		*/
		public function mute():void
		{
			this.setVolume(0);
			this.dispatchEvent(new VideoEvent(VideoEvent.MUTE, this));
		}
		public function unmute():void
		{
			this.setVolume(1);
			this.dispatchEvent(new VideoEvent(VideoEvent.UNMUTE, this));
		}
		/*
		Set Volume
		*/
		private function setVolume($value:Number):void
		{
			this.setTransform(new SoundTransform($value, 0));
			this.dispatchEvent(new VideoEvent(VideoEvent.VOLUME, this, {volume:$value}));
		}
		private function getVolume():Number
		{
			return this._objTransform.volume;
		}
		/*
		Set Transform
		*/
		public function setTransform($transform:SoundTransform = null):void
		{
			if ($transform) {
				this._objTransform = $transform;				
			}
			this._objStream.soundTransform = this._objTransform;
		}
		public function getTransform():SoundTransform
		{
			return this._objTransform;
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
			this._objProgressTrigger.start(0.1);			
		}
		private function onPlayStop($event:VideoEvent):void
		{
			this.removeEventListener(VideoEvent.BUFFER_EMPTY, this.onBufferEmpty);
			this._objLoadTrigger.stop();
			this._objProgressTrigger.stop();
			this._objBufferTrigger.stop();
		}
		private function onBufferFull($event:VideoEvent):void
		{
			this._objBufferTrigger.stop();
		}
		private function onBufferEmpty($event:VideoEvent):void
		{
			this._objBufferTrigger.start(0.1);
		}
		/*
		Trigger Handlers
		*/
		private function onBufferTrigger($event:TriggerEvent):void
		{
			var numPercent:int = MathUtil.calculatePercentage(this._objStream.bufferLength, this._objStream.bufferTime);
			
			var objDetails:Object = new Object();
			objDetails.bufferLength = this._objStream.bufferLength;
			objDetails.bufferTime = this._objStream.bufferTime;
			objDetails.percent = (numPercent > 100) ? 100 : numPercent;

			this.dispatchEvent(new VideoEvent(VideoEvent.BUFFER_PROGRESS, this, objDetails));
		}
		private function onLoadTrigger($event:TriggerEvent):void
		{
			var numPercent:int = MathUtil.calculatePercentage(this._objStream.bytesLoaded, this._objStream.bytesTotal);
			
			var objDetails:Object = new Object();
			objDetails.bytesLoaded = this._objStream.bytesLoaded;
			objDetails.bytesTotal = this._objStream.bytesTotal;		
			objDetails.percent = (numPercent > 100) ? 100 : numPercent;

			this.dispatchEvent(new VideoEvent(VideoEvent.LOAD_PROGRESS, this, objDetails));
		}
		private function onProgressTrigger($event:TriggerEvent):void
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
		}
		private function onMetaData($info:Object):void
		{
			this._numDuration = $info.duration;
			this.dispatchEvent(new VideoEvent(VideoEvent.CUE_POINT, this, $info));
		}
		private function onPlayStatus($info:Object):void
		{
			trace("onPlayStatus");
		}		
		/*
		Property Definitions
		*/
		public function get isPaused():Boolean 
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
		public function set volume($value:Number):void
		{
			this.setVolume($value);
		}
		public function get volume():Number
		{
			return this.getVolume();
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
	}
}