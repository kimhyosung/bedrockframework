package com.bedrockframework.plugin.loader
{
	/*
	Imports
	*/
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.util.MathUtil;
	import com.bedrockframework.plugin.event.ChainLoaderEvent;
	import com.bedrockframework.plugin.event.LoaderEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	/*
	Class Declaration
	*/
	public class ChainLoader extends DispatcherWidget
	{
		private var _bolRunning:Boolean;
		private var _bolComplete:Boolean;
		private var _bolAddWhileRunning:Boolean;
		private var _arrQueue:Array;
		private var _numLoadIndex:uint;
		private var _numTotalFiles:uint;
		private var _numOverallPercentage:uint;
		private var _numCurrentPercentage:uint;
		private var _numTotalPercentage:uint;
		private var _numLoadedPercentage:uint;		
		private var _objLoaderContext:LoaderContext;

		public function ChainLoader()
		{
			this._arrQueue=new Array  ;
			this._numLoadIndex=0;
			this._bolRunning=false;
			this._bolComplete=false;
			this._bolAddWhileRunning = false;
		}
		/*
		Setup
		*/
		public function setup($context:LoaderContext):void
		{
			this._objLoaderContext = $context;
		}
		public function reset():void
		{
			this._arrQueue=new Array  ;
			this._numLoadIndex=0;
			this._bolRunning=false;
			this._bolComplete=false;
			this._numOverallPercentage = 0;
			this._numCurrentPercentage = 0;
			this._numTotalPercentage = 0;
			this._numLoadedPercentage = 0;
			this.status("Reset");
			this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.RESET,this));
		}
		public function close():void
		{
			if (this._arrQueue.length > 0) {
				var objQueueItem:Object=this.getQueueItem(this._numLoadIndex);
				objQueueItem.loader.close();
				this.removeListeners(objQueueItem.loader);
				this.reset();
				this.status("Close");
				this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.CLOSE,this));
			}
		}
		public function loadQueue():void
		{
			if (this._arrQueue.length > 0) {
				this.recalculate();
				this.begin();
			} else {
				this.status("Unable to load, queue is empty!","warning");
				this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.ERROR,this, {text:"Unable to load, queue is empty!"}));
			}
		}
		public function addToQueue($file:String,$loader:VisualLoader=null,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			if (this._bolComplete) {
				this.reset();
			}

			if (!this._bolRunning) {
				this.add($file, $loader, $completeHandler, $errorHandler);
			}else if (this._bolAddWhileRunning && this._bolRunning){
				this.add($file, $loader, $completeHandler, $errorHandler);
			} else {			
				this.status("Cannot add to queue while loading!","warning");
			}
			
		}
		private function add($file:String,$loader:VisualLoader=null,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			var strFile:String=$file;
			var objLoader:* =$loader || new BackgroundLoader  ;
			if ($completeHandler != null) {
				if (objLoader is BackgroundLoader) {
					objLoader.addEventListener(LoaderEvent.COMPLETE,$completeHandler,false,0,true);
				} else {
					objLoader.addEventListener(LoaderEvent.INIT,$completeHandler,false,0,true);
				}
			}
			if ($errorHandler != null) {
				objLoader.addEventListener(LoaderEvent.IO_ERROR,$errorHandler,false,0,true);
				objLoader.addEventListener(LoaderEvent.SECURITY_ERROR,$errorHandler,false,0,true);				
			}
			this._arrQueue.push({file:strFile,loader:objLoader});
			this.recalculate();
			this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.FILE_ADDED,this,{files:this._arrQueue,index:this._numLoadIndex,total:this._numTotalFiles}));
		}
		/*
		Listener Managment
		*/
		private function addListeners($target:*):void
		{
			$target.addEventListener(LoaderEvent.COMPLETE,this.dispatchEvent);
			$target.addEventListener(LoaderEvent.OPEN,this.dispatchEvent);
			$target.addEventListener(LoaderEvent.INIT,this.dispatchEvent);
			$target.addEventListener(LoaderEvent.UNLOAD,this.dispatchEvent);
			$target.addEventListener(LoaderEvent.HTTP_STATUS,this.dispatchEvent);
			$target.addEventListener(LoaderEvent.IO_ERROR,this.dispatchEvent);
			$target.addEventListener(LoaderEvent.SECURITY_ERROR,this.dispatchEvent);
			//
			$target.addEventListener(LoaderEvent.PROGRESS,this.onProgress);
			$target.addEventListener(LoaderEvent.COMPLETE,this.onFileComplete);
			$target.addEventListener(LoaderEvent.IO_ERROR,this.onFileError);
		}
		private function removeListeners($target:*):void
		{
			$target.removeEventListener(LoaderEvent.COMPLETE,this.dispatchEvent);
			$target.removeEventListener(LoaderEvent.OPEN,this.dispatchEvent);
			$target.removeEventListener(LoaderEvent.INIT,this.dispatchEvent);
			$target.removeEventListener(LoaderEvent.UNLOAD,this.dispatchEvent);
			$target.removeEventListener(LoaderEvent.HTTP_STATUS,this.dispatchEvent);
			$target.removeEventListener(LoaderEvent.IO_ERROR,this.dispatchEvent);
			$target.removeEventListener(LoaderEvent.SECURITY_ERROR,this.dispatchEvent);
			//
			$target.removeEventListener(LoaderEvent.PROGRESS,this.onProgress);
			$target.removeEventListener(LoaderEvent.COMPLETE,this.onFileComplete);
			$target.removeEventListener(LoaderEvent.IO_ERROR,this.onFileError);
		}
		/*
		
		*/
		private function recalculate():void
		{
			this._numTotalFiles=this._arrQueue.length;
			this._numTotalPercentage=this._numTotalFiles * 100;
		}
		private function calculateOverallPercentage($current:uint):uint
		{
			this._numLoadedPercentage=this._numLoadIndex * 100 + $current;
			this._numOverallPercentage=MathUtil.calculatePercentage(this._numLoadedPercentage,this._numTotalPercentage);
			return this._numOverallPercentage;
		}

		private function begin():void
		{
			if (! this._bolRunning) {
				this._bolRunning=true;
				this.status("Begin Load");
				this.loadURL(0);
				this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.BEGIN,this,{files:this._arrQueue,total:this._numTotalFiles}));
			}
		}

		private function loadURL($index:uint):void
		{
			this._numLoadIndex=$index;
			var objQueueItem:Object=this.getQueueItem(this._numLoadIndex);
			this.status("Loading - " + objQueueItem.file);
			objQueueItem.loader.loadURL(objQueueItem.file, this._objLoaderContext);
			this.addListeners(objQueueItem.loader);
			this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.FILE_OPEN,this,objQueueItem));
		}
		private function loadNext():void
		{
			if (this._bolRunning) {
				var numTempIndex:uint=this._numLoadIndex + 1;
				if (numTempIndex != this._numTotalFiles) {
					this.loadURL(numTempIndex);
					this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.NEXT,this,{file:this.getFile(numTempIndex),total:this._numTotalFiles, index:this._numLoadIndex}));
				} else {
					this.loadComplete();
				}
			}
		}
		private function loadComplete():void
		{
			if (!this._bolComplete) {
				this._bolComplete=true;
				this.status("Complete!");
				this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.COMPLETE,this,{total:this._numTotalFiles}));	
			}			
		}
		/*
		Getters
		*/
		public function getFile($index:int):String
		{
			return this._arrQueue[$index].file;
		}
		public function getLoader($index:int):*
		{
			return this._arrQueue[$index].loader;
		}
		private function getQueueItem($index:int):Object
		{
			return this._arrQueue[$index];
		}
		/*
		
		Event Handlers
		
		*/
		private function onFileError($event:LoaderEvent):void
		{
			this.status("Could not find - " + this.getFile(this._numLoadIndex) + "!","warning");
			this.loadNext();
		}
		private function onProgress($event:LoaderEvent):void
		{
			this.calculateOverallPercentage($event.details.percent);
			//
			var objDetails:Object=new Object  ;
			objDetails.overallPercent=this._numOverallPercentage;
			objDetails.filePercent=$event.details.percent;
			objDetails.loadedPercent=this._numLoadedPercentage;
			objDetails.totalPercent=this._numTotalPercentage;
			objDetails.loadIndex=this._numLoadIndex;
			objDetails.totalFiles=this._numTotalFiles;
			this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.PROGRESS,this,objDetails));
		}
		private function onFileComplete($event:LoaderEvent):void
		{
			this.removeListeners($event.target);
			this.loadNext();
		}
		/*
		Property Definitions
		*/
		public function get complete():Boolean
		{
			return this._bolComplete;
		}
		
		
		public function set addWhileRunning($status:Boolean):void
		{
			this._bolAddWhileRunning = $status;
		}
		public function get addWhileRunning():Boolean
		{
			return this._bolAddWhileRunning;
		}
		
		public function get running():Boolean
		{
			return this._bolRunning
		}
	}

}