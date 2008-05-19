package com.autumntactics.loader
{
	import com.autumntactics.events.BulkLoaderEvent;
	import com.autumntactics.events.LoaderEvent;
	import com.autumntactics.bedrock.base.DispatcherWidget;
	import com.autumntactics.storage.ArrayCollection;
	import com.autumntactics.storage.ArrayBrowser;
	import com.autumntactics.util.MathUtil;
	
	import flash.system.LoaderContext;

	public class BulkLoader extends DispatcherWidget
	{
		/*
		Variable Delarations
		*/
		private var bolRunning:Boolean;
		private var bolComplete:Boolean;
		private var bolAddWhileRunning:Boolean;
		private var arrQueue:Array;
		private var arrCurrentLoad:ArrayCollection;
		private var numMaxConcurrentLoads:uint;
		private var numLoadIndex:uint;
		private var numTotalFiles:uint;
		private var numOverallPercentage:uint;
		private var numTotalPercentage:uint;
		private var numLoadedPercentage:uint;
		
		private var objLoaderContext:LoaderContext;
		private var objQueueBrowser:ArrayBrowser;
		/*
		Constructor
		*/
		public function BulkLoader()
		{
			this.arrQueue=new Array  ;
			this.arrCurrentLoad = new ArrayCollection();
			this.numLoadIndex=0;
			this.numMaxConcurrentLoads = 2;
			this.objQueueBrowser = new ArrayBrowser();
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
		/*
		Reset
		*/
		public function reset():void
		{
			this.arrQueue=new Array();
			this.arrCurrentLoad = new ArrayCollection();
			this.objQueueBrowser.data = this.arrQueue;
			this.numLoadIndex=0;
			this.bolRunning=false;
			this.bolComplete=false;
			this.numOverallPercentage = 0;
			this.numTotalPercentage = 0;
			this.status("Reset");
			this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.RESET,this));
		}
		public function close():void
		{
			if (this.arrQueue.length > 0) {
				var numLength:uint = this.arrCurrentLoad.length;
				var objQueueItem:*
				for (var i = 0; i < numLength; i++) {
					objQueueItem = arrCurrentLoad[i];
					objQueueItem.close();
					this.removeListeners(objQueueItem);
				}				
				
				this.reset();
				this.status("Close");
				this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.CLOSE,this));
			}
		}
		public function loadQueue():void
		{
			if (this.arrQueue.length > 0) {
				this.objQueueBrowser.data = this.arrQueue;
				this.sortByPriority();
				this.recalculate();
				this.begin();
			} else {
				this.status("Unable to load, queue is empty!","warning");
				this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.ERROR,this, {text:"Unable to load, queue is empty!"}));
			}
		}
		public function addToQueue($file:String,$loader:VisualLoader=null,$priority:uint=0, $id:String=null, $completeHandler:Function=null, $errorHandler:Function=null):void
		{
			if (this.bolComplete) {
				this.reset();
			}
			if (!this.bolRunning) {
				this.add($file, $loader, $priority, $id, $completeHandler, $errorHandler);
			}else if (this.bolAddWhileRunning && this.bolRunning){
				this.add($file, $loader, $priority, $id, $completeHandler, $errorHandler);
				if (this.arrCurrentLoad.length < this.numMaxConcurrentLoads) {
					this.loadNext();
				}
			} else {			
				this.status("Cannot add to queue while loading!","warning");
			}			
		}
		private function add($file:String,$loader:VisualLoader=null,$priority:uint=0, $id:String=null, $completeHandler:Function=null, $errorHandler:Function=null):void
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
			this.arrQueue.push({file:strFile,loader:objLoader,priority:$priority, id:$id, percent:0});
			this.recalculate();
			this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.FILE_ADDED,this,{files:this.arrQueue,index:this.numLoadIndex,total:this.numTotalFiles}));
		}
		/*
		Current Load Managment
		*/
		private function addToCurrentLoad($loader:*):void
		{
			this.arrCurrentLoad.push($loader);
		}
		private function removeFromCurrentLoad($loader:*):void
		{
			var objBrowser:ArrayBrowser = new ArrayBrowser(this.arrCurrentLoad);
			arrCurrentLoad.remove(objBrowser.findIndex($loader));
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
		Calculate Percentage
		*/
		private function recalculate():void
		{
			this.numTotalFiles=this.arrQueue.length;
			this.numTotalPercentage=this.numTotalFiles * 100;
		}
		private function calculateOverallPercentage():uint
		{
			this.numLoadedPercentage = 0;
			var numLength:uint = this.arrQueue.length;
			for (var i = 0 ; i < numLength; i ++) {
				this.numLoadedPercentage += this.arrQueue[i].percent;
			}			
			this.numOverallPercentage=MathUtil.calculatePercentage(this.numLoadedPercentage,this.numTotalPercentage);
			return this.numOverallPercentage;
		}
		private function sortByPriority():void
		{
			this.arrQueue.sortOn(["priority"], Array.NUMERIC | Array.DESCENDING);
		}
		/*
		Begin Downloading Queued Files
		*/
		private function begin():void
		{
			if (! this.bolRunning) {
				this.bolRunning=true;
				this.status("Begin Load");
				var numLength:int = (this.numTotalFiles >= this.numMaxConcurrentLoads) ? this.numMaxConcurrentLoads : this.arrQueue.length;
				for (var i = 0; i < numLength; i ++) {
					this.loadURL(i);
				}
				this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.BEGIN,this,{total:this.numTotalFiles}));
			}
		}

		private function loadURL($index:uint):void
		{
			this.numLoadIndex=$index;
			var objQueueItem:Object=this.getQueueItem(this.numLoadIndex);
			this.status("Loading - " + objQueueItem.file);
			objQueueItem.loader.loadURL(objQueueItem.file, this.objLoaderContext);
			this.addListeners(objQueueItem.loader);
			this.addToCurrentLoad(objQueueItem.loader);
			this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.FILE_OPEN,this,objQueueItem));
		}
		private function loadNext():void
		{
			if (this.bolRunning) {
				var numTempIndex:uint=this.numLoadIndex + 1;
				if (numTempIndex != this.numTotalFiles) {
					var objQueueItem:Object = this.getQueueItem(numTempIndex);
					this.loadURL(numTempIndex);
					this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.NEXT,this,{file:objQueueItem.file,total:this.numTotalFiles, index:this.numLoadIndex}));
				} else {
					this.loadComplete();
				}
			}
		}
		private function loadComplete():void
		{
			this.calculateOverallPercentage();
			if (!this.bolComplete) {
				this.bolComplete=true;
				this.status("Complete!");
				this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.COMPLETE,this,{total:this.numTotalFiles}));
			}
			
		}
		/*
		Getters
		*/
		
		public function getLoader($id:String):*
		{
			var objBrowser:ArrayBrowser = new ArrayBrowser(this.arrQueue);
			return objBrowser.findItem($id, "id").loader;
		}
		
		public function getQueueItem($index:int):Object
		{
			return this.arrQueue[$index];
		}
		private function getQueueItemByLoader($loader:*):Object
		{
			var objBrowser:ArrayBrowser = new ArrayBrowser(this.arrQueue);
			return objBrowser.findItem($loader, "loader");
		}
		/*
		
		Event Handlers
		
		*/
		private function onFileError($event:LoaderEvent):void
		{
			var objQueueItem:Object = this.getQueueItemByLoader($event.target);
			this.status("Could not find - " + objQueueItem.file + "!","warning");
			this.removeFromCurrentLoad($event.target);
			this.loadNext();
		}
		private function onProgress($event:LoaderEvent):void
		{
			var objQueueItem:Object = this.getQueueItemByLoader($event.target);
			objQueueItem.percent = $event.details.percent;
			//
			this.calculateOverallPercentage();
			//
			var objDetails:Object=new Object  ;
			objDetails.overallPercent=this.numOverallPercentage;
			objDetails.filePercent=$event.details.percent;
			objDetails.loadedPercent=this.numLoadedPercentage;
			objDetails.totalPercent=this.numTotalPercentage;
			objDetails.loadIndex=this.numLoadIndex;
			objDetails.totalFiles=this.numTotalFiles;

			this.dispatchEvent(new BulkLoaderEvent(BulkLoaderEvent.PROGRESS,this,objDetails));
		}
		private function onFileComplete($event:LoaderEvent):void
		{
			this.removeFromCurrentLoad($event.target);
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
		
		public function get running():Boolean
		{
			return this.bolRunning
		}
		
		public function set addWhileRunning($status:Boolean):void
		{
			this.bolAddWhileRunning = $status;
		}
		public function get addWhileRunning():Boolean
		{
			return this.bolAddWhileRunning;
		}
		
		public function set cuncurrentLoads($count:uint):void
		{
			this.numMaxConcurrentLoads = $count;			
		}
		public function get cuncurrentLoads():uint
		{
			return this.numMaxConcurrentLoads;			
		}
	}
}