package com.autumntactics.video
{
	import com.autumntactics.events.TriggerEvent;
	import com.autumntactics.events.VideoEvent;
	import com.autumntactics.bedrock.base.SpriteWidget;
	import com.autumntactics.timer.Trigger;
	import com.autumntactics.util.MathUtil;
	
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
		private var objVideo:Video;
		private var strURL:String;
        private var objConnection:NetConnection;
        private var objStream:NetStream;
        private var bolPaused:Boolean;
        private var objTransform:SoundTransform;
        private var objBufferTrigger:Trigger;
        private var objLoadTrigger:Trigger;
        private var objProgressTrigger:Trigger;
        private var numDuration:Number;
        private var bolJustLoad:Boolean;
        /*
        Constructor
        */	
		public function VideoPlayer($width:int = 320, $height:int = 240)
		{
			this.bolPaused = false;
			
			this.objBufferTrigger = new Trigger();
			this.objBufferTrigger.addEventListener(TriggerEvent.TRIGGER, this.onBufferTrigger);
			this.objBufferTrigger.silenceLogging = true;
			this.objLoadTrigger = new Trigger();
			this.objLoadTrigger.addEventListener(TriggerEvent.TRIGGER, this.onLoadTrigger);
			this.objLoadTrigger.silenceLogging = true;
			this.objProgressTrigger = new Trigger();
			this.objProgressTrigger.addEventListener(TriggerEvent.TRIGGER, this.onProgressTrigger);
			this.objProgressTrigger.silenceLogging = true;
			
			this.objConnection = new NetConnection();
			this.objConnection.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusHandler);			
            this.objConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);

			this.objVideo = new Video($width, $height);
			this.addChild(this.objVideo);
		}
		public function initialize($connection:String = null):void
		{
            this.objConnection.connect($connection);
            
            this.objStream = new NetStream(this.objConnection);
            this.objStream.client = this.createClient();
            this.objStream.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusHandler);
            this.objStream.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this.objStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onSyncError);
            
			this.objVideo.attachNetStream(this.objStream);
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
			this.numDuration = 0;
			this.strURL = $url || this.strURL;
			
			this.objBufferTrigger.start(0.1);
			this.objLoadTrigger.start(0.1);
			
			this.objStream.play(this.strURL);
		}
		public function stop():void
		{
			this.objStream.close();
			this.stopTriggers();
			this.dispatchEvent(new VideoEvent(VideoEvent.STOP, this));
		}
		public function clear():void
		{
			this.objConnection.close();
			this.objStream.close();
			this.objVideo.clear();
			this.stopTriggers();
			this.dispatchEvent(new VideoEvent(VideoEvent.CLEAR, this));
		}
		/*
		Interval Handling
		*/
		private function stopTriggers():void
		{
			this.objBufferTrigger.stop();
			this.objLoadTrigger.stop();
			this.objProgressTrigger.stop();
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
			return this.objTransform.volume;
		}
		/*
		Set Transform
		*/
		public function setTransform($transform:SoundTransform = null):void
		{
			if ($transform) {
				this.objTransform = $transform;				
			}
			this.objStream.soundTransform = this.objTransform;
		}
		public function getTransform():SoundTransform
		{
			return this.objTransform;
		}
		/*
		Pausing
		*/
		public function pause():void
		{
			if (!this.bolPaused) {
				
				this.objStream.pause();
				this.bolPaused = true;
				this.dispatchEvent(new VideoEvent(VideoEvent.PAUSE, this));
			}
		}
		public function resume():void
		{
			if (this.bolPaused) {
				
				this.objStream.resume();
				this.bolPaused = false;
				this.dispatchEvent(new VideoEvent(VideoEvent.RESUME, this));
			}
		}
		/*
		Seek
		*/
		public function seek($time:Number):void
		{
			this.dispatchEvent(new VideoEvent(VideoEvent.SEEK_START, this));
			this.objStream.seek($time);
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
			this.objProgressTrigger.start(0.1);			
		}
		private function onPlayStop($event:VideoEvent):void
		{
			this.removeEventListener(VideoEvent.BUFFER_EMPTY, this.onBufferEmpty);
			this.objLoadTrigger.stop();
			this.objProgressTrigger.stop();
			this.objBufferTrigger.stop();
		}
		private function onBufferFull($event:VideoEvent):void
		{
			this.objBufferTrigger.stop();
		}
		private function onBufferEmpty($event:VideoEvent):void
		{
			this.objBufferTrigger.start(0.1);
		}
		/*
		Trigger Handlers
		*/
		private function onBufferTrigger($event:TriggerEvent):void
		{
			var numPercent:int = MathUtil.calculatePercentage(this.objStream.bufferLength, this.objStream.bufferTime);
			
			var objDetails:Object = new Object();
			objDetails.bufferLength = this.objStream.bufferLength;
			objDetails.bufferTime = this.objStream.bufferTime;
			objDetails.percent = (numPercent > 100) ? 100 : numPercent;

			this.dispatchEvent(new VideoEvent(VideoEvent.BUFFER_PROGRESS, this, objDetails));
		}
		private function onLoadTrigger($event:TriggerEvent):void
		{
			var numPercent:int = MathUtil.calculatePercentage(this.objStream.bytesLoaded, this.objStream.bytesTotal);
			
			var objDetails:Object = new Object();
			objDetails.bytesLoaded = this.objStream.bytesLoaded;
			objDetails.bytesTotal = this.objStream.bytesTotal;		
			objDetails.percent = (numPercent > 100) ? 100 : numPercent;

			this.dispatchEvent(new VideoEvent(VideoEvent.LOAD_PROGRESS, this, objDetails));
		}
		private function onProgressTrigger($event:TriggerEvent):void
		{
			var numPercent:int = MathUtil.calculatePercentage(this.objStream.time, this.numDuration);
			
			var objDetails:Object = new Object();
			objDetails.position = this.objStream.time;
			objDetails.duration = this.numDuration;
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
			this.numDuration = $info.duration;
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
			return this.bolPaused;
		}
		public function set smoothing($status:Boolean):void
		{
			this.objVideo.smoothing = $status;
		}
		public function get smoothing():Boolean
		{
			return this.objVideo.smoothing;
		}
		public function set deblocking($status:int):void
		{
			this.objVideo.deblocking = $status;
		}
		public function get deblocking():int
		{
			return this.objVideo.deblocking;
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
			this.objStream.bufferTime = $value;
		}
		public function get bufferTime():Number
		{
			return this.objStream.bufferTime;
		}
		public function get duration():Number
		{
			return this.numDuration;
		}
	}
}