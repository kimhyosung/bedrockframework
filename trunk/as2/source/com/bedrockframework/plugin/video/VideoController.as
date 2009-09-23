/**

VideoReceiver
This class will package together the functionality of the NetStream and NetConnection objects. 
Creating one reusable controller that can be used with multiple views.

*/
import icg.util.Proxy;
import icg.timer.IntervalTrigger;
import icg.datatype.Event;
class icg.video.VideoReceiver extends icg.base.BroadcastWidget
{
	/*
	Variable Decarations
	*/
	private var strClassName:String = "VideoReceiver";
	private var objNetConnection:NetConnection;
	private var objNetStream:NetStream;
	private var objVideo:Video;
	private var strVideoFile:String;
	private var bolPaused:Boolean;
	private var objMetaData:Object;
	private var arrCuePoints:Array;
	private var objStatusTrigger;
	private var bolBuffered:Boolean;
	private var bolLoaded:Boolean;
	private var mcVideoVolume:MovieClip;
	private var objVideoSound:Sound;
	private var bolTrackStatus:Boolean;
	/*
	Constructor
	*/
	public function VideoReceiver($properties:Object)
	{
		this.setup($properties);
	}
	private function register()
	{
		this.registerEvent("onBufferEmpty");
		this.registerEvent("onBufferFull");
		this.registerEvent("onBufferFlush");
		this.registerEvent("onStreamNotFound");
		this.registerEvent("onInvalidTime");
		this.registerEvent("onPlayStart");
		this.registerEvent("onPlayStop");
		this.registerEvent("onSeekNotify");
		this.registerEvent("onPlay");
		this.registerEvent("onPause");
		this.registerEvent("onStop");
		this.registerEvent("onClose");
		this.registerEvent("onRewind");
		this.registerEvent("onFastForward");
		this.registerEvent("onSeek");
		this.registerEvent("onCuePoint");
		this.registerEvent("onVideoProgress");
		this.registerEvent("onVideoLoading");
		this.registerEvent("onVideoBuffering");
		this.registerEvent("onComplete");
	}
	/*
	Setup NetStream, NetConnection and class properties.
	*/
	public function setup($properties:Object):Void
	{
		if ($properties) {
			this.objStatusTrigger = new IntervalTrigger("Status");
			this.objStatusTrigger.subscribe(this,"onStatusTrigger");
			this.objStatusTrigger._outputSilenced = true;
			//
			this.objNetConnection = new NetConnection();
			//
			if ($properties.connectionSource) {
				var strViewerID:String = $properties.viewerID || null;
				this.objNetConnection.connect($properties.connectionSource,$properties.viewerID);
			} else {
				this.objNetConnection.connect(null);
			}
			//
			this.objNetStream = new NetStream(this.objNetConnection);
			//
			this.strVideoFile = $properties.file;
			//
			var numBufferTime:Number = $properties.bufferTime || 3;
			this.objNetStream.setBufferTime(numBufferTime);
			//
			this.objNetStream.onCuePoint = Proxy.createHandler(this, this.cuePointHandler);
			this.objNetStream.onStatus = Proxy.createHandler(this, this.statusHandler);
			this.objNetStream.onMetaData = Proxy.createHandler(this, this.metadataHandler);
			//
			this.objVideo = $properties.video;
			this.objVideo.attachVideo(this.objNetStream);
			//
			this.createSoundController();
			//
			var bolAutoPlay:Boolean = ($properties.autoPlay != undefined) ? $properties.autoPlay : true;
			if (bolAutoPlay) {
				this.play($properties.file);
			}
			//                                                                
			this.bolPaused = false;
		} else {
			output("No information, cannot setup controller!","warning");
		}
	}
	/*
	Load File
	*/
	public function load($file:String):Void
	{
		this.strVideoFile = $file || this.strVideoFile;
	}
	/*
	Play Function
	*/
	public function play($file:String):Void
	{
		output("Play");
		this.resetBuffer();
		this.load($file);
		this.clearCuePoints();
		this.objStatusTrigger.start(0.02);
		this.objNetStream.play(this.strVideoFile);
		this.broadcastEvent(new Event("onPlay", this, {file:this.strVideoFile, stream:this.objNetStream}));
	}
	/*
	Pause Function
	*/
	public function pause():Boolean
	{
		output("Pause");
		if (!this.bolPaused) {
			this.bolPaused = true;
		} else {
			this.bolPaused = false;
		}
		this.objNetStream.pause();
		this.broadcastEvent(new Event("onPause", this, {file:this.strVideoFile, stream:this.objNetStream}));
		return this.bolPaused;
	}
	/*
	Stops video stream by closing the NetStream connection.
	*/
	public function stop():Void
	{
		output("Stop");
		this.bolPaused = false;
		this.objNetStream.close();
		this.objStatusTrigger.stop();
		this.broadcastEvent(new Event("onStop", this, {file:this.strVideoFile, stream:this.objNetStream}));
	}
	/*
	Seek to a point in the video passing a number in seconds.
	*/
	public function seek($position:Number):Void
	{
		this.objNetStream.seek($position);
		this.broadcastEvent(new Event("onSeek", this, {file:this.strVideoFile, stream:this.objNetStream}));
	}
	/*
	Fast Forward Function
	*/
	public function fastforward($increment:Number):Void
	{
		var numIncrement:Number = $increment || 10;
		var numPosition:Number = Math.round(this._position + numIncrement);
		if (numPosition > this._duration) {
			numPosition = this._duration;
			this.objNetStream.seek(numPosition);
			this.stop();
		}
		this.objNetStream.seek(numPosition);
		this.broadcastEvent(new Event("onFastForward", this, {file:this.strVideoFile, stream:this.objNetStream}));
	}
	/*
	Rewind Function
	*/
	public function rewind($increment:Number)
	{
		var numIncrement:Number = $increment || 10;
		var numPosition:Number = Math.round(this._position - numIncrement);
		if (numPosition < 0) {
			numPosition = 0;
		}
		this.objNetStream.seek(numPosition);
		this.broadcastEvent(new Event("onRewind", this, {file:this.strVideoFile, stream:this.objNetStream}));
	}
	/*
	Return Playhead position in seconds
	*/
	public function getPosition():Number
	{
		return this.objNetStream.time;
	}
	public function getPercentagePosition($percent:Number):Number
	{
		return (this.objMetaData.duration * ($percent / 100));
	}
	/*
	Save Meta Data
	*/
	private function parseMetaData($data:Object)
	{
		this.objMetaData = new Object();
		for (var i in $data) {
			if (i != "cuePoints") {
				this.objMetaData[i] = $data[i];
			} else {
				this.setCuePoints($data[i]);
			}
		}
	}
	private function getMetaData():Object
	{
		return this.objMetaData;
	}
	/*
	Internal calculation functions
	*/
	private function calculateVideoProgress():Number
	{
		var numProgress:Number = Math.round((this.objNetStream.time / this.objMetaData.duration) * 100);
		if (isNaN(numProgress)) {
			numProgress = 0;
		}
		return numProgress;
	}
	private function calculateLoadingProgress():Number
	{
		var numProgress:Number = Math.round((this.objNetStream.bytesLoaded / this.objNetStream.bytesTotal) * 100);
		if (numProgress >= 100) {
			numProgress = 100;
			this.bolLoaded = true;
		}
		return numProgress;
	}
	private function calculateBufferProgress():Number
	{
		var numProgress:Number = Math.round((this.objNetStream.bufferLength / this.objNetStream.bufferTime) * 100);
		if (numProgress > 100) {
			numProgress = 100;
			this.bolBuffered = true;
		}
		return numProgress;
	}
	/*
	Cue Point Managment
	*/
	private function setCuePoints($cuePoints:Array)
	{
		this.arrCuePoints = $cuePoints;
	}
	private function getCuePoints():Array
	{
		return this.arrCuePoints;
	}
	private function clearCuePoints()
	{
		this.arrCuePoints = new Array();
	}
	/*
	Attach audio
	*/
	private function createSoundController():Void
	{
		this.mcVideoVolume = _root.createEmptyMovieClip("mcVideoVolume" + random(100000), _root.getNextHighestDepth());
		this.mcVideoVolume.attachAudio(this.objNetStream);
		this.objVideoSound = new Sound(this.mcVideoVolume);
	}
	/*
	Dispatch Events
	*/
	private function broadcastError($type:String):Void
	{
		switch ($type) {
			case "NetStream.Play.StreamNotFound" :
				this.broadcastEvent(new Event("onStreamNotFound", this, {file:this.strVideoFile, stream:this.objNetStream}));
				break;
			case "NetStream.Seek.InvalidTime" :
				this.broadcastEvent(new Event("onInvalidTime", this, {file:this.strVideoFile, stream:this.objNetStream}));
				break;
		}
	}
	private function resetBuffer():Void
	{
		this.bolBuffered = false;
	}
	private function broadcastStatus($type:String):Void
	{
		switch ($type) {
			case "NetStream.Buffer.Empty" :
				this.resetBuffer();
				this.broadcastEvent(new Event("onBufferEmpty", this, {file:this.strVideoFile, stream:this.objNetStream}));
				break;
			case "NetStream.Buffer.Full" :
				this.broadcastEvent(new Event("onBufferFull", this, {file:this.strVideoFile, stream:this.objNetStream}));
				break;
			case "NetStream.Buffer.Flush" :
				this.broadcastEvent(new Event("onBufferFlush", this, {file:this.strVideoFile, stream:this.objNetStream}));
				break;
			case "NetStream.Play.Start" :
				this.broadcastEvent(new Event("onPlayStart", this, {file:this.strVideoFile, stream:this.objNetStream}));
				break;
			case "NetStream.Play.Stop" :
				this.objStatusTrigger.stop();
				this.broadcastEvent(new Event("onPlayStop", this, {file:this.strVideoFile, stream:this.objNetStream}));
				this.broadcastEvent(new Event("onComplete", this, {file:this.strVideoFile, stream:this.objNetStream}));
				break;
			case "NetStream.Seek.Notify" :
				this.broadcastEvent(new Event("onSeekNotify", this, {file:this.strVideoFile, stream:this.objNetStream}));
				break;
		}
	}
	/*
	NetStream event handlers.
	*/
	private function cuePointHandler($objEvent:Object):Void
	{
		this.broadcastEvent(new Event("onCuePoint", this, {cuePoint:$objEvent}));
	}
	private function statusHandler($event:Object):Void
	{
		if ($event.level == "error") {
			this.broadcastError($event.code);
		} else if ($event.level == "status") {
			this.broadcastStatus($event.code);
		}
	}
	private function metadataHandler($event:Object):Void
	{
		this.parseMetaData($event);
	}
	/*
	IntervalTrigger event handler.
	*/
	private function onStatusTrigger()
	{
		this.broadcastEvent(new Event("onVideoProgress", this, {percent:this.calculateVideoProgress()}));
		if (!this.bolLoaded) {
			this.broadcastEvent(new Event("onVideoLoading", this, {percent:this.calculateLoadingProgress()}));
		}
		if (!this.bolBuffered) {
			this.broadcastEvent(new Event("onVideoBuffering", this, {percent:this.calculateBufferProgress()}));
		}
	}
	/*
	
	
	
	
	Property Definitions
	
	
	
	
	*/
	/*
	Sets the volume property of the NetStream object.
	*/
	public function set _volume($volume:Number):Void
	{
		this.objVideoSound.setVolume($volume);
	}
	public function get _volume():Number
	{
		return this.objVideoSound.getVolume();
	}
	/*
	The number of seconds assigned to the NetStream buffer property.
	*/
	public function get _bufferTime():Number
	{
		return this.objNetStream.bufferTime;
	}
	/*
	The number of seconds of data currently in the NetStream buffer.
	*/
	public function get _bufferLength():Number
	{
		return this.objNetStream.bufferLength;
	}
	/*
	The current buffer percentage.
	*/
	public function get _bufferPercent():Number
	{
		return this.calculateBufferProgress();
	}
	/*
	Returns the position of the video in seconds.
	*/
	public function get _position():Number
	{
		return this.getPosition();
	}
	/*
	Returns the duration of the video in seconds.
	*/
	public function get _duration():Number
	{
		return this.objMetaData.duration;
	}
	/*
	Returns the pause status of the video.
	*/
	public function get _paused():Boolean
	{
		return this.bolPaused;
	}
	/*
	Returns the current frame of the movie.
	*/
	public function get _currentFrames():Number
	{
		var numCurrentFrame = Math.round(this.objNetStream.time * this.objMetaData.framerate);
		if (isNaN(numCurrentFrame)) {
			numCurrentFrame = 0;
		}
		return numCurrentFrame;
	}
	/*
	Returns the total frames of the movie.
	*/
	public function get _currentFile():String
	{
		return this.strVideoFile;
	}
	/*
	Returns the total frames of the movie.
	*/
	public function get _totalFrames():Number
	{
		var numTotalFrames = Math.round(this.objMetaData.duration * this.objMetaData.framerate);
		if (isNaN(numTotalFrames)) {
			numTotalFrames = 0;
		}
		return numTotalFrames;
	}
	/*
	Enable/ Disable the status tracking 
	*/
	public function set _trackStatus($enabled:Boolean):Void
	{
		this.bolTrackStatus = $enabled;
		if (this.bolTrackStatus) {
			this.objStatusTrigger.start(0.01);
		} else {
			this.objStatusTrigger.stop();
		}
	}
	public function get _trackStatus():Boolean
	{
		return this.bolTrackStatus;
	}
}