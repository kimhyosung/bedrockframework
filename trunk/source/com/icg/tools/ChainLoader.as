package com.icg.tools
{
	/*
	Imports
	*/
	import com.icg.tools.VisualLoader;
	import com.icg.tools.BackgroundLoader;
	import flash.display.Loader;
	import com.icg.events.ChainLoaderEvent;
	import com.icg.events.LoaderEvent;
	import com.icg.madagascar.base.DispatcherWidget;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import com.icg.util.MathUtil;
	import flash.system.LoaderContext;
	/*
	Class Declaration
	*/
	public class ChainLoader extends DispatcherWidget
	{
		private var bolRunning:Boolean;
		private var bolComplete:Boolean;
		private var bolAddWhileRunning:Boolean;
		private var arrQueue:Array;
		private var numLoadIndex:uint;
		private var numTotalFiles:uint;
		private var numOverallPercentage:uint;
		private var numCurrentPercentage:uint;
		private var numTotalPercentage:uint;
		private var numLoadedPercentage:uint;		
		private var objLoaderContext:LoaderContext;

		public function ChainLoader()
		{
			this.arrQueue=new Array  ;
			this.numLoadIndex=0;
			this.bolRunning=false;
			this.bolComplete=false;
			this.bolAddWhileRunning = false;
		}
		/*
		Setup
		*/
		public function setup($context:LoaderContext):void
		{
			this.objLoaderContext = $context;
		}
		public function reset():void
		{
			this.arrQueue=new Array  ;
			this.numLoadIndex=0;
			this.bolRunning=false;
			this.bolComplete=false;
			this.numOverallPercentage = 0;
			this.numCurrentPercentage = 0;
			this.numTotalPercentage = 0;
			this.numLoadedPercentage = 0;
			this.output("Reset");
			this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.RESET,this));
		}
		public function close():void
		{
			if (this.arrQueue.length > 0) {
				var objQueueItem:Object=this.getQueueItem(this.numLoadIndex);
				objQueueItem.loader.close();
				this.removeListeners(objQueueItem.loader);
				this.reset();
				this.output("Close");
				this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.CLOSE,this));
			}
		}
		public function loadQueue():void
		{
			if (this.arrQueue.length > 0) {
				this.recalculate();
				this.begin();
			} else {
				output("Unable to load, queue is empty!","warning");
				this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.ERROR,this, {text:"Unable to load, queue is empty!"}));
			}
		}
		public function addToQueue($file:String,$loader:VisualLoader=null,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			if (this.bolComplete) {
				this.reset();
			}

			if (!this.bolRunning) {
				this.add($file, $loader, $completeHandler, $errorHandler);
			}else if (this.bolAddWhileRunning && this.bolRunning){
				this.add($file, $loader, $completeHandler, $errorHandler);
			} else {			
				this.output("Cannot add to queue while loading!","warning");
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
			this.arrQueue.push({file:strFile,loader:objLoader});
			this.recalculate();
			this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.FILE_ADDED,this,{files:this.arrQueue,index:this.numLoadIndex,total:this.numTotalFiles}));
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
			this.numTotalFiles=this.arrQueue.length;
			this.numTotalPercentage=this.numTotalFiles * 100;
		}
		private function calculateOverallPercentage($current:uint):uint
		{
			this.numLoadedPercentage=this.numLoadIndex * 100 + $current;
			this.numOverallPercentage=MathUtil.calculatePercentage(this.numLoadedPercentage,this.numTotalPercentage);
			return this.numOverallPercentage;
		}

		private function begin():void
		{
			if (! this.bolRunning) {
				this.bolRunning=true;
				this.output("Begin Load");
				this.loadURL(0);
				this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.BEGIN,this,{files:this.arrQueue,total:this.numTotalFiles}));
			}
		}

		private function loadURL($index:uint):void
		{
			this.numLoadIndex=$index;
			var objQueueItem:Object=this.getQueueItem(this.numLoadIndex);
			this.output("Loading - " + objQueueItem.file);
			objQueueItem.loader.loadURL(objQueueItem.file, this.objLoaderContext);
			this.addListeners(objQueueItem.loader);
			this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.FILE_OPEN,this,objQueueItem));
		}
		private function loadNext():void
		{
			if (this.bolRunning) {
				var numTempIndex:uint=this.numLoadIndex + 1;
				if (numTempIndex != this.numTotalFiles) {
					this.loadURL(numTempIndex);
					this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.NEXT,this,{file:this.getFile(numTempIndex),total:this.numTotalFiles, index:this.numLoadIndex}));
				} else {
					this.loadComplete();
				}
			}
		}
		private function loadComplete():void
		{
			if (!this.bolComplete) {
				this.bolComplete=true;
				this.output("Complete!");
				this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.COMPLETE,this,{total:this.numTotalFiles}));	
			}			
		}
		/*
		Getters
		*/
		public function getFile($index:int):String
		{
			return this.arrQueue[$index].file;
		}
		public function getLoader($index:int):*
		{
			return this.arrQueue[$index].loader;
		}
		private function getQueueItem($index:int):Object
		{
			return this.arrQueue[$index];
		}
		/*
		
		Event Handlers
		
		*/
		private function onFileError($event:LoaderEvent):void
		{
			output("Could not find - " + this.getFile(this.numLoadIndex) + "!","warning");
			this.loadNext();
		}
		private function onProgress($event:LoaderEvent)
		{
			this.calculateOverallPercentage($event.details.percent);
			//
			var objDetails:Object=new Object  ;
			objDetails.overallPercent=this.numOverallPercentage;
			objDetails.filePercent=$event.details.percent;
			objDetails.loadedPercent=this.numLoadedPercentage;
			objDetails.totalPercent=this.numTotalPercentage;
			objDetails.loadIndex=this.numLoadIndex;
			objDetails.totalFiles=this.numTotalFiles;
			this.dispatchEvent(new ChainLoaderEvent(ChainLoaderEvent.PROGRESS,this,objDetails));
		}
		private function onFileComplete($event:LoaderEvent)
		{
			this.removeListeners($event.target);
			this.loadNext();
		}
		/*
		Property Definitions
		*/
		public function get complete():Boolean
		{
			return this.bolComplete;
		}
		
		
		public function set addWhileRunning($status:Boolean):void
		{
			this.bolAddWhileRunning = $status;
		}
		public function get addWhileRunning():Boolean
		{
			return this.bolAddWhileRunning;
		}
		
		public function get running():Boolean
		{
			return this.bolRunning
		}
	}

}